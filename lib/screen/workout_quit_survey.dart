import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/select_card.dart';

class WorkoutQuitSurveyPage extends StatefulWidget{
  static const routeName = '/workout-quit-survey';

  @override
  _WorkoutQuitSurveyPageState createState() => _WorkoutQuitSurveyPageState();
}

class _WorkoutQuitSurveyPageState extends State<WorkoutQuitSurveyPage> {
  String _selectedItem = '';
  List<Map> _displayValues = [
    {
      'value': 'too-easy',
      'desc': 'Too Easy',
    },
    {
      'value': 'too-hard',
      'desc': 'Too Hard',
    },
    {
      'value': 'didnt-like-the-workout',
      'desc': 'Didn’t like the workout',
    },
    {
      'value': 'just-exploring-the-app',
      'desc': 'Just exploring the app',
    },
    {
      'value': 'others',
      'desc': 'Others',
    },
  ];
  
  void _updateItem(String val){
    setState(() {
      _selectedItem = val;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: Text(
                      'Skip',
                      style: NunitoStyle.button2.copyWith(color: ThemeColor.black[80]),
                    ),
                    onPressed: (){},
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 48.0,left: 16.0, right: 16.0),
                child: _description(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 48.0,left: 16.0, right: 16.0),
                child: _content(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _description(){
    return Column(
      children: <Widget>[
        Text(
          'Tell us why you weren’t able to complete the workout',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Your progress for this workout will not be saved',
            textAlign: TextAlign.center,
            style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
          ),
        ),
      ],
    );
  }

  Widget _content(){
    return Column(
      children: _generateItems(_displayValues),
    );
  }

  List<Widget> _generateItems(items){
    return items.map<Widget>((item) {
      return SelectCardWidget(
        marginBottom: 16.0,
        content: Text(
          '${item['desc']}',
          style: NunitoStyle.body1.copyWith(
            color: _selectedItem == item['value'] ? ThemeColor.primaryDark : ThemeColor.black[100]
          ),
        ),
        onTap: () => _updateItem(item['value']), 
        selected: _selectedItem == item['value']
      );
    }).toList();
  }
}