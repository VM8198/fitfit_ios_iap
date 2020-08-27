import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class UpNextBar extends StatelessWidget{
  final String exerciseName;
  final String frequency;

  UpNextBar({
    this.exerciseName,
    this.frequency
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0),),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: Offset(0,-4.0)
          )
        ],
        color: ThemeColor.white
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Up Next: ', style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),),
          _transformText(exerciseName),
          Text(frequency != null ? ' • $frequency' : '', style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),),
        ],
      ),
    );
  }

  Widget _transformText(text){
    return Flexible(
      child: TextOneLine(
        text != null ? text : '', 
        style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),
        overflow: TextOverflow.ellipsis
      )
    );
  }
}