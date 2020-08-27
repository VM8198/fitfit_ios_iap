import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_fitfit/model/week_weight.dart';


class LinePlot extends StatelessWidget {

  final List<WeekWeight> data;

  LinePlot({@required this.data});

  @override
  Widget build(BuildContext context) {

    List<charts.Series<WeekWeight, DateTime>> weight = [
      charts.Series(
          id: "Weight",
          data: data,
          domainFn: (WeekWeight weight, _) => weight.day,
          measureFn: (WeekWeight weight, _) => weight.count,
          colorFn: (WeekWeight weight, _) => charts.ColorUtil.fromDartColor(Colors.deepPurple),
          radiusPxFn: (WeekWeight weight, _) => 6,
      )
      ..setAttribute(charts.rendererIdKey, 'customPoint'),
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
                child: charts.TimeSeriesChart(
                  weight, 
                  animate: false,
                  defaultRenderer: new charts.LineRendererConfig(),
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  customSeriesRenderers: [
                    new charts.PointRendererConfig(
                        customRendererId: 'customPoint')
                  ],
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                    tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                      zeroBound: false,
                      dataIsInWholeNumbers: false,
                      desiredMinTickCount: 5,
                      desiredMaxTickCount: 10
                    ),
                  ),
                  domainAxis: new charts.DateTimeAxisSpec(
                    tickProviderSpec: new charts.DayTickProviderSpec(
                      increments: [1]
                    ),
                    tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                      day: new charts.TimeFormatterSpec(
                        format: 'dd/M',
                        transitionFormat: 'dd/M',
                      ),
                    ),
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

