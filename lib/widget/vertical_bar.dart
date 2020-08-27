import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_fitfit/model/week_workout.dart';


class VerticalBar extends StatelessWidget {

  final List<WeekWorkout> data;


  VerticalBar({@required this.data});

  @override
  Widget build(BuildContext context) {

    List<charts.Series<WeekWorkout, String>> workout = [
      charts.Series(
          id: "Week Workout",
          data: data,
          domainFn: (WeekWorkout workout, _) => workout.week,
          measureFn: (WeekWorkout workout, _) => workout.count,
          colorFn: (WeekWorkout workout, _) => workout.color)
    ];

    return Container(
      height: 320,
      padding: EdgeInsets.all(15),
      // child: Card(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.BarChart(
                  workout, 
                  animate: true,
                  defaultRenderer: new charts.BarRendererConfig(
                    // cornerStrategy: const charts.ConstCornerStrategy(30)
                  ),
                  domainAxis: new charts.OrdinalAxisSpec(
                    // renderSpec: new charts.NoneRenderSpec()
                  ),
                ),
              )
            ]
          )
        )
      // )
    );
  }

}