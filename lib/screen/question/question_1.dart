import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/circle_button.dart';
import 'package:provider/provider.dart';

class Question1Page extends StatefulWidget {
  @override
  _Question1PageState createState() => _Question1PageState();
}

class _Question1PageState extends State<Question1Page> {
  List<Map> _displayValues = [
    {
      'value': 'male',
      'emoji': 'man.png',
      'desc': 'Male',
    },
    {
      'value': 'female',
      'emoji': 'woman.png',
      'desc': 'Female',
    },
  ];

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
          child: _content(),
        ),
      ],
    );
  }

  Widget _description(){
    return Column(
      children: <Widget>[
        Text(
          'What’s your gender?',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Tell us more about yourself to get a personalized training plan',
            textAlign: TextAlign.center,
            style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
          ),
        ),
      ],
    );
  }
  
  Widget _content() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _generateItems(_displayValues),
    );
  }

  List<Widget> _generateItems(items){
    final _queProvider = Provider.of<QuestionProvider>(context);
    
    return items.map<Widget>((item) {
      return Column(
        children: <Widget>[
          Selector<QuestionProvider, String>(
            selector: (_, provider) => provider.gender,
            builder: (_,gender,__){
              bool _isSelected = gender == item['value'];
              return CircleButton(
                onTap: () => _queProvider.gender = item['value'], 
                image: Image.asset(Utility.emojiPath + "${_isSelected ? 'selected-' : ''}${item['emoji']}"),
                selected: _isSelected
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${item['desc']}',
                  style: NunitoStyle.body1.copyWith(
                    color: _queProvider.gender == item['value'] ? ThemeColor.primaryDark : ThemeColor.black[56]
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}