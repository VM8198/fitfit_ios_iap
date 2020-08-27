import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/auth_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/snackbar_ff.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerificationCodePage extends StatefulWidget{
  static const routeName = '/verification';

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  bool _showTimer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ), 
              backgroundColor: Colors.white,
              pinned: true,
              expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                title: Container(
                  child: Text(
                    'Verfication Code',
                    style: NunitoStyle.h3.copyWith(color: ThemeColor.black[100]),
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _descriptionParagraph(),
                  _verificationInput(context),
                  _button()
                ]
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _descriptionParagraph(){
    return Column(
      children: <Widget>[
        Text(
          'Please enter the verification code sent to',
          style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Consumer<AuthProvider>(
            builder: (_, _provider, __) {
              return Text(
                '${_provider.email}',
                style: NunitoStyle.body1.copyWith(color: ThemeColor.black[100]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _verificationInput(context){
    final int length = 6;
    AuthProvider _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authProvider.reset();
    // _authProvider.resetAuthModel();
    
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: PinCodeTextField(
          length: length,
          obsecureText: false,
          animationType: AnimationType.none,
          shape: PinCodeFieldShape.underline,
          inactiveColor: ThemeColor.black[24],
          activeColor: ThemeColor.primary,
          selectedColor: ThemeColor.primary,
          animationDuration: Duration(milliseconds: 300),
          autoFocus: true,
          textInputType: TextInputType.number,
          fieldHeight: 50,
          fieldWidth: 40,
          controller: TextEditingController(text: _authProvider.verificationCode),
          onChanged: (value) {
            _authProvider.verificationCode = value != '' ? int.parse(value) : null;
          }, 
        )
      ),
    );
  }

  Widget _button(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Consumer<AuthProvider>(
            builder: (_, _provider, __){
              return CtaButton(
                'Submit',
                disabled: _provider.verificationCode == null || _provider.verificationCode.toString().length != 6 || _provider.isLoading,
                onPressed: (context) => _performVerifyCode(context, _provider),
              );
            }
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _showTimer ? <Widget>[
                Text(
                  'You can request for a new code in ',
                  style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                ),
                // CountDown(
                //   seconds: 120,
                //   style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                //   onTimer: () {
                //     setState(() {
                //       _showTimer = false;
                //     });
                //   },
                // ),
              ] : <Widget>[
                Consumer<AuthProvider>(
                  builder: (_, _provider, __){
                    return FlatButton(
                      child: Text(
                        'Resend Code',
                        style: NunitoStyle.body2.copyWith(
                          color: ThemeColor.black[80],
                          decoration: TextDecoration.underline
                        ),
                      ),
                      onPressed: () => _performResendVerifyCode(context, _provider)
                    );
                  },
                )
              ],
            ),
          )
        ],
      )
    );
  }

  void _performVerifyCode(context, AuthProvider provider) async{
    bool verified = await provider.submitVerificationCode();

    if (!verified) {
      _showFailedVerificationCodeSnackbar(
        context,
        provider.errorMsg,
      );
      return;
    }
    
    _toNextPage(provider);
  }

  void _performResendVerifyCode(context, AuthProvider provider) async{
    bool success = await provider.resendVerificationCode();

    if (!success) {
      _showFailedVerificationCodeSnackbar(
        context,
        provider.errorMsg,
      );
      return;
    }

    setState(() {
      _showTimer = true;
    });
  }

  _showFailedVerificationCodeSnackbar(context, errorMsg) {
    SnackBarFF snackbar = SnackBarFF(
      title: errorMsg,
      type: SnackBarFFType.error,
    );
  
    Scaffold.of(context).showSnackBar(snackbar);
    return;
  }


  _toNextPage(AuthProvider provider) {
    if (!provider.isVerified) {
      Nav.clearAllAndPush(VerificationCodePage.routeName);
      return;
    }

    Nav.clearAllAndPush(HomePage.routeName);
  }
}