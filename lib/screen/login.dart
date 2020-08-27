import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/auth_provider.dart';
import 'package:flutter_fitfit/screen/forgot_password.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/screen/sign_up.dart';
import 'package:flutter_fitfit/screen/verification_code.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/validator.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/snackbar_ff.dart';
import 'package:flutter_fitfit/widget/text_field.dart';
// import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class LoginPage extends StatelessWidget{
  static const routeName = '/login';
  final _formKey = GlobalKey<FormState>();
  final Future<bool> _isAppleSignInAvailable = AppleSignIn.isAvailable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ), 
              backgroundColor: Colors.white,
              pinned: true,
              expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                title: Container(
                  child: Text(
                    'Log In',
                    style: NunitoStyle.h3.copyWith(color: ThemeColor.black[100]),
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverFillRemaining(
              child: _form(context),
            ),
          ]
        ),
      ),
    );
  }

  Widget _form(context) {
    AuthProvider _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authProvider.reset();
    _authProvider.resetAuthModel();

    final emailField = TextFieldWidget(
      placeholder: 'Email',
      onValueChanged: (val) => _authProvider.email = val,
      validator: (val) => Validator.isEmail(val) ? null : 'Invalid email format',
    );

    final passwordField = TextFieldWidget(
      placeholder: 'Password',
      obscureText: true,
      onValueChanged: (val) => _authProvider.password = val,
      validator: (val) => val.length < 8 ? 'Password length at least 8 or more chracters' : null,
    );

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0,40.0,0.0,12.0),
                  child: emailField,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: passwordField,
                ),
                Consumer<AuthProvider>(
                  builder: (_, _provider, __) {
                    return CtaButton(
                      _provider.isLoading ? 'Signing in...' :'Log In',
                      disabled: _provider.password == null || _provider.email == null || _provider.isLoading,
                      onPressed: (context) => _performLogin(context, _provider),
                    );
                  },
                ),
                FlatButton(
                  child: Text(
                    'Forgot Password?',
                    style: NunitoStyle.body1.copyWith(
                      color: ThemeColor.black[80],
                      decoration: TextDecoration.underline
                    ),
                  ),
                  onPressed: () => Nav.navigateTo(ForgotPasswordPage.routeName),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color: ThemeColor.black[24],
                            height: 36,
                          ),
                        ),
                      ),
                      Text(
                        "OR",
                        style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
                      ),        
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: ThemeColor.black[24],
                            height: 36,
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, provider, _) => RaisedButton(
                    color: ThemeColor.primaryDark,
                    elevation: 0.0,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: ThemeColor.facebookFusion,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: FaIcon(
                              FontAwesomeIcons.facebookSquare,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            provider.isLoading ? 'Signing in...' : 'Log In with Facebook',
                            textAlign: TextAlign.center,
                            style: NunitoStyle.button2.copyWith(
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => initiateFacebookLogin(context, provider),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Divider(
                            color: ThemeColor.white,
                            height: 18,
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
                SizedBox(
                  child: FutureBuilder<bool>(
                    future: _isAppleSignInAvailable,
                    builder: (context, isAvailableSnapshot) {
                      if (!isAvailableSnapshot.hasData) {
                        return Container(child: Text('Loading...'));
                      }

                      return isAvailableSnapshot.data
                        ? Consumer<AuthProvider>(
                          builder: (context, provider, _) => RaisedButton(
                            color: ThemeColor.primaryDark,
                            elevation: 0.0,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.apple,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    provider.isLoading ? 'Signing in...' : 'Sign In with Apple',
                                    textAlign: TextAlign.center,
                                    style: NunitoStyle.button2.copyWith(
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () => initiateAppleLogin(context),
                          ),
                        )
                        : null;
                    }
                  )
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New to Fit Fit? ',
                style: NunitoStyle.body1.copyWith(
                  color: ThemeColor.black[80],
                ),
              ),
              FlatButton(
                child: Text(
                  'Sign up here',
                  style: NunitoStyle.body1.copyWith(
                    color: ThemeColor.black[80],
                    decoration: TextDecoration.underline
                  ),
                ),
                padding: EdgeInsets.all(0),
                onPressed: () => Nav.navigateTo(SignUpPage.routeName),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _performLogin(context, AuthProvider provider) async{
    if (!_formKey.currentState.validate()) return;
    bool loggedIn = await provider.login();

    if (!loggedIn) {
      _showFailedLoginSnackbar(
        context,
        provider.errorMsg,
      );
      return;
    }
    
    _toNextPage(provider);
  }

  void initiateFacebookLogin(context, AuthProvider provider) async {
    bool loggedIn = await provider.loginFb();
    if (!loggedIn) {
      _showFailedLoginSnackbar(
        context,
        provider.errorMsg,
      );
      return;
    }

    _toNextPage(provider);
  }

  void initiateAppleLogin(context) async {
    // TODO: need to refractor this to use by consumer instead
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    bool loggedIn = await provider.loginApple();
    if(!loggedIn) return;

    _toNextPage(provider);
  }
  
  _showFailedLoginSnackbar(context, errorMsg) {
    FlushbarFF.showFlushBar(errorMsg, type: SnackBarFFType.error).show(context);
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