import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/slider.dart';
import 'package:provider/provider.dart';

class Question4Page extends StatelessWidget{
  final Map _displayValues = {
    1: {
      'emoji': 'fitness-1.png',
      'desc': 'Newbie that never work out before',
    },
    2: {
      'emoji': 'fitness-2.png',
      'desc': 'Work out irregularly & know some basic exercises',
    },
    3: {
      'emoji': 'fitness-3.png',
      'desc': 'Work out regularly on low frequency (Average 2-3 times a week)',
    },
    4: {
      'emoji': 'fitness-4.png',
      'desc': 'Work out regularly on high frequency (Average 4-5 times a week)',
    },
    5: {
      'emoji': 'fitness-5.png',
      'desc': 'Experienced fitness enthusiast & know the correct form for most exercises',
    }
  };

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

  Widget _description(){
    return Column(
      children: <Widget>[
        Text(
          'What’s your fitness level?',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'To get a training plan matches you the best',
            textAlign: TextAlign.center,
            style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
          ),
        ),
      ],
    );
  }

  Widget _content(context){
    return Consumer<QuestionProvider>(
      builder: (_,qp,__){
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: Image.asset(
                  Utility.emojiPath + "${_displayValues[qp.fitnessLevel]['emoji']}",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            _slider(context),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: Text(
                  '${_displayValues[qp.fitnessLevel]['desc']}',
                  textAlign: TextAlign.center,
                  style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _slider(context){
    return Consumer<QuestionProvider>(
      builder: (_,qp,__){
        return FlutterSlider(
          values: [qp.fitnessLevel.toDouble()],
          min: 1.0,
          max: 5.0,
          jump: true,
          step: 1.0,
          tooltip: FlutterSliderTooltip(disabled: true),
          handler: FlutterSliderHandler(
            child: Text(''),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 10.0,
                  spreadRadius: 0,
                  offset: Offset(4.0,10.0)
                )
              ],
              borderRadius: BorderRadius.circular(50.0)
            )
          ),
          handlerAnimation: FlutterSliderHandlerAnimation(
            scale: 1.0,
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 8,
            inactiveTrackBarHeight: 8,
            activeTrackBar: BoxDecoration(
              color: ThemeColor.primaryDark,
              borderRadius: BorderRadius.circular(50.0),
            ),
            inactiveTrackBar: BoxDecoration(
              color: ThemeColor.black[08],
              borderRadius: BorderRadius.circular(50.0),
            )
          ),
          onDragCompleted: (handlerIndex, lowerValue, upperValue) {
            final _queProvider = Provider.of<QuestionProvider>(context,listen: false);

            _queProvider.fitnessLevel = lowerValue.toInt();
          },
        );
      },
    );
  }
}