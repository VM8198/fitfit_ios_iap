import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_fitfit/model/week_weight.dart';


class ScatterPlot extends StatelessWidget {

  final List<WeekWeight> data;


  ScatterPlot({@required this.data});

  @override
  Widget build(BuildContext context) {

    List<charts.Series<WeekWeight, DateTime>> weight = [
      charts.Series(
          id: "Weight",
          data: data,
          domainFn: (WeekWeight weight, _) => weight.day,
          measureFn: (WeekWeight weight, _) => weight.count,
          radiusPxFn: (WeekWeight weight, _) => 6,
          colorFn: (WeekWeight weight, _) => charts.ColorUtil.fromDartColor(Colors.deepPurple)
      )
    ];

    return Container(
      height: 320,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.ScatterPlotChart(
                  weight, 
                  animate: true,
                ),
              )
            ]
          )
        )
      )
    );
  }

}