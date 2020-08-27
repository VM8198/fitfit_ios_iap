import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/subscription_perks.dart';

class ReturningCustomerSubscriptionPage extends StatefulWidget {
  static const routeName = '/first-time-subscription';

  @override
  _ReturningCustomerSubscriptionPageState createState() => _ReturningCustomerSubscriptionPageState();
}

class _ReturningCustomerSubscriptionPageState extends State<ReturningCustomerSubscriptionPage> {
  String selectedPlanId;

  void _clickButton(String planId){
    setState(() {
      selectedPlanId = planId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text('We can\'t wait for you to try the new features we\'ve added since you\'ve been away.'),
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
                      'PLAN_01'
                    ),
                    subscriptionButton(
                      '3 Month • RM8.50/3mo',
                      'Billed every 3 months (Only RM3.33 per day)',
                      '50%',
                      'PLAN_02'
                    ),
                    subscriptionButton(
                      '12 Month • RM9.50/12mo',
                      'Billed annually (Only RM3.33 per day)',
                      '20%',
                      'PLAN_03'
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subscriptionButton(String title, String desc, String discount, String planId) {
    return GestureDetector(
      onTap: () => _clickButton(planId),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10, 16, 10, 0),
        height: 71,
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColor.primary, width: 1),
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
            colors: selectedPlanId == planId ? ThemeColor.fusion01 : ThemeColor.disabled,
          ),
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
}