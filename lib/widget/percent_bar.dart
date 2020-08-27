import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

enum PercentBarBackgroundColor{
  transparent,
  filled
}

class PercentBar extends StatelessWidget{
  final double width;
  final double percent;
  final PercentBarBackgroundColor bgColor;

  PercentBar({
    this.width, 
    this.percent, 
    this.bgColor = PercentBarBackgroundColor.filled
  });
  
  @override
  Widget build(BuildContext context) {
    Color _bgColor = bgColor == PercentBarBackgroundColor.filled ? ThemeColor.black[08] : Colors.transparent;

    return LinearPercentIndicator(
      padding: EdgeInsets.zero,
      width: width,
      lineHeight: 10.0,
      percent: percent,
      backgroundColor: _bgColor,
      progressColor: ThemeColor.secondaryDark,
      linearStrokeCap: LinearStrokeCap.butt,
    );
  }

}