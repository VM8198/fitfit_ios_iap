import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fitfit/api/api.dart';
import 'package:flutter_fitfit/asset/theme/fitfit_icon.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/auth_provider.dart';
import 'package:flutter_fitfit/provider/homepage_provider.dart';
import 'package:flutter_fitfit/screen/welcome.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/pref.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../subscription/first_time_customer.dart';

final String appVersion = '1.1.0';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState(){
    super.initState();
  }

  Widget _topBar(){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Center(
              child: Text(
                'Settings',
                style: NunitoStyle.h4.copyWith(color: ThemeColor.black[100]),
              ),
            ),
          ),
          BackButton(),
        ],
      ),
    );
  }

  Widget _accountSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Account',
            style: NunitoStyle.caption1.copyWith(color: ThemeColor.black[80]),
          ),
        ),
        Container(
          color: ThemeColor.white,
          child: Column(
            children: <Widget>[
              _renderListTile(
                title: 'Change Password',
                leadingIcon: FitFitIcon.lock,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _launchUrl('https://fitfitapp.co/support')
              ),
              _renderListTile(
                title: 'My Subscriptions',
                leadingIcon: Icons.subscriptions,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => FirstTimeCustomerSubscriptionPage()))
              ),
              _renderListTile(
                title: 'Code Redemption',
                leadingIcon: Icons.redeem,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _sendContactEmail()
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _supportSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'SUPPORT',
            style: NunitoStyle.caption1.copyWith(color: ThemeColor.black[80]),
          ),
        ),
        Container(
          color: ThemeColor.white,
          child: Column(
            children: <Widget>[
              _renderListTile(
                title: 'Help',
                leadingIcon: FitFitIcon.help,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _launchUrl('https://fitfitapp.co/support')
              ),
              _renderListTile(
                title: 'Feedback',
                leadingIcon: Icons.feedback,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _launchUrl('mailto:help@fitfitapp.co?subject=Feedback')
              ),
              _renderListTile(
                title: 'Contact Us',
                leadingIcon: FitFitIcon.mail,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _sendContactEmail()
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _aboutSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'ABOUT',
            style: NunitoStyle.caption1.copyWith(color: ThemeColor.black[80]),
          ),
        ),
        Container(
          color: ThemeColor.white,
          child: Column(
            children: <Widget>[
              _renderListTile(
                title: 'Terms & Conditions',
                leadingIcon: Icons.description,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _launchUrl('https://www.fitfitapp.co/terms-of-use')
              ),
              _renderListTile(
                title: 'Privacy Policy',
                leadingIcon: Icons.lock,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _launchUrl('https://www.fitfitapp.co/privacy-policy')
              ),
              _renderListTile(
                title: 'Billing Terms',
                leadingIcon: Icons.attach_money,
                trailingItem: Icon(Icons.chevron_right, color: ThemeColor.black[56]),
                onTap: () => _launchUrl('https://www.fitfitapp.co/billing-terms')
              ),
              _renderListTile(
                title: 'App Version',
                leadingIcon: Icons.fiber_manual_record,
                trailingItem: Text(appVersion, style: NunitoStyle.body2.copyWith(
                  color: ThemeColor.black[56]
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListTile _renderListTile({String title, IconData leadingIcon, Widget trailingItem, Function onTap}){
    return ListTile(
      dense: true,
      leading: Icon(
        leadingIcon,
        color: leadingIcon == Icons.fiber_manual_record ? ThemeColor.primary : ThemeColor.black[80],
      ),
      title: Text(
        title,
        style: NunitoStyle.body2.copyWith(color: ThemeColor.black[100])
      ),
      trailing: trailingItem != null ? trailingItem : null,
      onTap: () => onTap != null ? onTap() : null,
    );
  }

  Widget _logout(){
    return Container(
      color: ThemeColor.white,
      margin: EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: FlatButton(
          child: Text(
            'Logout',
            style: NunitoStyle.title2.copyWith(color: ThemeColor.secondaryDark),
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => _showLogoutConfirmation(),
        ),
      )
    );
  }

  void _launchUrl(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _sendContactEmail() async{

    var _return = '';

    String userEmail = await Pref.getUserEmail() ?? '-';

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var _systemName = iosInfo.systemName;
      var _version = iosInfo.systemVersion;
      var _model = iosInfo.model;

      var _subject = Uri.encodeFull('Contact Us');
      var _text = Uri.encodeFull('---Please type above this line---');
      var _appVersion = Uri.encodeFull('App Version: $appVersion');
      var _userEmail = Uri.encodeFull('User email: $userEmail');
      var _device = Uri.encodeFull('Device: $_model');
      var _os = Uri.encodeFull('OS: $_systemName $_version');

      _return = 'mailto:help@fitfitapp.co?subject=$_subject&body=$_text%0A$_appVersion%0A$_userEmail%0A$_device%0A$_os';
    } else if (Platform.isAndroid) {

      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var _systemName = androidInfo.version.release;
      var _version = androidInfo.version.sdkInt;
      var _name = androidInfo.manufacturer;
      var _model = androidInfo.model;

      
      var _subject = Uri.encodeFull('Contact Us');
      var _text = Uri.encodeFull('---Please type above this line---');
      var _appVersion = Uri.encodeFull('App Version: $appVersion');
      var _userEmail = Uri.encodeFull('User email: $userEmail');
      var _device = Uri.encodeFull('Device: $_name $_model');
      var _os = Uri.encodeFull('OS: $_systemName $_version');

      _return = 'mailto:help@fitfitapp.co?subject=$_subject&body=$_text%3Cbr%3E%0A$_appVersion%3Cbr%3E%0A$_userEmail%3Cbr%3E%0A$_device%3Cbr%3E%0A$_os';
    } else {

      _return = 'mailto:help@fitfitapp.co?subject=Contact%20Us&body=---Please%20type%20above%20this%20line---%0AApp%20Version%3A%20%0AUser%20ID%3A%20%0AUser%20Email%3A%20%0ADevice%3A%20%0AOS%20version%3A%20';
    }
    
    if (await canLaunch(_return)) {
      await launch(_return);
    } else {
      throw 'Could not launch $_return';
    }
  }

  void _showLogoutConfirmation(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout',style: NunitoStyle.h4,),
          content: Text('Are you sure you want to logout?',style: NunitoStyle.body1,),
          actions: <Widget>[
            FlatButton(
              child: Text('No',style: NunitoStyle.body1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes',style: NunitoStyle.body1),
              onPressed: () async{
                Provider.of<AuthProvider>(context, listen: false).clear();
                Provider.of<HomePageProvider>(context, listen: false).clear();
                Nav.clearAllAndPush(WelcomePage.routeName);
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _topBar(),
              _accountSection(),
              _supportSection(),
              _aboutSection(),
              _logout()
            ]
          ),
        )
      )
    );
  }
}
