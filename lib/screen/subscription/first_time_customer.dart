import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/subscription_perks.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:io';
import 'package:flutter_fitfit/model/subs_products_model.dart';

void main() {
  runApp(FirstTimeCustomerSubscriptionPage());
}

const bool kAutoConsume = true;

const String _kConsumableId = 'subscription';
const List<String> _kProductIds = <String>[
  'smartpt_1month',
  'smartpt_3month',
  'smartpt_12month'
];

class FirstTimeCustomerSubscriptionPage extends StatefulWidget {
  @override
  _FirstTimeCustomerSubscriptionPageState createState() => _FirstTimeCustomerSubscriptionPageState();

  static const routeName = '/first-time-subscription';
}

class _FirstTimeCustomerSubscriptionPageState extends State<FirstTimeCustomerSubscriptionPage> {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;
  String selectedPlanId;


  @override
  void initState() {        
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    InAppPurchaseConnection.enablePendingPurchases();
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
 

    // completePurchase(ProductDetailsResponse res) async{
    //   var url = 'http://localhost:3000/api/savePurchase';
    //   var response = await http.post(url, body: res.productDetails);
    //   print(response);
    // }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      // completePurchase(productDetailResponse);
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
        if(Platform.isIOS){
          print(">>>>"+"in ios");
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
      }
    }
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: [
            _buildProductList(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

     void purchaseProduct(String planId) async{
        const Set<String> _kIds = {'smartpt_1month','smartpt_3month','smartpt_12month'};
        final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
        if (response.notFoundIDs.isNotEmpty) {
            // Handle the error.
        }
        List<ProductDetails> products = response.productDetails;

        for(var i = 0 ; i < products.length ; i++){
          if(products[i].id == planId){
            final ProductDetails productDetails = products[i]; 
            final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);      
            InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
          }
        }
    setState(() {
      selectedPlanId = planId;
    });
  }

      Widget subscriptionButton(String title, String desc, String discount, String planId, String id) {
    return GestureDetector(
      onTap: () => purchaseProduct(id),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10, 16, 10, 0),
        height: 71,
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColor.primary, width: 1),
          borderRadius: BorderRadius.circular(50.0),
          // gradient: LinearGradient(
          //   colors: selectedPlanId == planId ? ThemeColor.fusion01 : ThemeColor.disabled,
          // ),
        ),
        child: Stack(
          children: <Widget>[
            discount != null ? Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width * 0.75,
              child: Container(
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: ThemeColor.fusion01,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1],
                  ),
                  border: Border.all(color: ThemeColor.black[08]),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                height: 24,
                width: 62,
                child: Center(
                  child: Text(
                    '$discount Off',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: NunitoStyle.caption1.copyWith(color: ThemeColor.white)
                  ),
                )
              ),
            ) : Container(),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(title,
                      style: NunitoStyle.button2
                          .copyWith(color: ThemeColor.black[80])),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(desc,
                      style: NunitoStyle.caption1
                          .copyWith(color: ThemeColor.black[56]))
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

    return MaterialApp(
      home: Scaffold(
      backgroundColor: ThemeColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.asset(Utility.imagePath + 'welcome_bg2.jpg', fit: BoxFit.cover),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'START YOUR FITNESS JOURNEY WITH A',
                              style: NunitoStyle.title.copyWith(
                                color: ThemeColor.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w100
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'Smart Personal Training Plan',
                              style: NunitoStyle.title.copyWith(color: ThemeColor.white, fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SubscriptionPerks(),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    subscriptionButton(
                      '1 Month • RM10.50/mo',
                      'Billed monthly (Only RM3.33 per day)',
                      null,
                      'PLAN_01',
                      'smartpt_1month'
                    ),
                    subscriptionButton(
                      '3 Month • RM8.50/3mo',
                      'Billed every 3 months (Only RM3.33 per day)',
                      '50%',
                      'PLAN_02',
                      'smartpt_3month'
                    ),
                    subscriptionButton(
                      '12 Month • RM9.50/12mo',
                      'Billed annually (Only RM3.33 per day)',
                      '20%',
                      'PLAN_03',
                      'smartpt_12month'
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return Card(child: ListTile(title: const Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text(
          'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...'))));
    }
    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(title: Text('Products for Sale'));
    List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }    

    
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        PurchaseDetails previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : FlatButton(
                    child: Text(productDetails.price),
                    color: Colors.green[800],
                    textColor: Colors.white,
                    onPressed: () {
                      PurchaseParam purchaseParam = PurchaseParam(
                          productDetails: productDetails,
                          applicationUserName: null,
                          sandboxTesting: true);
                      if (productDetails.id == _kConsumableId) {
                        _connection.buyConsumable(
                            purchaseParam: purchaseParam,
                            autoConsume: kAutoConsume || Platform.isIOS);
                      } else {
                        _connection.buyNonConsumable(
                            purchaseParam: purchaseParam);
                      }
                    },
                  ));
      },
    ));

    return Card(
        child:
            Column(children: <Widget>[productHeader, Divider()] + productList));
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...'))));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return Card();
    }
    final ListTile consumableHeader =
        ListTile(title: Text('Purchased consumables'));
    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () => consume(id),
        ),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      Divider(),
      GridView.count(
        crossAxisCount: 5,
        children: tokens,
        shrinkWrap: true,
        padding: EdgeInsets.all(16.0),
      )
    ]));
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }
}
