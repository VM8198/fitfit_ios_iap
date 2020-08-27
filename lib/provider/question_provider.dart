import 'package:flutter/material.dart';
import 'package:flutter_fitfit/api/question_repo.dart';
import 'package:flutter_fitfit/model/question_model.dart';
import 'package:flutter_fitfit/screen/question/question_1.dart';
import 'package:flutter_fitfit/screen/question/question_2.dart';
import 'package:flutter_fitfit/screen/question/question_3.dart';
import 'package:flutter_fitfit/screen/question/question_4.dart';
import 'package:flutter_fitfit/screen/question/question_5.dart';
import 'package:flutter_fitfit/screen/question/question_6.dart';

class QuestionProvider extends ChangeNotifier{

  int _currentQueIndex = 0;
  QueRepository _queRepo;
  QuestionModel _queModel = QuestionModel();

  QuestionProvider() {
    _queRepo = new QueRepository();
    _init();
  }

  get totalQuestion => 6;
  get currentQue => _currentQueIndex + 1;
  get currentQuePage {
    switch (currentQue) {
      case 1:
        return Question1Page();
        break;
      case 2:
        return Question2Page();
        break;
      case 3:
        return Question3Page();
        break;
      case 4:
        return Question4Page();
        break;
      case 5:
        return Question5Page();
        break;
      case 6:
        return Question6Page();
        break;
      default:
        return Question1Page();
    }
  }

  get gender => _queModel.gender;

  set gender(String gender){
    _queModel.gender = gender;
    notifyListeners();
  }

  get goal => _queModel.goal;

  set goal(String goal){
    _queModel.goal = goal;
    notifyListeners();
  }

  get problemAreas => _queModel.problemAreas;

  set problemAreas(List problemAreas){
    _queModel.problemAreas = problemAreas;
    notifyListeners();
  }

  get fitnessLevel => _queModel.fitnessLevel;

  set fitnessLevel(int fitnessLevel){
    _queModel.fitnessLevel = fitnessLevel;
    notifyListeners();
  }

  get equipment => _queModel.equipment;

  set equipment(String equipment){
    _queModel.equipment = equipment;
    notifyListeners();
  }

  get dob => _queModel.dob;

  set dob(String dob){
    _queModel.dob = dob;
    notifyListeners();
  }
  
  get height => _queModel.height;

  set height(int height){
    _queModel.height = height;
    notifyListeners();
  }
  
  get weight => _queModel.weight;

  set weight(int weight){
    _queModel.weight = weight;
    notifyListeners();
  }
  get targetWeight => _queModel.targetWeight;

  set targetWeight(int targetWeight){
    _queModel.targetWeight = targetWeight;
    notifyListeners();
  }

  _init(){
    // initial value
    fitnessLevel = 1;
  }

  void goToPrevQue(){
    if(_currentQueIndex > 0){
      _currentQueIndex = _currentQueIndex - 1;
      notifyListeners();
    }
  }

  void goToNextQue(){
    if(_currentQueIndex < totalQuestion - 1){
      _currentQueIndex = _currentQueIndex + 1;
      notifyListeners();
    }
  }

  void goToParticularQue(int question){
    _currentQueIndex = question - 1;
    notifyListeners();
  }

  Future<bool> submitQuestions({String submitFrom}) async{
    _queModel.submitFrom = submitFrom;
    dynamic results = await _queRepo.postQuestionnaires(_queModel);    
    if (results['success'] == false) {
      return false;
    }
    return true;
  }

  clear(){
    _resetPageIndex();
  }

  _resetPageIndex(){
    _currentQueIndex = 0;
  }
  
  setInitalQuestionData(QuestionModel queModel){
    _queModel = queModel;
  }
}