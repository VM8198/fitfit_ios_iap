import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/homepage_provider.dart';
import 'package:flutter_fitfit/widget/navigation_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: logoAppBar,
      bottomNavigationBar: Container(
        color: ThemeColor.white,
        child: SafeArea(
          child: NavigationBar()
        ),
      ),
      body: Consumer<HomePageProvider>(
        builder: (context, hp, child){
          return hp.currentPage;
        },
      ),
    );
  }
}