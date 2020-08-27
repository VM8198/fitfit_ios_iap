import 'package:flutter/material.dart';

class ThemeColor {

  ThemeColor._();
  
  static Color primaryLight = Color(0xFFB5ABFA);
  static Color primary = Color(0xFF6D59F3);
  static Color primaryDark = Color(0xFF503CDC);
  
  static Color secondary = Color(0xfff39e59);
  static Color secondaryDark = Color(0xfff08229);

  static  MaterialColor black =  MaterialColor(0x22212121, <int, Color>{
    100 : Color.fromRGBO(33, 33, 3, 1),
    80 : Color.fromRGBO(33, 33, 3, 0.8),
    56 : Color.fromRGBO(33, 33, 3, 0.56),
    24 : Color.fromRGBO(33, 33, 3, 0.24),
    08 : Color.fromRGBO(33, 33, 3, 0.08)
  });

  static Color background = Color(0xfffafaff);
  static Color white = Color(0xFFFFFFFF);
  static Color btnBlack = Color(0x00000000);
  static Color favoriteRed = Color(0xFFFF5B53);
  static Color btnDisable = Color(0xFF816ddf);

  static List<Color> fusion01 = [primary, primaryDark];
  static List<Color> facebookFusion = [Color(0xFF2050B3), Color(0xFF2F55A4)];
  static List<Color> appleFusion = [Color(0x00000000), Color(0x00000000)];
  static List<Color> ctaFusion = [Color(0x00000000), Color(0x00000000)];
  static List<Color> disabled = [Color(0x666D59F3), Color(0x22503CDC)];
}