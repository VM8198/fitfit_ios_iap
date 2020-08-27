import 'package:flutter/material.dart';

class Nav {
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object args}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: args);
  }

  static clearAllAndPush(String routeName, {Object args}) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
      routeName, 
      (Route<dynamic> route) => false,
      arguments: args,
    );
  }
}