import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

class CtaButton extends StatelessWidget {
  
  final Widget leading;
  final String text;
  final Function(BuildContext) onPressed;
  final bool disabled;

  CtaButton(this.text,{this.leading,this.onPressed,this.disabled:false});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      // color: ThemeColor.primary,
      elevation: 0.0,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0)
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 100),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: !disabled ? ThemeColor.fusion01 : ThemeColor.disabled,
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: leading != null ? true : false,
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: leading,
                ),
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: NunitoStyle.button2.copyWith(
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () => !disabled ? onPressed(context) : null,
    );
  }
}