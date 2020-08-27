import 'package:flutter_fitfit/model/exercise_model.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';

class CircuitModel {
  String name;
  CircuitType type;
  dynamic noSet;
  int duration;
  List<ExerciseModel> exercises;
  int restDuration;
  List equipments;

  CircuitModel({
    this.name,
    this.type,
    this.noSet,
    this.duration,
    this.exercises,
    this.restDuration,
    this.equipments
  });

  factory CircuitModel.fromJson(dynamic results) {
    CircuitType type = results['type'] == 'rest' ? CircuitType.rest : CircuitType.exercise;
    return CircuitModel(
      name: results['name'],
      type: type,
      noSet: type == CircuitType.exercise ? results['no_set'] : 0,
      duration: results['duration'],
      restDuration: results['max_reps'] != null ? results['max_reps'] : null,
      exercises: (results['exercises'] as List).map<ExerciseModel>( (exercise) => ExerciseModel.fromJson(exercise)).toList(),
      equipments: results['equipments'] != null ? results['equipments'] : []
    );
  }

  // ExerciseType.warmUp is for Cardio WU exercise
  List<ExerciseModel> get exercisesOnly => exercises.where( (ex) => ex.type == ExerciseType.exercise || ex.type == ExerciseType.warmUp).toList();

  get totalExercises => exercisesOnly.length;

}