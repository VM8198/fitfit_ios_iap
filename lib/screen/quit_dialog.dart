import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';

class QuitDialog extends StatelessWidget{
  final String content;
  final Function onProceed;
  final Function onCancel;

  QuitDialog({@required this.content, this.onProceed, this.onCancel});

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
          runSpacing: 32.0,
          children: <Widget>[
            Text(
              '$content',
              textAlign: TextAlign.center,
              style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: (){
                    onCancel != null ? onCancel() : Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: NunitoStyle.button2.copyWith(color: ThemeColor.black[56]),
                  ),
                ),
                CtaButton(
                  'Yes',
                  onPressed: (context) {
                    onProceed();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  
}