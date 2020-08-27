import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

class MySubscriptionPage extends StatelessWidget {
  static const routeName = '/my-subscription';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Your Plan'),
                  Text('PUT SOMETHING HERE')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Since'),
                  Text('PUT SOMETHING HERE')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Renews on'),
                  Text('PUT SOMETHING HERE')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}