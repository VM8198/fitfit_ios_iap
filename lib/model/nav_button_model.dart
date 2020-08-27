import 'package:flutter/material.dart';

class NavButtonModel {
  IconData icon;
  Widget content;
  bool isActive = false;

  NavButtonModel({
    @required this.content,
    @required this.icon,
    this.isActive
  });

}