
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_model.dart';
import 'package:flutter_fitfit/model/workout_timer_model.dart';
import 'package:flutter_fitfit/provider/timer_provider.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/screen/pt_workout_complete.dart';
import 'package:flutter_fitfit/screen/workout_circular_timer.dart';
import 'package:flutter_fitfit/screen/workout_complete.dart';
import 'package:flutter_fitfit/screen/workout_intermediate.dart';
import 'package:flutter_fitfit/screen/workout_ready.dart';
import 'package:flutter_fitfit/screen/workout_timer.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class WorkoutHelper{

  static startWorkout(){
    // 8s get ready timer
    return Nav.clearAllAndPush(WorkoutReadyPage.routeName);
  }

  static startNextExercise(
    WorkoutTimerModel nextWorkout,
    WorkoutModel workoutModel,
    {bool isSetCompleted, bool isCircuitCompleted, bool isWorkoutCompleted, String workoutId}){
    if(nextWorkout == null){
      if(workoutModel.workoutType == WorkoutType.personalTraining){
        return Nav.clearAllAndPush(
          PtWorkoutCompletePage.routeName, 
          args: workoutId != null ? {'workoutId': workoutId} : null
        );
      }

      return Nav.clearAllAndPush(
        WorkoutCompletePage.routeName, 
        args: workoutId != null ? {'workoutId': workoutId} : null
      );
    }
    else if(nextWorkout.exerciseType == ExerciseType.rest){
      return Nav.clearAllAndPush(WorkoutCircularTimerPage.routeName);
    }
    else if(nextWorkout.exerciseType == ExerciseType.warmUp){
      return Nav.clearAllAndPush(WorkoutCircularTimerPage.routeName);
    }
    else if(nextWorkout.exerciseType == ExerciseType.setRest){
      return Nav.clearAllAndPush(WorkoutCircularTimerPage.routeName, args: {'isSetCompleted': true});
    }
    else if(nextWorkout.exerciseType == ExerciseType.circuitRest){
      return Nav.clearAllAndPush(WorkoutIntermediatePage.routeName);
    }
    else{
      return Nav.clearAllAndPush(WorkoutTimerPage.routeName);
    }
  }

  static transformExTypeToCategory(ExerciseType type, {String exerciseCircuitSetTitle}){
    if(type == ExerciseType.warmUp){
      return 'Warm Up';
    }
    else if(type == ExerciseType.coolDown){
      return 'Cool Down';
    }
    else if(type == ExerciseType.exercise){
      return exerciseCircuitSetTitle;
    }
    else if(type == ExerciseType.rest){
      return '';
    }
    else{
      return '';
    }
  }

  static quitWorkout(BuildContext context){

    //disable wake call
    Wakelock.disable();

    Provider.of<WorkoutProvider>(context, listen: false).resetWorkout();
    Provider.of<TimerProvider>(context, listen: false).setOverallTime(0);
    Nav.clearAllAndPush(HomePage.routeName);
  }

  static isPtResistance(WorkoutModel workoutModel){
    return workoutModel.workoutType == WorkoutType.personalTraining 
            && workoutModel.ptWorkoutType == PtWorkoutType.resistance;
  }

  static isPtCardio(WorkoutModel workoutModel){
    return workoutModel.workoutType == WorkoutType.personalTraining 
            && workoutModel.ptWorkoutType == PtWorkoutType.cardio;
  }

  static skipCircuit(BuildContext context){
    WorkoutProvider _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    _workoutProvider.setNextCircuitFirstWorkoutIndex();

    // reset
    Provider.of<TimerProvider>(context, listen: false).setOverallTime(0);
    // proceed to next page
    startNextExercise(_workoutProvider.nextWorkout,_workoutProvider.workoutModel);
  }
}