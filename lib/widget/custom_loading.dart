import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.0,
      height: 30.0,
      child: LoadingIndicator(
        indicatorType: Indicator.lineScale, 
        color: ThemeColor.primaryLight,
      ),
    );
  }

}