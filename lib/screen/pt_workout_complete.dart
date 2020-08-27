import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/timestamp_model.dart';
import 'package:flutter_fitfit/provider/pt_provider.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/screen/workout_feedback.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/image_network_cache.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class PtWorkoutCompletePage extends StatefulWidget{
  static const routeName = '/pt-workout-complete';
  final Map argument;

  PtWorkoutCompletePage({this.argument});

  @override
  _PtWorkoutCompletePageState createState() => _PtWorkoutCompletePageState();
}

class _PtWorkoutCompletePageState extends State<PtWorkoutCompletePage> {
  
  @override
  void initState(){
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

      // _workoutProvider.resetWorkout();
    });
  }

  void _postWorkoutComplete(String id) async{
    await Provider.of<PtProvider>(context, listen: false).postCompleteWorkout(id);
  }

  @override
  Widget build(BuildContext context) {    return Scaffold(
      backgroundColor: ThemeColor.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CtaButton(
            'Continue',
            onPressed: (context){
              Nav.navigateTo(WorkoutFeedbackPage.routeName);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: _completeWorkoutSection()
      ),
    );
  }

  Widget _animation(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    return Stack(
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
                '${_workoutProvider.currentWorkoutName ?? ''} Complete',
                style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _completeWorkoutSection(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final _size = MediaQuery.of(context).size;
    
    int currentTimestamp =  new DateTime.now().millisecondsSinceEpoch;
    TimestampModel _timestampList = _workoutProvider.workoutTimestampModel;

    // add last ending if null
    if(_timestampList.exercise.workout.end == null) _timestampList.exercise.workout.end = currentTimestamp;
    if(_timestampList.cooldown.workout.start != null) _timestampList.cooldown.workout.end = currentTimestamp;

    // calculate warmup total pauses in seconds
    int warmupPause = 0;
    if(_timestampList.warmup.pauses.isNotEmpty){
      _timestampList.warmup.pauses.forEach((pause) {
        warmupPause += pause.end - pause.start;
      });
    }

    int exercisePause = 0;
    if(_timestampList.exercise.pauses.isNotEmpty){
      _timestampList.exercise.pauses.forEach((pause) {
        exercisePause += pause.end - pause.start;
      });
    }

    int cooldownPause = 0;
    if(_timestampList.cooldown.pauses.isNotEmpty){
      _timestampList.cooldown.pauses.forEach((pause) {
        cooldownPause += pause.end - pause.start;
      });
    }
    
    int _totalWarmupTime = (_timestampList.warmup.workout.start != null && _timestampList.warmup.workout.end != null)  ? (_timestampList.warmup.workout.end - _timestampList.warmup.workout.start) - warmupPause : 0;
    Duration _warmupTimes = Duration(milliseconds: !_totalWarmupTime.isNegative ? _totalWarmupTime : 0);

    int _totalExTime = (_timestampList.exercise.workout.start != null && _timestampList.exercise.workout.end != null)  ? (_timestampList.exercise.workout.end - _timestampList.exercise.workout.start) - exercisePause : 0;
    Duration _exTimes = Duration(milliseconds: !_totalExTime.isNegative ? _totalExTime : 0);

    int _totalCooldownTime = (_timestampList.cooldown.workout.start != null && _timestampList.cooldown.workout.end != null)  ? (_timestampList.cooldown.workout.end - _timestampList.cooldown.workout.start) - cooldownPause : 0;
    Duration _cooldownTimes = Duration(milliseconds: !_totalCooldownTime.isNegative ? _totalCooldownTime : 0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${_workoutProvider.currentWorkoutName ?? ''} Complete!', 
              textAlign: TextAlign.center, 
              style: NunitoStyle.h3,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            width: _size.width,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: ImageNetworkCache(
                src: _workoutProvider.workoutModel.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Warm Up'.toUpperCase(),
                        style: NunitoStyle.caption1,
                      ),
                      Text(
                        '${_warmupTimes.inSeconds > 0 ? Utility.prettifyDurationTime(_warmupTimes.inSeconds) : '-'}',
                        style: NunitoStyle.title2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Workout'.toUpperCase(),
                        style: NunitoStyle.caption1,
                      ),
                      Text(
                        '${_exTimes.inSeconds > 0 ? Utility.prettifyDurationTime(_exTimes.inSeconds) : '-'}',
                        style: NunitoStyle.title2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cool Down'.toUpperCase(),
                        style: NunitoStyle.caption1,
                      ),
                      Text(
                        '${_cooldownTimes.inSeconds > 0 ? Utility.prettifyDurationTime(_cooldownTimes.inSeconds) : '-'}',
                        style: NunitoStyle.title2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Exercises'.toUpperCase(),
                        style: NunitoStyle.caption1,
                      ),
                      Text(
                        '${_workoutProvider.totalUniqueExercises}',
                        style: NunitoStyle.title2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}