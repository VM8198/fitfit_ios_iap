import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/text_field.dart';

class ForgotPasswordPage extends StatelessWidget{
  static const routeName = '/forgot-password';
  final _formKey = GlobalKey<FormState>();

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
                    'Forgot Password',
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

    final emailField = TextFieldWidget(
      placeholder: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (val) => val.length == 0 ? 'Please fill up email' : null
    );
    bool _shouldSubmitDisabled = false;

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
                CtaButton(
                  'Reset Password',
                  disabled: _shouldSubmitDisabled,
                  onPressed: (context) {
                    var haha = _formKey.currentState.validate();
                    print(haha);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}