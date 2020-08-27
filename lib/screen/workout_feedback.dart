import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/slider.dart';
import 'package:provider/provider.dart';

class WorkoutFeedbackPage extends StatelessWidget{
  static const routeName = '/workout-feedback';

  final Map _displayValues = {
    1: {
      'emoji': 'feedback-1.png',
      'value': 'too-easy',
    },
    2: {
      'emoji': 'feedback-1.png',
      'value': 'too-easy',
    },
    3: {
      'emoji': 'feedback-1.png',
      'value': 'too-easy',
    },
    4: {
      'emoji': 'feedback-1.png',
      'value': 'too-easy',
    },
    5: {
      'emoji': 'feedback-3.png',
      'value': 'just-nice',
    },
    6: {
      'emoji': 'feedback-3.png',
      'value': 'just-nice',
    },
    7: {
      'emoji': 'feedback-2.png',
      'value': 'too-hard',
    },
    8: {
      'emoji': 'feedback-2.png',
      'value': 'too-hard',
    },
    9: {
      'emoji': 'feedback-2.png',
      'value': 'too-hard',
    },
    10: {
      'emoji': 'feedback-2.png',
      'value': 'too-hard',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).canPop() ? Navigator.of(context).pop() : {},
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CtaButton(
            'Submit',
            onPressed: (context) async{
              bool success = await Provider.of<WorkoutProvider>(context,listen:false).submitWorkoutFeedback();
              if(success){
                Nav.clearAllAndPush(HomePage.routeName);
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 48.0),
              child: _description(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 48.0),
              child: _content(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _description(){
    return Column(
      children: <Widget>[
        Text(
          'How was the workout?',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Let us know your feedback and we\'ll adapt your next week\'s training plan accordingly.',
            textAlign: TextAlign.center,
            style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
          ),
        ),
      ],
    );
  }

  Widget _content(context){
    return Consumer<WorkoutProvider>(
      builder: (_,wp,__){
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Image.asset(
                    Utility.emojiPath + "${_displayValues[wp.workoutFeedback]['emoji']}",
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              _slider(context),
            ],
          ),
        );
      },
    );
  }

  // TODO: Move to common component
  Widget _slider(context){
    return Consumer<WorkoutProvider>(
      builder: (_,wp,__){
        return Column(
          children: <Widget>[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: ThemeColor.primaryDark,
                inactiveTrackColor: ThemeColor.black[08],
                trackHeight: 8.0,
                thumbColor: ThemeColor.primaryDark,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 16.0),
                overlayColor: ThemeColor.primaryDark,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                activeTickMarkColor: ThemeColor.primaryDark,
                inactiveTickMarkColor: ThemeColor.primaryLight,
                tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 3.5)
              ),
              child: Slider(
                min: 1,
                max: 10,
                value: wp.workoutFeedback.toDouble(), 
                divisions: 9,
                onChanged: (double value) {
                  final _workoutProvider = Provider.of<WorkoutProvider>(context,listen: false);
                  _workoutProvider.workoutFeedback = value.toInt();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Too Easy', style: NunitoStyle.title2,),
                  Text('Too Hard', style: NunitoStyle.title2,),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}