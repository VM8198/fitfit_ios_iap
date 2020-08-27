import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_timer_model.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/quit_dialog.dart';
import 'package:flutter_fitfit/utility/sound_player.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/utility/workout_helper.dart';
import 'package:flutter_fitfit/widget/countdown_helper.dart';
import 'package:flutter_fitfit/widget/media_controller.dart';
import 'package:flutter_fitfit/widget/percent_bar.dart';
import 'package:flutter_fitfit/widget/upnext_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class WorkoutCircularTimerPage extends StatefulWidget{
  static const routeName = '/workout-circular-timer';

  @override
  _WorkoutCircularTimerPageState createState() => _WorkoutCircularTimerPageState();
}

class _WorkoutCircularTimerPageState extends State<WorkoutCircularTimerPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPlaying = true;
  double _exCompletion = 0;
  Timer _countdownTimer;

  @override
  void initState(){
    super.initState();
  }
  
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  void _togglePlayState(){
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _updateDuration(int currentSec, int duration, {bool withSound: true}){
    if(currentSec <= 3 && currentSec > 0 && withSound) SoundPlayer.play();
    setState(() {
      _exCompletion = 1 - (currentSec / duration);
    });

    if(_exCompletion == 1) _timesUp();
  }

  void _timesUp(){
    _countdownTimer = Timer.periodic(
      // Steal 1 second
      Duration(seconds: 1), 
      (Timer timer) {
        timer.cancel();
        _goToNextExercise();
      }
    );
  }

  void _goToPreviousExercise(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    _workoutProvider.decreaseCurrentWorkoutIndex();
    WorkoutHelper.startNextExercise(_workoutProvider.nextWorkout, _workoutProvider.workoutModel);
  }

  void _goToNextExercise(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    _workoutProvider.increaseCurrentWorkoutIndex();
    WorkoutHelper.startNextExercise(_workoutProvider.nextWorkout, _workoutProvider.workoutModel);
  }

  void _showPauseOption(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    _workoutProvider.logTimestamp('pauseStart');
    
    if(!_isPlaying) showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext bc){
        return SafeArea(
          child: Wrap(
            children: <Widget>[ 
              ListTile(
                title: Text(
                  'Skip this circuit',
                  textAlign: TextAlign.center,
                  style: NunitoStyle.title2.copyWith(color: ThemeColor.black[80]),
                ),
                 onTap: () {
                  showDialog(
                    context: context,
                    child: QuitDialog(
                      content: 'Are you sure you want to skip this entire circuit?',
                      onProceed: () => {
                        _workoutProvider.logTimestamp('pauseEnd'),
                        WorkoutHelper.skipCircuit(context),
                      },
                    )
                  );
                }
              ),
              ListTile(
                title: Text(
                  'Resume workout',
                  textAlign: TextAlign.center,
                  style: NunitoStyle.title2.copyWith(color: ThemeColor.black[80]),
                ),
                onTap: () => {
                  _workoutProvider.logTimestamp('pauseEnd'),
                  Navigator.pop(context)
                }
              ),
              ListTile(
                title: Text(
                  'Quit workout',
                  textAlign: TextAlign.center,
                  style: NunitoStyle.title2.copyWith(color: ThemeColor.favoriteRed),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    child: QuitDialog(
                      content: 'Are you sure you want to quit? Your progress for this workout will not be saved.',
                      // onProceed: () => Nav.navigateTo(WorkoutQuitSurveyPage.routeName),
                      onProceed: () => WorkoutHelper.quitWorkout(context),
                    )
                  );
                }
              ),
            ],
          ),
        );
      }
    ).whenComplete((){
      _togglePlayState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);
    final _duration = _workoutProvider.nextWorkout != null ? _workoutProvider.nextWorkout.exerciseDuration.inSeconds : 0;
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    bool _isSetCompleted = (arguments != null && arguments['isSetCompleted'] != null) ?? false;
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Consumer<WorkoutProvider>(
                builder: (_, _provider, __) {
                  return Visibility(
                    visible: _provider.workoutProgress > 0 && _provider.workoutProgress <= 1.0,
                    child: PercentBar(
                      width: size.width,
                      percent: _provider.workoutProgress <= 1.0 ? _provider.workoutProgress : 0,
                      bgColor: PercentBarBackgroundColor.transparent,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _workoutProvider.nextWorkout != null ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _workoutProvider.nextWorkout.exerciseTitle != null ? _workoutProvider.nextWorkout.exerciseTitle.toUpperCase() : '',
                          textAlign: TextAlign.center,
                          style: NunitoStyle.body2.copyWith(fontSize: 12.0, color: ThemeColor.black[56]),
                        ),
                        Visibility(
                          visible: !_isSetCompleted,
                          child: Text(
                            _workoutProvider?.nextWorkout?.exerciseName ?? '',
                            textAlign: TextAlign.center,
                            style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),
                          ),
                        )
                      ],
                    ) : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 48.0,bottom: 70.0),
                      child: _isSetCompleted ? Column(
                        children: <Widget>[
                          SizedBox(
                            width: 0.5 * size.width,
                            height: 0.5 * size.width,
                            child: Lottie.asset(
                              Utility.iconPath + 'lottie-complete.json',
                              fit: BoxFit.fitWidth,
                              repeat: false
                            ),
                          ),
                          Text(
                            'Completed!',
                            style: NunitoStyle.h3,
                          ),
                          // just a hack to use countdown, will change this during refactor
                          CountDownHelper(
                            seconds: 3,
                            style: NunitoStyle.h1.copyWith(fontSize: 1, color: Colors.transparent),
                            onTicking: (val) => _updateDuration(val, _duration, withSound: false),
                            onPause: !_isPlaying,
                          ),
                        ],
                      ) : CircularPercentIndicator(
                        radius: 0.6 * size.width,
                        lineWidth: 11.0,
                        percent: _exCompletion,
                        animation: true,
                        animationDuration: 1000,
                        animateFromLastPercent: true,
                        center: CountDownHelper(
                          seconds: _duration,
                          style: NunitoStyle.h1.copyWith(fontSize: 56.0, color: ThemeColor.black[100]),
                          onTicking: (val) => _updateDuration(val, _duration),
                          onPause: !_isPlaying,
                        ),
                        progressColor: ThemeColor.primaryDark,
                        backgroundColor: ThemeColor.black[08],
                      ),
                    ),
                    Container(
                      width: 0.6 * size.width,
                      child: MediaController(
                        isPlaying: _isPlaying,
                        onPlayOrPause: () => {
                          _togglePlayState(),
                          _showPauseOption()
                        },
                        onPrevious: () => {
                          _togglePlayState(),
                          _goToPreviousExercise()
                        },
                        onSkip: () => {
                          _togglePlayState(),
                          _goToNextExercise(),
                        },
                      )
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: _workoutProvider.upNextWorkout != null ? Container(
                width: size.width,
                child: UpNextBar(
                  exerciseName: _workoutProvider.upNextWorkout.exerciseName,
                  frequency: _workoutProvider.upNextWorkout.oriDurationString,
                ),
              ) : Container(),
            )
          ],
        ),
      )
    );
  }
}
