import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/homepage_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:provider/provider.dart';

class PtFinishWeeklyWorkoutCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: Offset(4.0,10.0)
          )
        ]
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Text(
                  'Weekly Training Will Start on Monday',
                  textAlign: TextAlign.center,
                  style: NunitoStyle.title2,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0,),
                  child: Text(
                    'Come back on Monday for your new weekly training, or take on a Curated Workout if you’d like to go the extra mile.',
                    textAlign: TextAlign.center,
                    style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                  ),
                ),
                CtaButton(
                  'Start Curated Workout',
                  onPressed: (_){
                    Provider.of<HomePageProvider>(context, listen: false).changeNav(0);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}