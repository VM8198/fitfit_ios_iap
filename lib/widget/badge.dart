import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

class Badge extends StatelessWidget{
  final String text;
  final String theme;

  Badge(this.text,{this.theme});

  static Map _outlineTheme = {
    'backgroundColor': Colors.white,
    'textColor': ThemeColor.black[80],
    'borderColor': ThemeColor.black[24],
  };

  static Map _orangeTheme = {
    'backgroundColor': ThemeColor.secondaryDark,
    'textColor': Colors.white,
    'borderColor':ThemeColor.secondaryDark,
  };

  @override
  Widget build(BuildContext context) {
    Map _choosenTheme = theme == 'outline' ? _outlineTheme : _orangeTheme;

    return Container(
      child: Text('$text',style: NunitoStyle.body2.copyWith(
          color: _choosenTheme['textColor'],
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: _choosenTheme['borderColor']),
        borderRadius: BorderRadius.circular(5.0),
        color: _choosenTheme['backgroundColor']
      ),
    );
  }
}