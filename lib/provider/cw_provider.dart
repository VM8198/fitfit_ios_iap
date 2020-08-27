import 'package:flutter/material.dart';
import 'package:flutter_fitfit/api/cw_repo.dart';
import 'package:flutter_fitfit/api/workout_group_repo.dart';
import 'package:flutter_fitfit/model/cw_model.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/workout_group_model.dart';

class CwProvider with ChangeNotifier {
  CwRepository _cwRepo;
  WorkoutGroupRepository _wgRepo;

  List<CwModel> _cwModels;
  WorkoutGroupModel workoutGroupModel;

  bool _isLoading = false;

  CwProvider() {
    _cwRepo = CwRepository();
    _wgRepo = WorkoutGroupRepository();
  }


  getSectionName(index) => (index < _cwModels.length) ? _cwModels[index].categoryName : null;

  List<ExerciseSliderModel> getSectionList(index) => (index < _cwModels.length) ? _cwModels[index].workoutGroups : [];

  toggleLoading() => _isLoading = !_isLoading;

  getList() async {
    if (_isLoading) return;
    toggleLoading();

    dynamic results = await _cwRepo.getCuratedWorkout();
    
    _cwModels = results.map<CwModel>( (cw) => CwModel.fromJson(cw)).toList();

    toggleLoading();
  }

  getDetails(workoutGroupId) async{
    if (_isLoading) return;
    toggleLoading();
    dynamic results = await _wgRepo.getDetails(workoutGroupId);

    workoutGroupModel = WorkoutGroupModel.fromJson(results);
    toggleLoading();
  }
}