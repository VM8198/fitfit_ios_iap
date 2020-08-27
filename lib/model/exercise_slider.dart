import 'dart:ui';

import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_model.dart';

class ExerciseSliderModel<T> {
  String id;
  String thumbnail;
  String title;
  String desc;
  int order;
  T ref;
  bool isCompleted = false;
  Color checkedColor = ThemeColor.primary;
  
  ExerciseSliderModel({
    this.id,
    this.thumbnail,
    this.title,
    this.desc,
    this.ref,
    this.order,
    this.isCompleted = false,
    this.checkedColor
  });

  factory ExerciseSliderModel.fromApiJson(Map<String, dynamic> json){
    return ExerciseSliderModel(
      thumbnail: json["thumbnail"],
      title: json["title"],
      desc: json["desc"]
    );
  }
  
  static List<ExerciseSliderModel> dummyExerciseSliderList1 = [
    ExerciseSliderModel(
      thumbnail: 'https://dev.studio.fit2.app/storage/exercises/1583588062.gif',
      title: 'Back-tas-tic!',
      desc: '10 workouts',
      isCompleted: true,
      checkedColor: ThemeColor.secondary
    ),
    ExerciseSliderModel(
      thumbnail: 'https://picsum.photos/id/313/400/300',
      title: 'Back-tas-tic!',
      desc: '10 workouts',
    ),
    ExerciseSliderModel(
      thumbnail: 'https://picsum.photos/id/305/400/300',
      title: 'Back-tas-tic!',
      desc: '10 workouts',
    ),
  ];

  static List<ExerciseSliderModel> dummyExerciseSliderList2 = [
    ExerciseSliderModel(
      thumbnail: 'https://picsum.photos/id/223/400/300',
      title: 'Medi-daily',
      desc: '8 workouts',
      ref: WorkoutModel(
        name: 'Low Intensity Cardio',
        workoutType: WorkoutType.personalTraining,
        duration: 300
      )
    ),
    ExerciseSliderModel(
      thumbnail: 'https://picsum.photos/id/213/400/300',
      title: 'The 10 Squats!',
      desc: '10 workouts',
      isCompleted: true,
      checkedColor: ThemeColor.primary
    ),
    ExerciseSliderModel(
      thumbnail: 'https://picsum.photos/id/299/400/300',
      title: 'Back-tas-tic!',
      desc: '10 workouts',
    ),
  ];
}