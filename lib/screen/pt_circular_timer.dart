import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/circuit_model.dart';
import 'package:flutter_fitfit/model/exercise_model.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_model.dart';
import 'package:flutter_fitfit/provider/pt_provider.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/quit_dialog.dart';
import 'package:flutter_fitfit/utility/sound_player.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/utility/workout_helper.dart';
import 'package:flutter_fitfit/widget/countdown_helper.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/curved_app_bar.dart';
import 'package:flutter_fitfit/widget/percent_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class PtCircularTimerPage extends StatefulWidget{
  static const routeName = '/pt-circular-timer';
  final Map argument;

  PtCircularTimerPage({this.argument});

  @override
  _PtCircularTimerPageState createState() => _PtCircularTimerPageState();
}

class _PtCircularTimerPageState extends State<PtCircularTimerPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPlaying = true;
  double _exCompletion = 0;
  Timer _countdownTimer;
  int _currentSelectedTimer = 0;
  String workoutId;
  String workoutTitle;
  bool isWorkoutCompleted = false;
  final _duration = 900; // temporary hardcoded for LI

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
        setState(() {
          isWorkoutCompleted = true;
        });
        // post complete workout
        _postWorkoutComplete(workoutId);
      }
    );
  }

  void _postWorkoutComplete(String id) async{
    await Provider.of<PtProvider>(context, listen: false).postCompleteWorkout(id);
  }

  void _showPauseOption(){
    if(!_isPlaying) showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext bc){
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Resume workout',
                  textAlign: TextAlign.center,
                  style: NunitoStyle.title2.copyWith(color: ThemeColor.black[80]),
                ),
                onTap: () => {
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

  // Widget _buildPickerNumberLabel(String text, EdgeInsets padding) {
  //   return Container(
  //     width: 400,
  //     alignment: AlignmentDirectional.center,
  //     child: Container(
  //       width: 300,
  //       margin: EdgeInsets.only(right: 30),
  //       alignment: Alignment.center,
  //       child: Text(
  //         text, 
  //         softWrap: false, 
  //         maxLines: 1, 
  //         overflow: TextOverflow.visible,
  //         textAlign: TextAlign.left,
  //         style: TextStyle(fontSize: 20),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    bool _isSetCompleted = (arguments != null && arguments['isSetCompleted'] != null) ?? false;
    String _title = widget.argument != null && widget.argument.isNotEmpty ? widget.argument['title'] : '';
    String _workoutId = widget.argument != null && widget.argument.isNotEmpty ? widget.argument['pt_workout_id'] : '';

    if(workoutId == null){
      setState(() {
        workoutId = _workoutId;
        workoutTitle = _title;
      });
    }
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: curvedAppBar(
        leading: BackButton(color: ThemeColor.black[100],),
        title: Text(
          workoutTitle, 
          style: NunitoStyle.h4.copyWith(color: ThemeColor.black[100]),
        )
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: isWorkoutCompleted ? 
            CtaButton(
              'Go back to homepage',
              onPressed: (_) => Navigator.of(context).pop(),
            ) : CtaButton(
            'Pause',
            onPressed: (_){
              _togglePlayState();
              _showPauseOption();
            },
          ),
        ),
      ),
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
                    Padding(
                      padding: EdgeInsets.only(top: 48.0,bottom: 70.0),
                      child: isWorkoutCompleted ? Column(
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
                    // Container(
                    //   // child: CupertinoTimerPicker(
                    //   //   mode: CupertinoTimerPickerMode.ms,
                    //   //   onTimerDurationChanged: (Duration value) {
                    //   //     print(value);
                    //   //   },
                    //   // ),
                    //   height: 100,
                    //   child: CupertinoPicker(
                    //     scrollController: FixedExtentScrollController(
                    //       initialItem: 0,
                    //     ),
                    //     itemExtent: 25,
                    //     backgroundColor: Colors.transparent,
                    //     squeeze: 1.45,
                    //     looping: true,
                    //     onSelectedItemChanged: (int index) {
                    //       setState(() {
                    //         _currentSelectedTimer = index;
                    //       });
                    //     },
                    //     children: List<Widget>.generate(60, (int index) {
                    //       final int minute = index;

                    //       return _buildPickerNumberLabel(
                    //         '$minute ${_currentSelectedTimer == index ? 'min' : ''}',
                    //         EdgeInsets.only(right: 30)
                    //       );
                    //     }),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
