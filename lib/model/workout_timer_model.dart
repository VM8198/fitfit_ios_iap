import 'package:flutter_fitfit/model/list_of_enum.dart';

class WorkoutTimerModel {
  ExerciseType exerciseType;
  String exerciseTitle;
  String exerciseName;
  bool showDuration;
  bool showReps;
  Duration exerciseDuration;
  int exerciseReps;
  String durationString;
  String oriDurationString;
  bool perSideExercise;
  String mediaUrl;
  int circuitIndex;
  
  WorkoutTimerModel({
    this.exerciseType,
    this.exerciseTitle,
    this.exerciseName,
    this.showDuration,
    this.showReps,
    this.exerciseDuration,
    this.exerciseReps,
    this.durationString,
    this.oriDurationString,
    this.perSideExercise,
    this.mediaUrl,
    this.circuitIndex
  }) : assert((showDuration == true ? exerciseDuration != null : true) || (showReps == true ? exerciseReps != null : true));
}