import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_fitfit/screen/scroll_page_custom_template.dart';
import 'package:flutter_fitfit/screen/my_progress_blocker_dialog.dart';
import 'package:flutter_fitfit/screen/weight_update.dart';
import 'package:flutter_fitfit/screen/weight_all.dart';
import 'package:flutter_fitfit/widget/vertical_bar.dart';
import 'package:flutter_fitfit/widget/line_plot.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/badge.dart';
import 'package:flutter_fitfit/model/week_workout.dart';
import 'package:flutter_fitfit/model/week_weight.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/utility/nav.dart';

class MyProgressPage extends StatelessWidget{
  static const routeName = '/my-progress';
  
  //build sample data
  final List<WeekWorkout> barData = [
    WeekWorkout(
      week: "1/2",
      count: 4,
      color: charts.ColorUtil.fromDartColor(Colors.deepPurple)
    ),
    WeekWorkout(
      week: "8/2",
      count: 24,
      color: charts.ColorUtil.fromDartColor(Colors.deepPurple)
    ),
    WeekWorkout(
      week: "15/2",
      count: 14,
      color: charts.ColorUtil.fromDartColor(Colors.orange)
    ),
    WeekWorkout(
      week: "22/2",
      count: 0,
      color: charts.ColorUtil.fromDartColor(Colors.purple)
    ),
    WeekWorkout(
      week: "29/2",
      count: 0,
      color: charts.ColorUtil.fromDartColor(Colors.purple)
    ),
  ];


  //build sample data
  final List<WeekWeight> plotData = [
    WeekWeight(
      day: new DateTime(2020, 2, 29),
      count: 55
    ),
    WeekWeight(
      day: new DateTime(2020, 3, 1),
      count: 55.5
    ),
    WeekWeight(
      day: new DateTime(2020, 3, 2),
      count: 55.9
    ),
    WeekWeight(
      day: new DateTime(2020, 3, 3),
      count: 55.3
    ),
    WeekWeight(
      day: new DateTime(2020, 3, 4),
      count: 55.0
    ),
    WeekWeight(
      day: new DateTime(2020, 3, 5),
      count: 54.8
    ),
    WeekWeight(
      day: new DateTime(2020, 3, 6),
      count: 54.9
    )
  ];

  @override
  Widget build(BuildContext context) {
    return ScrollPageCustomTemplate(
      header: _header(context),
      content: _content(),
    );
  }

  Widget _header(context){
    return Positioned(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0,30.0,0.0,10.0),
                  child: new Text("Your current level is...", style: NunitoStyle.h3),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,10.0),
                  child: Image.asset(Utility.levelPath + 'female_guru.png', width: 126,height: 104),
                ),
                Badge('GURU',theme: 'orange'),
                FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Change level',
                    style: NunitoStyle.body2.copyWith(
                      color: ThemeColor.black[80],
                      decoration: TextDecoration.underline
                    ),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    child: MyProgressBlockerDialog()
                  ),
                )
              ]
          ),
        ]
      )
    );
  }

  Widget _content(){


    final thisWeek = new Container(
      child: new Column(
        children: <Widget>[
          new Text("4", style: NunitoStyle.h3),
          new Text("THIS WEEK", style: NunitoStyle.caption1),
        ],
      )
    );

    final allTime = new Container(
      child: new Column(
        children: <Widget>[
          new Text("30", style: NunitoStyle.h3),
          new Text("ALL TIME", style: NunitoStyle.caption1),
        ],
      )
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 2.0,
              children: <Widget>[
                Text(
                  'Workouts',
                  style: NunitoStyle.h3,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,10.0),
            child: VerticalBar(
              data: barData
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                thisWeek,
                SizedBox(width: 30),
                allTime
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Weight Tracking',
                  style: NunitoStyle.h3,
                ),
                FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Show All Data',
                    style: NunitoStyle.body2.copyWith(
                      color: Colors.orange
                    ),
                  ),
                  onPressed: () => Nav.navigateTo(WeightAllPage.routeName),
                ),
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,12.0),
            child: LinePlot(
              data: plotData,
            )
          ), 
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CtaButton(
                    'Update Weight', 
                    onPressed: (_) => Nav.navigateTo(WeightUpdatePage.routeName)
                  )
                ]
            )
          )
        ]
      )
    );

  }

  


}