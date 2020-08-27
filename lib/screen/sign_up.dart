import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_fitfit/provider/auth_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/screen/verification_code.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/snackbar_ff.dart';
import 'package:flutter_fitfit/widget/text_field.dart';
// import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget{
  static const routeName = '/signup';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signupFormKey = GlobalKey<FormState>();
  final Future<bool> _isAvailableFuture = AppleSignIn.isAvailable();

  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.clear();
    passwordController.clear();

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
                    'Sign up',
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
    // _authProvider.resetAuthModel();

    final emailField = TextFieldWidget(
      placeholder: 'Email',
      controller: emailController,
      onValueChanged: (val) => _authProvider.email = val,
    );
    final passwordField = TextFieldWidget(
      placeholder: 'Password',
      obscureText: true,
      validator: (val) => val.length < 6 ? 'Password too short.' : null,
      controller: passwordController,
      onValueChanged: (val) => _authProvider.password = val,
    );

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Form(
            key: _signupFormKey,
            child: Column(
              children: <Widget>[
                // Padding(
                //   padding: EdgeInsets.fromLTRB(0.0,40.0,0.0,12.0),
                //   child: emailField,
                // ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 12.0),
                //   child: passwordField,
                // ),
                // Consumer<AuthProvider>(
                //   builder: (_, _provider, __) {
                //     return CtaButton(
                //       _provider.isLoading ? 'Signing up...' :'Sign Up',
                //       disabled: _provider.password == null || _provider.email == null || _provider.isLoading,
                //       onPressed: (context) => _performSignUp(context, _provider),
                //     );
                //   },
                // ),
                
                Selector<AuthProvider,bool>(
                  selector: (context, provider) => provider.isLoading,
                  builder: (context, isLoading, _) => RaisedButton(
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
                            isLoading ? 'Signing up...' : 'Sign Up with Facebook',
                            textAlign: TextAlign.center,
                            style: NunitoStyle.button2.copyWith(
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => isLoading ? null : initiateFacebookLogin(context),
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
                    future: _isAvailableFuture,
                    builder: (context, isAvailableSnapshot) {
                      if (!isAvailableSnapshot.hasData) {
                        return Container(child: Text('Loading...'));
                      }

                      return isAvailableSnapshot.data
                        ? Selector<AuthProvider, bool>(
                          selector: (context, provider) => provider.isLoading,
                          builder: (context, isLoading, _) => RaisedButton(
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
                                    isLoading ? 'Signing up...' : 'Sign In with Apple',
                                    textAlign: TextAlign.center,
                                    style: NunitoStyle.button2.copyWith(
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () => isLoading ? null : initiateAppleLogin(context),
                          ),
                        )
                        : null;
                    }
                  )
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
                Selector<AuthProvider, bool>(
                  selector: (context, provider) => provider.isLoading,
                  builder: (context, isLoading, _) => RaisedButton(
                    color: ThemeColor.primaryDark,
                    elevation: 0.0,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeColor.btnDisable,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: FaIcon(
                              FontAwesomeIcons.envelope,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            isLoading ? 'Signing up...' : 'Sign Up with Email',
                            textAlign: TextAlign.center,
                            style: NunitoStyle.button2.copyWith(
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => null,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Text(
                        'By continuing, you agree to our ',
                        textAlign: TextAlign.center,
                        style: NunitoStyle.body2.copyWith(
                          color: ThemeColor.black[80],
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'Privacy Policy',
                          style: NunitoStyle.body2.copyWith(
                            color: ThemeColor.black[80],
                            decoration: TextDecoration.underline
                          ),
                        ),
                        onTap: () => _launchUrl('https://www.fitfitapp.co/privacy-policy')
                      ),
                      Text(
                        ', ',
                        style: NunitoStyle.body2.copyWith(
                          color: ThemeColor.black[80],
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'Terms of Use',
                          style: NunitoStyle.body2.copyWith(
                            color: ThemeColor.black[80],
                            decoration: TextDecoration.underline
                          ),
                        ),
                        onTap: () => _launchUrl('https://www.fitfitapp.co/terms-of-use')
                      ),
                      Text(
                        ', and ',
                        style: NunitoStyle.body2.copyWith(
                          color: ThemeColor.black[80],
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'Billing Terms',
                          style: NunitoStyle.body2.copyWith(
                            color: ThemeColor.black[80],
                            decoration: TextDecoration.underline
                          ),
                        ),
                        onTap: () => _launchUrl('https://www.fitfitapp.co/billing-terms')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Have an account?',
                style: NunitoStyle.body1.copyWith(
                  color: ThemeColor.black[80],
                ),
              ),
              FlatButton(
                child: Text(
                  'Log in here',
                  style: NunitoStyle.body1.copyWith(
                    color: ThemeColor.black[80],
                    decoration: TextDecoration.underline
                  ),
                ),
                padding: EdgeInsets.all(0),
                onPressed: () => Nav.navigateTo(LoginPage.routeName),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _performSignUp(context, AuthProvider provider) async{
    if (!_signupFormKey.currentState.validate()) return;
    bool signUpSuccess = await provider.signUp();

    if (!signUpSuccess) {
      _showFailedSignupSnackbar(
        context,
        provider.errorMsg,
      );
      return;
    }

    _toNextPage(provider);
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  void initiateFacebookLogin(context) async {
    // TODO: need to refractor this to use by consumer instead
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    bool loggedIn = await provider.loginFb();
    if(!loggedIn) return;

    _toNextPage(provider);
  }

  void initiateAppleLogin(context) async {
    // TODO: need to refractor this to use by consumer instead
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    bool loggedIn = await provider.loginApple();
    if(!loggedIn) return;

    _toNextPage(provider);
  }

  _showFailedSignupSnackbar(context, errorMsg) {
    FlushbarFF.showFlushBar(errorMsg, type: SnackBarFFType.error).show(context);
    return;
  }

  _toNextPage(AuthProvider provider) {
    if (!provider.isVerified) {
      Nav.navigateTo(VerificationCodePage.routeName);
      return;
    }

    Nav.clearAllAndPush(HomePage.routeName);
  }

  void _launchUrl(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}