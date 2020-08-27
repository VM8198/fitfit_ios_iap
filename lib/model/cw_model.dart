import 'package:flutter_fitfit/model/exercise_slider.dart';

class CwModel {
  String categoryName;
  List<ExerciseSliderModel> workoutGroups;

  CwModel({
    this.categoryName,
    this.workoutGroups
  });

  factory CwModel.fromJson(dynamic data) {
    List<ExerciseSliderModel> workoutGroups = data['workout_groups']
                      .map<ExerciseSliderModel>( (group) {
                        return ExerciseSliderModel(
                          id: group['_id'],
                          thumbnail: group['image_url'],
                          title: group['name'],
                          desc: '${group['workout_ids'].length} workouts',
                          order: group['order_id'] ?? 1
                        );
                      }).toList();
    workoutGroups.sort( (a, b) => a.order.compareTo(b.order) );

    return CwModel(
      categoryName: data['name'],
      workoutGroups: workoutGroups,
    );
  }
}