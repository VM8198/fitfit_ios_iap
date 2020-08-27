import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/utility/util.dart';

class PtModel {
  String categoryName;
  PtWorkoutType workoutType;
  List<ExerciseSliderModel> workoutGroups;
  int completedWorkouts;
  int totalWorkouts;

  PtModel({
    this.categoryName,
    this.workoutType,
    this.workoutGroups,
    this.completedWorkouts,
    this.totalWorkouts,
  });

  factory PtModel.fromJson(dynamic data) {
    List<ExerciseSliderModel> workoutGroups = data['workouts']
                      .map<ExerciseSliderModel>( (group) {              
                        return ExerciseSliderModel(
                          id: group['plan_id'],
                          thumbnail: group['image_url'],
                          title: group['name'],
                          desc: '${Utility.prettifyDurationTime(group['duration'])}',
                          isCompleted: group['completed'],
                          checkedColor: data['name'] == 'Resistance' ? ThemeColor.secondaryDark : ThemeColor.primaryDark
                        );
                      }).toList();

    return PtModel(
      categoryName: data['name'],
      workoutType: data['name'] == 'Resistance' ? PtWorkoutType.resistance : PtWorkoutType.cardio,
      workoutGroups: workoutGroups,
      completedWorkouts: data['total_completed'],
      totalWorkouts: data['total_workouts'],
    );
  }
}