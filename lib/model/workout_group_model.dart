import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/workout_model.dart';

class WorkoutGroupModel {
  String id;
  String name;
  String imageUrl;
  List<WorkoutModel> workouts;

  WorkoutGroupModel({
    this.id,
    this.name,
    this.imageUrl,
  });

  WorkoutGroupModel.fromJson(dynamic results):
    id = results['_id'],
    name = results['name'],
    imageUrl = results['image_url'],
    workouts = results['workouts'].map<WorkoutModel>( (workout) {
     return WorkoutModel.fromJson(workout);
    }).toList();
  
  get totalWorkouts => workouts.length;
  
  ExerciseSliderModel toExerciseSlider() => ExerciseSliderModel(
    thumbnail: imageUrl,
    title: name,
    desc: '${workouts.length} workouts',
  );
}