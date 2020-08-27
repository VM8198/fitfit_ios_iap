import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/utility/util.dart';

class SubscriptionPerks extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Image.asset(Utility.emojiPath + 'perks-1.png', width: 20,height: 20),
                ),
                Text(
                  'Weekly personal training that is unique to you',
                  style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Image.asset(Utility.emojiPath + 'perks-2.png', width: 20,height: 20),
                ),
                Text(
                  'Consist of resistance training & cardio training',
                  style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Image.asset(Utility.emojiPath + 'perks-3.png', width: 20,height: 20),
                ),
                Text(
                  'Automatic progression & adaptation',
                  style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Image.asset(Utility.emojiPath + 'perks-4.png', width: 20,height: 20),
                ),
                Text(
                  'Training performance tracking',
                  style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}