import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/provider/pt_provider.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class WorkoutCompletePage extends StatefulWidget{
  static const routeName = '/workout-complete';
  final Map argument;

  WorkoutCompletePage({this.argument});

  @override
  _WorkoutCompletePageState createState() => _WorkoutCompletePageState();
}

class _WorkoutCompletePageState extends State<WorkoutCompletePage> {
  
  @override
  void initState(){

    //disable wake call
    Wakelock.disable();

    super.initState();
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_){
      Utility.sendAnalyticsEvent(
        AnalyticsEventType.cw_workout_complete, 
        param: {'name': _workoutProvider.currentWorkoutName}
      );
      
      if(widget.argument != null && widget.argument['workoutId'] != null){
        // PT LI / HI Own Cardio
        _postWorkoutComplete(widget.argument['workoutId']);
      }
      else if(_workoutProvider.workoutModel != null && _workoutProvider.workoutModel.workoutType == WorkoutType.personalTraining){
        // Other PT Workout
        _postWorkoutComplete(_workoutProvider.workoutModel.id);
      }

      _workoutProvider.resetWorkout();
    });
  }

  void _postWorkoutComplete(String id) async{
    await Provider.of<PtProvider>(context, listen: false).postCompleteWorkout(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('lib/asset/icon/lottie-star.json'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Congratulations!',
                      style: NunitoStyle.h3.copyWith(color: ThemeColor.black[100]),
                    ),
                  ),
                  Text(
                    'Workout Complete',
                    style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CtaButton('Go back to Homepage', onPressed: (_) => Nav.clearAllAndPush(HomePage.routeName),),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}