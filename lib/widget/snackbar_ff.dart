import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

enum SnackBarFFType {
  normal,
  success,
  error,
  warning
}

class SnackBarFF extends SnackBar {

  final String title;
  final String actionLabel;
  final Function actionOnPressed;
  final SnackBarFFType type;

  SnackBarFF({
    @required this.title,
    this.actionLabel = 'Dismiss',
    this.actionOnPressed,
    this.type = SnackBarFFType.normal,
  }): super(
    content: Text(title),
    action: SnackBarAction(
      label: actionLabel,
      onPressed: actionOnPressed != null ? actionOnPressed : () => {},
    )
  );

}


class FlushbarFF{
  static showFlushBar(String errorMsg, {SnackBarFFType type}){
    return Flushbar(
      messageText: Row(
        children: <Widget>[
          type == SnackBarFFType.error ? Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.warning,
              color: ThemeColor.favoriteRed,
            ),
          ) : SizedBox(),
          Text(
            errorMsg ?? 'Something went wrong. Please try again.',
            style: NunitoStyle.body2,
          )
        ],
      ),
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.grey[300],
          blurRadius: 5.0,
          spreadRadius: 0,
          offset: Offset(3.0,4.0)
        )
      ],
      borderRadius: 12.0,
      margin: EdgeInsets.all(16.0),
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 500),
    );
  }
}