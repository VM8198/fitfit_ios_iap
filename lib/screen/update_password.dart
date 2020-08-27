import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/text_field.dart';
import 'package:flutter_fitfit/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class UpdatePasswordPage extends StatefulWidget{
  static const routeName = '/update-password';

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  
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
                    'Change Password',
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

//MING HELP MEEEEEEEEE
  Widget _form(context) {
    AuthProvider _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authProvider.reset();

    final currentPasswordField = TextFieldWidget(
      placeholder: '',
      keyboardType: TextInputType.text,
      validator: (val) => val.length < 6 ? 'Password too short.' : null,
    );
    final newPasswordField = TextFieldWidget(
      placeholder: '',
      keyboardType: TextInputType.text,
      validator: (val) => val.length < 6 ? 'Password too short.' : null,
    );

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0,40.0,0.0,12.0),
                  child: new Text("Current Password", textAlign: TextAlign.left, style: NunitoStyle.title2.copyWith(color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0),
                  child: currentPasswordField,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0,20.0,0.0,12.0),
                  child: new Text("New Password", textAlign: TextAlign.left, style: NunitoStyle.title2.copyWith(color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0),
                  child: newPasswordField,
                ),
                Consumer<AuthProvider>(
                  builder: (_, _provider, __) {
                    return CtaButton(
                      _provider.isLoading ? 'Password updating..' :'Update Password',
                      // disabled: _provider.currentPassword == null || _provider.newPassword == null || _provider.isLoading,
                      onPressed: (context) => _performUpdatePassword(context, _provider),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _performUpdatePassword(context, AuthProvider provider) async{
    // if (!_updatePasswordFormKey.currentState.validate()) return;
    // bool updatePasswordSuccess = await provider.signUp();

    // if (!updatePasswordSuccess) {
    //   _showFailedUpdateSnackbar(
    //     context,
    //     provider.errorMsg,
    //   );
    //   return;
    // }

    // _toNextPage(provider);
  }

}