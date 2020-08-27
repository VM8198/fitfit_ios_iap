import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/circuit_model.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/utility/sound_player.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/utility/workout_helper.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/exercise_list.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class WorkoutIntermediatePage extends StatefulWidget{
  static const routeName = '/workout-intermediate';

  @override
  _WorkoutIntermediatePageState createState() => _WorkoutIntermediatePageState();
}

class _WorkoutIntermediatePageState extends State<WorkoutIntermediatePage> {
  bool isCooldown = false;
  int timerSeconds;
  Timer _countdownTimer;
  bool isFromBeginning = false;

  @override
  void initState(){
    super.initState();
    final _workoutProvider = Provider.of<WorkoutProvider>(context,listen: false);
    int timer = _workoutProvider.nextWorkout.exerciseDuration.inSeconds;
    this.isCooldown = _workoutProvider.upNextWorkout.exerciseTitle.toLowerCase() == 'cool down';
    _startCountdown(timer);
    _workoutProvider.logTimestamp('end');
    // reset temporary unlimited set
    _workoutProvider.resetTemporaryPtUnlimitedSet();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  void _startCountdown(int seconds){
    // initial setState
    setState(() {
      timerSeconds = seconds;
    });
    
    _countdownTimer = Timer.periodic(
      Duration(seconds: 1), 
      (Timer timer) => setState(
        () {
          if (timerSeconds < 1) {
            timer.cancel();
            _timesUp();
          } else {
            timerSeconds = timerSeconds - 1;
            if(timerSeconds <= 3 && timerSeconds > 0) SoundPlayer.play();
          }
        },
      ),
    );
  }

  void _timesUp(){
    _startNextCircuit();
  }

  void _startNextCircuit(){
    _countdownTimer.cancel();
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    _workoutProvider.logTimestamp('start');
    
    if(isFromBeginning){
      //enable wake call
      Wakelock.enable();

      //send analytic event
      Utility.sendAnalyticsEvent(
        AnalyticsEventType.cw_workout_start,
        param: {'name': _workoutProvider.currentWorkoutName}
      );
      WorkoutHelper.startWorkout();
    }
    else{
      _workoutProvider.increaseCurrentWorkoutIndex();
      WorkoutHelper.startNextExercise(_workoutProvider.nextWorkout,_workoutProvider?.workoutModel);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final _workoutProvider = Provider.of<WorkoutProvider>(context,listen: false);
    List<CircuitModel> _remainingCircuit = _workoutProvider.getRemainingCircuit();
    
    final Map argument = ModalRoute.of(context).settings.arguments;
    if(argument != null && argument.isNotEmpty && isFromBeginning != argument['isBeginning']){
      setState(() {
        isFromBeginning = argument['isBeginning'];
      });
      _countdownTimer.cancel();
    }

    return Scaffold(
      backgroundColor: ThemeColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _bottomNavigationBar(context),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 16.0,right: 16.0, bottom: 24.0, left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            isFromBeginning ? 'Get Ready!' : 'Good job!',
                            style: NunitoStyle.h4,
                          ),
                        ),
                        isFromBeginning ? SizedBox() : Text(
                          'Take a short break before you continue',
                          style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    // child: Consumer<WorkoutProvider>(
                    //   builder: (_, workoutProvider, __){
                    //     return CountDownHelper(
                    //       seconds: workoutProvider.nextWorkout.exerciseDuration.inSeconds,
                    //       style: NunitoStyle.h1.copyWith(
                    //         fontSize: 44.0,
                    //         color: ThemeColor.secondaryDark
                    //       ),
                    //       onTicking: (_){},
                    //       onTimer: () => _timesUp(),
                    //       showSecondsOnly: true,
                    //     );
                    //   },
                    // ),
                    child: Visibility(
                      visible: !isFromBeginning,
                      child: Text('$timerSeconds',
                        style: NunitoStyle.h1.copyWith(
                          fontSize: 44.0,
                          color: ThemeColor.secondaryDark
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10.0,
                      spreadRadius: 0,
                      offset: Offset(0,-4.0)
                    )
                  ],
                  color: ThemeColor.white
                ),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: _remainingCircuit.map<Widget>((circuit) => _renderCircuitSection(circuit)).toList(),
                  ),
                ),
              ),
            )
          ],
        )
      )
    );
  }

  Widget _renderCircuitSection(CircuitModel circuit){
    return Column(
      children: <Widget>[
        _headingSection(circuit),
        _equipmentSection(circuit),
        _exerciseSection(circuit),
      ],
    );
  }

  Widget _headingSection(CircuitModel circuit){
    final _workoutProvider = Provider.of<WorkoutProvider>(context,listen: false);
    // Unlimited Set Logic: Resistance - Circuit 2 onwards should show unlimited sets
    bool _shouldShowPtUnlimitedSet = WorkoutHelper.isPtResistance(_workoutProvider.workoutModel)
            && circuit.name.substring(circuit.name.length - 1) != '1';

    String desc = 'Complete the indicated number of sets.';

    if(circuit.type == CircuitType.coolDown){
      desc = 'Allow your heart rate to return to its resting rate';
    }
    else if(circuit.type == CircuitType.warmUp){
      desc = '';
    }
    else if(_shouldShowPtUnlimitedSet){
      desc = 'Complete as many sets as you can within the indicated period.';
    }
    else if(WorkoutHelper.isPtCardio(_workoutProvider.workoutModel)){
      desc = 'Complete as many reps as you can within the indicated period.';
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            circuit.name,
            style: NunitoStyle.h4,
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: RichText(
              text: TextSpan(
                text: circuit.totalExercises > 0 ? '${circuit.totalExercises} Exercises' : '',
                style: NunitoStyle.body1.copyWith(color: ThemeColor.black[80]),
                children: [
                  TextSpan(
                    text: (circuit.totalExercises != null && circuit.duration != null && circuit.totalExercises > 0 && circuit.duration > 0) ? ' • ' : '',
                  ),
                  TextSpan(
                    text: (circuit.duration != null && circuit.duration > 0) ? '${circuit.duration} min' : '',
                  ),
                  TextSpan(
                    text: (circuit.noSet != null && circuit.noSet > 0 && !_shouldShowPtUnlimitedSet) ? ' • ' : '',
                  ),
                  TextSpan(
                    text: (circuit.noSet != null && circuit.noSet > 0 && !_shouldShowPtUnlimitedSet) ? '${circuit.noSet} ${circuit.noSet == 1 ? 'set' : 'sets'}' : '',
                  ),
                ]
              ),
            ),
          ),
          Visibility(
            visible: desc != '',
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Divider(),
          ),
        ],
      ),
    );
  }

  Widget _equipmentSection(CircuitModel circuit){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Equipment'.toUpperCase(),
                  style: NunitoStyle.caption1,
                ),
              ),
            ],
          ),
          ...circuit.equipments.map( (eq) => Text(
            eq,
            style: NunitoStyle.body2.copyWith(color: ThemeColor.black[100]),
          )),
          Visibility(
            visible: circuit.equipments.length == 0,
            child: Text('None', style: NunitoStyle.body2.copyWith(color: ThemeColor.black[100]),)
          )
        ],
      ),
    );
  }

  Widget _exerciseSection(CircuitModel circuit){
    return Container(
      padding: EdgeInsets.only(bottom: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Exercise'.toUpperCase(),
                  style: NunitoStyle.caption1,
                ),
              ),
            ],
          ),
          ExerciseList(
            imgList: circuit.exercisesOnly.map<ExerciseSliderModel>( (exercise) => exercise.toExerciseSlider()).toList(),
            withCaption: true,
            withFavIcon: false,
            onImageTap: (){},
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context){
    final _workoutProvider = Provider.of<WorkoutProvider>(context,listen: false);
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: ThemeColor.black[08])
          ),
          color: Colors.white
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CtaButton(
                    'Start${isCooldown ? ' Cool Down' : ''}',
                    onPressed: (_) => _startNextCircuit(),
                  ),
                ),
              ],
            ),
            isCooldown ? FlatButton(
              child: Text(
                'Skip Cool Down',
                style: NunitoStyle.body1.copyWith(
                  color: ThemeColor.black[80],
                  decoration: TextDecoration.underline
                ),
              ),
              onPressed: () => WorkoutHelper.startNextExercise(null,_workoutProvider.workoutModel),
            ) : const SizedBox(),
            isFromBeginning ? FlatButton(
              child: Text(
                'Go back',
                style: NunitoStyle.body1.copyWith(
                  color: ThemeColor.black[80],
                  decoration: TextDecoration.underline
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ) : const SizedBox()
          ],
        ),
      ),
    );
  }
}