import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_timer_model.dart';
import 'package:flutter_fitfit/utility/util.dart';

enum DurationType {
  reps,
  duration,  
}

class ExerciseModel {
  String name;
  dynamic duration;
  DurationType durationType;
  ExerciseType type;
  String coverImgUrl;
  String videoUrl;
  String instructionUrl;
  List<String> primaryFocusAreas;
  List<String> secondaryFocusAreas;
  List<dynamic> equipments;
  bool perSideExercise;
  Map instruction;

  ExerciseModel({
    this.name,
    this.duration,
    this.durationType,
    this.coverImgUrl,
    this.videoUrl,
    this.instructionUrl,
    this.type,
    this.primaryFocusAreas,
    this.secondaryFocusAreas,
    this.equipments,
    this.perSideExercise,
    this.instruction
  });

  factory ExerciseModel.fromJson(dynamic results) {
    bool _perSide = results['per_side_ex'] != null && results['per_side_ex'] == true;

    return ExerciseModel(
      name: results['display_name'] != null ? results['display_name'] : results['name'],
      // max_reps here if duration type = reps then will be x reps
      // if duration type = duration then will be x seconds
      duration: results['max_reps'] != null ? (_perSide ? results['max_reps'] * 2 : results['max_reps']) : 0,
      durationType: results['max_reps_type'] == 'reps' ? DurationType.reps : DurationType.duration,
      coverImgUrl: results['image_url'],
      videoUrl: results['video_url'],
      type: results['type'] == 'rest' ? ExerciseType.rest : ExerciseType.exercise,
      primaryFocusAreas: results['primary_focus_areas'] != null ? (results['primary_focus_areas'] as List).map<String>( (focusArea) => focusArea['name']).toList() : [],
      secondaryFocusAreas: results['primary_focus_areas'] != null ? (results['secondary_focus_areas'] as List).map<String>( (focusArea) => focusArea['name']).toList() : [],
      equipments: results['all_equipments'] != null ? results['all_equipments'] : [],
      perSideExercise: results['per_side_ex'] != null ? results['per_side_ex'] : false,
      instruction: results['instruction']
    );
  }

  String convertDurationIntoString(int duration, DurationType durationType) {
    if(durationType == DurationType.duration){
      return '${Utility.prettifyDurationTime(duration)}'; 
    }
    else if(durationType == DurationType.reps){
      return '$duration Reps'; 
    }
    return '';
  }

  get focusAreas {
    return List<String>.from(primaryFocusAreas)..addAll(secondaryFocusAreas);
  }

  ExerciseSliderModel toExerciseSlider() => ExerciseSliderModel(
    thumbnail: coverImgUrl,
    title: name,
    desc: convertDurationIntoString(duration,durationType),
  );

  WorkoutTimerModel toWorkoutTimerModel({
    String exerciseCircuitSetTitle,
    int circuitIndex
  }) => WorkoutTimerModel(
    exerciseType: type,
    exerciseTitle: exerciseCircuitSetTitle ?? '',
    exerciseName: name,
    showDuration: durationType == DurationType.duration ? true : false,
    showReps: durationType == DurationType.reps ? true : false,
    exerciseDuration: durationType == DurationType.duration ? Duration(seconds: duration) : Duration(),
    exerciseReps: durationType == DurationType.reps ? duration : 0,
    durationString: durationType == DurationType.reps ? (perSideExercise ? '${(duration/2).toInt()} reps' : '$duration reps') : (perSideExercise ? '${(duration/2).toInt()} s' : '$duration s'),
    oriDurationString: durationType == DurationType.reps ? '$duration reps' : '$duration s',
    perSideExercise: perSideExercise,
    mediaUrl: videoUrl,
    circuitIndex: circuitIndex
  );
}