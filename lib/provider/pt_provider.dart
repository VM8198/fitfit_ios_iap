import 'package:flutter/material.dart';
import 'package:flutter_fitfit/api/pt_repo.dart';
import 'package:flutter_fitfit/model/pt_model.dart';
import 'package:flutter_fitfit/model/workout_model.dart';

class PtProvider with ChangeNotifier {
  PtRepository _ptRepository;
  List<PtModel> _ptWorkoutGroups = [];
  String _levelName;
  bool _isAllWorkoutsCompleted = false;
  WorkoutModel _ptWorkoutModels;

  PtProvider(){
    _ptRepository = PtRepository();
  }

  bool _isPTQueCompleted = false;

  bool get isPTQueCompleted => _isPTQueCompleted;

  void updateIsPTQueCompleted(bool isCompleted){
    if(isCompleted != _isPTQueCompleted){
      _isPTQueCompleted = isCompleted ?? true;
      notifyListeners();
    }
  }

  String get levelName => _levelName;

  List<PtModel> get ptWorkoutGroups => _ptWorkoutGroups;

  bool get isAllWorkoutsCompleted => _isAllWorkoutsCompleted;

  getList() async{
    dynamic results = await _ptRepository.getPtWorkout();
    _ptWorkoutGroups = results['plans'].map<PtModel>( (pt) => PtModel.fromJson(pt)).toList();
    _levelName = '${results['level_name']} ${(results['level']).toDouble()}';
    _isAllWorkoutsCompleted = results['all_completed'];
    notifyListeners();

    return this;
  }

  getWorkoutDetail(String id) async{
    dynamic results = await _ptRepository.getPtWorkoutDetail(id);
    _ptWorkoutModels = WorkoutModel.fromPtJson(results);
    return _ptWorkoutModels;
  }

  postCompleteWorkout(String id) async{
    await _ptRepository.postCompleteWorkout(id);
  }
}