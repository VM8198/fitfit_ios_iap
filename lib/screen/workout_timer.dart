import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_timer_model.dart';
import 'package:flutter_fitfit/provider/timer_provider.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/quit_dialog.dart';
import 'package:flutter_fitfit/utility/sound_player.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/utility/workout_helper.dart';
import 'package:flutter_fitfit/widget/countdown_helper.dart';
import 'package:flutter_fitfit/widget/custom_loading.dart';
import 'package:flutter_fitfit/widget/empty_holder.dart';
import 'package:flutter_fitfit/widget/media_controller.dart';
import 'package:flutter_fitfit/widget/overall_timer.dart';
import 'package:flutter_fitfit/widget/percent_bar.dart';
import 'package:flutter_fitfit/widget/upnext_bar.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class WorkoutTimerPage extends StatefulWidget{
  static const routeName = '/workout-timer';
  final Map argument;

  WorkoutTimerPage({this.argument});

  @override
  _WorkoutTimerPageState createState() => _WorkoutTimerPageState();
}

class _WorkoutTimerPageState extends State<WorkoutTimerPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  VideoPlayerController _videoController;
  WorkoutProvider _workoutProvider;
  TimerProvider _timerProvider;
  bool _isPlaying = true;
  double _exCompletion = 0;
  bool _pauseVisible = true;
  Timer _countdownTimer;
  bool _isStarting = false;
  bool _isUnlimitedWorkoutSet = false;

  @override
  void initState(){
    _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    _timerProvider = Provider.of<TimerProvider>(context, listen: false);
    
    _videoController = VideoPlayerController.network(
        _workoutProvider.nextWorkout.mediaUrl)
      ..addListener(() {
        final bool isStarted = _videoController.value.isPlaying;
        if (isStarted != _isStarting) {
          setState(() {
            _isStarting = isStarted;
          });

          _countdownTimer = Timer.periodic(
            Duration(seconds: 3), 
            (Timer timer) {
              timer.cancel();
              setState(() {
                _pauseVisible = !_pauseVisible;
              });
            }
          );
        } 
      })
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
      });

    if(_workoutProvider.nextWorkout.exerciseTitle.contains('Circuit')){
      TimerProvider _timerProvider = Provider.of<TimerProvider>(context, listen: false);
      String _circuitString = _workoutProvider.nextWorkout.exerciseTitle.substring(8,10);
      _circuitString.replaceAll(' ', '');
      int _circuitNo = int.parse(_circuitString);

      if(!_timerProvider.hasOverallTimeFinish){
        _timerProvider.resumeOverallTimer();
      }

      if(_circuitNo >= 2 && WorkoutHelper.isPtResistance(_workoutProvider.workoutModel)){
        _isUnlimitedWorkoutSet = true;
        if(_timerProvider.hasOverallTimeFinish){
          int _circuitDurationInMin = _workoutProvider.workoutModel.exerciseCircuits[_circuitNo-1].duration;
          _timerProvider.startOverallTimer(overallTimeInSeconds: Duration(minutes: _circuitDurationInMin).inSeconds);
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _videoController?.dispose();
    _videoController = null;
    super.dispose();
  }

  void _togglePlayState(){
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if(_isPlaying && _videoController.value.isPlaying == false){
      _videoController.play();
      _timerProvider.resumeOverallTimer();
    }
    else{
      _videoController.pause();
      _timerProvider.pauseOverallTimer();
    }
  }

  void _updateDuration(int currentSec, int duration){
    if(currentSec <= 3 && currentSec > 0) SoundPlayer.play();
    setState(() {
      _exCompletion = 1 - (currentSec / duration);
    });

    if(_exCompletion == 1) _timesUp();
  }

  void _timesUp(){
    Timer.periodic(
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
    WorkoutHelper.startNextExercise(_workoutProvider.nextWorkout,_workoutProvider.workoutModel);
  }

  void _goToNextExercise(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final _timerProvider = Provider.of<TimerProvider>(context, listen: false);
    
    //TODO: refactor this
    if(_workoutProvider.nextWorkout.exerciseTitle.contains('Circuit')){
      String _circuitString = _workoutProvider.nextWorkout.exerciseTitle.substring(8,10);
      _circuitString.replaceAll(' ', '');
      int _circuitNo = int.parse(_circuitString);

      // check if overall timer has not ended and apply unlimited set logic
      if(_circuitNo >= 2 && WorkoutHelper.isPtResistance(_workoutProvider.workoutModel)){

        // if has entered unlimited set loop and not overall timer is running
        if(_workoutProvider.upNextWorkout.exerciseType == ExerciseType.setRest
            && !_timerProvider.hasOverallTimeFinish){
          List<WorkoutTimerModel> _currentCircuitEx = [];
          int _currentIndex = _workoutProvider.nextWorkout.circuitIndex;
          _workoutProvider.workoutList.forEach((workout){
            if(workout.circuitIndex == _currentIndex) _currentCircuitEx.add(workout);
          });
          _workoutProvider.temporaryPtUnlimitedSetList = _currentCircuitEx;
          _workoutProvider.workoutList.insert(
            _workoutProvider.upNextIndex, 
            _workoutProvider.temporaryPtUnlimitedSetList[_workoutProvider.currentTemporaryPtUnlimitedSetIndex]
          );

          _workoutProvider.increaseTemporaryPtUnlimitedSetIndex();
        }
        // end circuit immediately upon time's up no matter still have ex in the workout list or not
        else if(_timerProvider.hasOverallTimeFinish){
          List<WorkoutTimerModel> _remaining = _workoutProvider.workoutList.skip(_workoutProvider.currentWorkoutIndex).toList();
          int _nextSetRestIndex = 0;

          for(var i=0; i < _remaining.length; i++){
            WorkoutTimerModel workout = _remaining[i];

            if(workout.exerciseType == ExerciseType.setRest){
              _nextSetRestIndex = i;
              break;
            }
          }

          _workoutProvider.increaseCurrentWorkoutIndex(index: _nextSetRestIndex);
          WorkoutHelper.startNextExercise(_workoutProvider.nextWorkout,_workoutProvider.workoutModel);
          return ;
        }
      }
    }
    _workoutProvider.increaseCurrentWorkoutIndex();
    WorkoutHelper.startNextExercise(_workoutProvider.nextWorkout,_workoutProvider.workoutModel);
  }

  void _showPauseOption(){
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
                        WorkoutHelper.skipCircuit(context)
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
                      onProceed: () {
                        Utility.sendAnalyticsEvent(
                          AnalyticsEventType.cw_workout_quit,
                          param: {'name': _workoutProvider.currentWorkoutName}
                        );
                        WorkoutHelper.quitWorkout(context);
                      },
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

  void _logPauseEvent(){
    Utility.sendAnalyticsEvent(
      AnalyticsEventType.cw_workout_pause,
      param: {'name': _workoutProvider.currentWorkoutName}
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _media(size),
                      Selector<TimerProvider,bool>(
                        selector: (_,provider) => provider.hasOverallTimeFinish,
                        builder: (_, isEnded, __){
                          if(isEnded && _isUnlimitedWorkoutSet) {
                            _timesUp();
                          }
                          return !isEnded ? Align(
                            alignment: Alignment.topRight,
                            child: OverallTimer()
                          ) : SizedBox();
                        }
                      )
                    ],
                  ),
                  _middleSection(size),
                  _upNextSection(size),
                ],
              ),
            ),
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
          ],
        ),
      )
    );
  }

  Widget _media(size){
    String videoUrl = _workoutProvider.nextWorkout != null ? _workoutProvider.nextWorkout.mediaUrl : null;

    return GestureDetector(
      onTap: () => {
        _logPauseEvent(),
        _togglePlayState(),
        _showPauseOption()
      },
      child: videoUrl != null ? SizedBox(
        width: size.width,
        height: size.width,
        child: _videoController.value.initialized ? Stack(
          children: <Widget>[
            VideoPlayer(_videoController),
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _pauseVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Icon(
                  Icons.pause,
                  size: 70.0,
                  color: Colors.white.withOpacity(0.7)
                ),
              ),
            )
          ],
        ) : Center(
          child: CustomLoading(),
        )
      ) : SizedBox(
        width: size.width,
        height: size.width,
        child: EmptyHolder(EmptyStateType.video),
      ),
    );
  }

  Widget _middleSection(size){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _exTitle(),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: _mediaController(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exTitle(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final _workout = _workoutProvider.nextWorkout;
    // for PT R-2 onwards and unlimited workout set
    int _currentSet = _isUnlimitedWorkoutSet ? _workoutProvider.currentTemporaryPtUnlimitedSetNumber : 0;

    return _workout != null ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '${_workout.exerciseTitle.toUpperCase()}${_currentSet > 0 ? '- SET $_currentSet' : ''}',
          textAlign: TextAlign.center,
          style: NunitoStyle.body2.copyWith(fontSize: 12.0, color: ThemeColor.black[56]),
        ),
        Text(
          _workout?.exerciseName ?? '-',
          textAlign: TextAlign.center,
          style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),
        )
      ],
    ) : Container();
  }

  Widget _mediaController(size){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final _workout = _workoutProvider.nextWorkout;

    return _workout != null ? MediaController(
      isPlaying: _isPlaying,
      showPlayOrPauseIcon: false,
      middleWidget: Column(
        children: <Widget>[
          Visibility(
            visible: _workout.showDuration != null && _workout.showDuration,
            child: CountDownHelper(
              seconds: _workout.exerciseDuration.inSeconds,
              style: NunitoStyle.h1.copyWith(fontSize: 56.0, color: ThemeColor.black[100]),
              onTicking: (val) => _updateDuration(val, _workout.exerciseDuration.inSeconds),
              onPause: !_isPlaying,
            ),
          ),
          Visibility(
            visible: _workout.showReps != null && _workout.showReps,
            child: Text(
              '${_workout.exerciseReps} reps',
              style: NunitoStyle.h1.copyWith(fontSize: 56.0, color: ThemeColor.black[100]),
            ),
          ),
          Visibility(
            visible: _workout.perSideExercise != null && _workout.perSideExercise,
            child: Text(
              _workout.perSideExercise != null && _workout.perSideExercise ? '${_workout.durationString} per side' : '',
              style: NunitoStyle.h4.copyWith(color: ThemeColor.black[56]),
            ),
          )
        ],
      ),
      onPrevious: () => {
        _togglePlayState(),
        _goToPreviousExercise()
      },
      onSkip: () {
        _togglePlayState();
        _goToNextExercise();
        Utility.sendAnalyticsEvent(
          AnalyticsEventType.cw_workout_skip,
          param: {'name': _workoutProvider.currentWorkoutName}
        );
      },
    ) : Container();
  }

  Widget _upNextSection(size){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    // display unlimited set ex name if applicable (for PT R-2 onwards)
    String _exName = _workoutProvider.currentTemporaryPtUnlimitedSetIndex > 0 && _isUnlimitedWorkoutSet ? _workoutProvider.temporaryPtUnlimitedSetList[_workoutProvider.currentTemporaryPtUnlimitedSetIndex]?.exerciseName : _workoutProvider.upNextWorkout?.exerciseName;

    return _workoutProvider.upNextWorkout != null ? Container(
      width: size.width,
      child: UpNextBar(
        exerciseName: _exName,
        frequency: _workoutProvider.upNextWorkout.oriDurationString,
      ),
    ) : Container();
  }
}
