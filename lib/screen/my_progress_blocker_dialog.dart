import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/slider.dart';

class MyProgressBlockerDialog extends StatefulWidget {
  final Function onValueChanged;

  MyProgressBlockerDialog({this.onValueChanged});

  @override
  _MyProgressBlockerDialogState createState() => _MyProgressBlockerDialogState();
}

class _MyProgressBlockerDialogState extends State<MyProgressBlockerDialog>{
  double _sliderValue = 1.0;
  Map _displayValues = {
      1: {
        'emoji': 'fitness-1.png',
        'desc': 'Beginner 1.0',
      },
      2: {
        'emoji': 'fitness-1.png',
        'desc': 'Beginner 1.1',
      },
      3: {
        'emoji': 'fitness-1.png',
        'desc': 'Beginner 1.2',
      },
      4: {
        'emoji': 'fitness-1.png',
        'desc': 'Beginner 1.3',
      },
      5: {
        'emoji': 'fitness-2.png',
        'desc': 'Apprentice 2.0',
      },
      6: {
        'emoji': 'fitness-2.png',
        'desc': 'Apprentice 2.1',
      },
      7: {
        'emoji': 'fitness-2.png',
        'desc': 'Apprentice 2.2',
      },
      8: {
        'emoji': 'fitness-2.png',
        'desc': 'Apprentice 2.3',
      },
      9: {
        'emoji': 'fitness-2.png',
        'desc': 'Apprentice 2.4',
      },
      10: {
        'emoji': 'fitness-2.png',
        'desc': 'Apprentice 2.5',
      },
      11: {
        'emoji': 'fitness-3.png',
        'desc': 'Intermedia 3.0',
      },
      12: {
        'emoji': 'fitness-3.png',
        'desc': 'Intermedia 3.1',
      },
      13: {
        'emoji': 'fitness-3.png',
        'desc': 'Intermedia 3.2',
      },
      14: {
        'emoji': 'fitness-3.png',
        'desc': 'Intermedia 3.3',
      },
      15: {
        'emoji': 'fitness-3.png',
        'desc': 'Intermedia 3.4',
      },
      16: {
        'emoji': 'fitness-3.png',
        'desc': 'Intermedia 3.5',
      },
      17: {
        'emoji': 'fitness-4.png',
        'desc': 'Advanced 4.0',
      },
      18: {
        'emoji': 'fitness-4.png',
        'desc': 'Advanced 4.1',
      },
      19: {
        'emoji': 'fitness-4.png',
        'desc': 'Advanced 4.2',
      },
      20: {
        'emoji': 'fitness-4.png',
        'desc': 'Advanced 4.3',
      },
      21: {
        'emoji': 'fitness-4.png',
        'desc': 'Advanced 4.4',
      },
      22: {
        'emoji': 'fitness-4.png',
        'desc': 'Advanced 4.5',
      },
      23: {
        'emoji': 'fitness-5.png',
        'desc': 'Guru 5.0',
      },
      24: {
        'emoji': 'fitness-5.png',
        'desc': 'Guru 5.1',
      },
      25: {
        'emoji': 'fitness-5.png',
        'desc': 'Guru 5.2',
      },
      26: {
        'emoji': 'fitness-5.png',
        'desc': 'Guru 5.3',
      },
      27: {
        'emoji': 'fitness-5.png',
        'desc': 'Guru 5.4',
      },
      28: {
        'emoji': 'fitness-5.png',
        'desc': 'Guru 5.5',
      }
    };

  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    int _selectedId = _sliderValue.toInt();
    
    return Dialog(
      child: Container(
        width: size.width * 0.8,
        padding: EdgeInsets.all(20.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              'Change Level',
              style: NunitoStyle.title.copyWith(color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: Image.asset(
                  Utility.emojiPath + "${_displayValues[_selectedId]['emoji']}",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Text(
              '${_displayValues[_selectedId]['desc']}',
              style: NunitoStyle.body2.copyWith(color: Colors.black),
            ),
            _slider(context),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: NunitoStyle.button2.copyWith(color: ThemeColor.black[56]),
                    ),
                  ),
                  CtaButton(
                    'Update',
                    onPressed: (context) {},
                  )
                ]
            )
          ],
        ),
      ),
    );
  
    
  }
  
  Widget _slider(context){
    return FlutterSlider(
      values: [_sliderValue],
      min: 1.0,
      max: 28.0,
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
      onDragging: (handlerIndex, lowerValue, upperValue) {
        setState(() {
          _sliderValue = lowerValue;
        });
        widget.onValueChanged({'fitness_level': lowerValue});
      },
    );
  }

}