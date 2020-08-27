import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class WeekWorkout {
  final String week;
  final int count;
  final charts.Color color;

  WeekWorkout(
      {@required this.week,
      @required this.count,
      @required this.color});
}