import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';

class WorkoutBlockerDialog extends StatelessWidget{

  final String content;

  WorkoutBlockerDialog({@required this.content});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Dialog(
      child: Container(
        width: size.width * 0.8,
        padding: EdgeInsets.all(20.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              'Hold on there!',
              style: NunitoStyle.title.copyWith(color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
              ),
            ),
            CtaButton(
              'Take a Break',
              onPressed: (context) {},
            ),
            FlatButton(
              child: Text(
                'I understand and wish to continue',
                style: NunitoStyle.body1.copyWith(
                  color: ThemeColor.black[80],
                  decoration: TextDecoration.underline
                ),
              ),
              onPressed: () => {},
            )
          ],
        ),
      ),
    );
  }
  
}