import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/utility/sound_player.dart';
import 'package:flutter_fitfit/utility/workout_helper.dart';
import 'package:provider/provider.dart';

class WorkoutReadyPage extends StatefulWidget{
  static const routeName = '/workout-ready';

  @override
  _WorkoutReadyPageState createState() => _WorkoutReadyPageState();
}

class _WorkoutReadyPageState extends State<WorkoutReadyPage> {
  int _countdown = 8;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        _countdown = _countdown - 1;
      });

      if(_countdown <= 3 && _countdown > 0) SoundPlayer.play();

      if(_countdown == 0) {
        _stopTimerAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stopTimerAndNavigate(){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    
    _timer.cancel();

    WorkoutHelper.startNextExercise(_workoutProvider.nextWorkout,_workoutProvider.workoutModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                child: Text(
                  'Skip',
                  style: NunitoStyle.button2.copyWith(color: ThemeColor.black[80]),
                ),
                onPressed: () => _stopTimerAndNavigate(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Get Ready',
                    style: NunitoStyle.h2.copyWith(color: ThemeColor.black[80]),
                  ),
                  Text(
                    '$_countdown',
                    style: NunitoStyle.h1.copyWith(
                      fontSize: 100.0,
                      color: ThemeColor.secondaryDark
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}