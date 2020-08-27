import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/provider/timer_provider.dart';
import 'package:provider/provider.dart';

class OverallTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var selector2 = Selector<TimerProvider, String>(
      selector: (context, provider) => provider.overallTimeInString,
      builder: (context, timeLeftInString, child) => Container(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Text(
          timeLeftInString,
          style: NunitoStyle.h4.copyWith(color: Colors.white, fontSize: 30),
        ),
        alignment: Alignment.topRight,
      ),
    );
    return selector2;
  }
}
