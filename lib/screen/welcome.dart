
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/screen/sign_up.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/logo.dart';
import 'login.dart';

class WelcomePage extends StatelessWidget{
  static const routeName = '/welcome';
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Utility.imagePath + 'welcome_bg2.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment(-0.1, 1)
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Logo(
                        type: LogoType.transparent,
                        width: 80.0,
                      ),
                      FlatButton(
                        child: Text(
                          'Log In',
                          style: NunitoStyle.body1,
                        ),
                        color: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 8.0),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.white)
                        ),
                        onPressed: () => Nav.navigateTo(LoginPage.routeName),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Welcome to FitFit',
                          textAlign: TextAlign.center,
                          style: NunitoStyle.h2.copyWith(
                            color: Colors.white
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0,bottom: 28.0),
                          child: RichText(
                            text: TextSpan(
                              text: '“It’s never too late to be what you might have been.”',
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' - George Eliot',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                )
                              ],
                              style: NunitoStyle.h4.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                height: 1.5
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        CtaButton(
                          'Get Started',
                          onPressed: (context) => Nav.navigateTo(SignUpPage.routeName),
                        ),
                        SizedBox(height: 40,)
                        // FlatButton(
                        //   child: Text(
                        //     'Continue as Guest',
                        //     style: NunitoStyle.body1.copyWith(
                        //       color: Colors.white,
                        //       decoration: TextDecoration.underline
                        //     ),
                        //   ),
                        //   onPressed: () => Nav.navigateTo(HomePage.routeName),
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}