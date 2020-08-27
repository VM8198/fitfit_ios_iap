import 'package:flutter_fitfit/model/circuit_model.dart';
import 'package:flutter_fitfit/model/exercise_model.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';


class WorkoutModel {
  String id;
  String name;
  String imageUrl;
  WorkoutType workoutType;
  WorkoutLevelType level;
  int duration;
  List<String> focusAreas;
  List<CircuitModel> circuits;
  List<String> equipments;
  List<ExerciseModel> warmup;
  List<ExerciseModel> cooldown;
  int cooldownDuration;
  List cooldownEquipments;
  int warmupDuration;
  List warmupEquipments;
  PtWorkoutType ptWorkoutType;

  WorkoutModel({
    this.id,
    this.name,
    this.imageUrl,
    this.workoutType,
    this.level,
    this.duration,
    this.focusAreas,
    this.circuits,
    this.equipments,
    this.warmup,
    this.cooldown,
    this.cooldownDuration,
    this.cooldownEquipments,
    this.warmupDuration,
    this.warmupEquipments,
    this.ptWorkoutType
  });

  factory WorkoutModel.fromJson(dynamic results) {
    return WorkoutModel(
      id: results['_id'],
      name: results['name'],
      imageUrl: results['image_url'],
      workoutType: WorkoutType.curated,
      level: WorkoutLevelType.values[results['level']],
      duration: results['duration'],
      equipments: (results['equipments'] as List).map<String>( (eq) => eq).toList(),
      focusAreas: (results['focus_areas'] as List).map<String>( (focusArea) => focusArea['name']).toList(),
      circuits: (results['circuits'] as List).map<CircuitModel>( (circuit) => CircuitModel.fromJson(circuit)).toList(),
      warmup: (results['warmup']['exercises'] as List).map<ExerciseModel>( (circuit) => ExerciseModel.fromJson(circuit)).toList(),
      warmupDuration: results['warmup']['duration'],
      warmupEquipments: results['warmup']['equipments'] != null ? results['warmup']['equipments'] : [],
      cooldown: (results['cooldown']['exercises'] as List).map<ExerciseModel>( (circuit) => ExerciseModel.fromJson(circuit)).toList(),
      cooldownDuration: results['cooldown']['duration'],
      cooldownEquipments: results['cooldown']['equipments'] != null ? results['cooldown']['equipments'] : []
    );
  }

  factory WorkoutModel.fromPtJson(dynamic results) {
    return WorkoutModel(
      id: results['_id'],
      name: results['name'] ?? '',
      imageUrl: results['image_url'],
      workoutType: WorkoutType.personalTraining,
      level: null,
      duration: results['duration'] ?? 0, // return as min
      equipments: (results['equipments'] as List).map<String>( (eq) => eq).toList(),
      focusAreas: (results['focus_areas'] as List).map<String>( (focusArea) => focusArea['name']).toList(),
      circuits: (results['circuits'] as List).map<CircuitModel>( (circuit) => CircuitModel.fromJson(circuit)).toList(),
      warmup: (results['warmup']['exercises'] as List).map<ExerciseModel>( (circuit) => ExerciseModel.fromJson(circuit)).toList(),
      warmupDuration: results['warmup']['duration'],
      warmupEquipments: results['warmup']['equipments'] != null ? results['warmup']['equipments'] : [],
      cooldown: (results['cooldown']['exercises'] as List).map<ExerciseModel>( (circuit) => ExerciseModel.fromJson(circuit)).toList(),
      cooldownDuration: results['cooldown']['duration'],
      cooldownEquipments: results['cooldown']['equipments'] != null ? results['cooldown']['equipments'] : [],
      ptWorkoutType: results['name'].contains('Resistance') ? PtWorkoutType.resistance : PtWorkoutType.cardio
    );
  }
    
  get levelString {
    switch (level) {
      case WorkoutLevelType.all:
        return 'All';
      case WorkoutLevelType.beginner:
        return 'Beginner';
      case WorkoutLevelType.apprentice:
        return 'Apprentice';
      case WorkoutLevelType.intermediate:
        return 'Intermediate';
      case WorkoutLevelType.advanced:
        return 'Advanced';
      case WorkoutLevelType.guru:
        return 'Guru';
    }
  }

  List<CircuitModel> get exerciseCircuits => circuits.where( (circuit) => circuit.type == CircuitType.exercise).toList();

  ExerciseSliderModel toExerciseSlider() => ExerciseSliderModel(
    id: id,
    thumbnail: 'https://picsum.photos/id/323/400/300',
    title: name,
    desc: '$duration min • $levelString',
    ref: this,
  );
}