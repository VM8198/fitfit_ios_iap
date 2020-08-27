import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/utility/question_util.dart';
import 'package:provider/provider.dart';

class Question3Page extends StatefulWidget {
  final Function onValueChanged;

  Question3Page({this.onValueChanged});

  @override
  _Question3PageState createState() => _Question3PageState();
}

class _Question3PageState extends State<Question3Page> {
  final List<Map> _displayValues = QuestionUtil.problemAreasValues;

  void _selectItem(String field,bool isChecked, QuestionProvider qp){
    List _newItems = [];
    List _exisitingItems = qp.problemAreas != null ? qp.problemAreas : [];

    if(isChecked == true){
      _newItems = [..._exisitingItems,field];
    }
    else{
      if(_exisitingItems.indexOf(field) != -1){
        _exisitingItems.remove(field);
        _newItems = _exisitingItems;
      }
    }

    qp.problemAreas = _newItems.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
      ),
    );
  }

  Widget _description(){
    return Column(
      children: <Widget>[
        Text(
          'Tell us your problem area(s)',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Which body part(s) would you like to enhance the physique?',
            textAlign: TextAlign.center,
            style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
          ),
        ),
      ],
    );
  }
  
  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _generateItems(_displayValues),
    );
  }

  List<Widget> _generateItems(items){
    final _queProvider = Provider.of<QuestionProvider>(context);
    
    return items.map<Widget>((item) {
      return CheckboxListTile(
        activeColor: ThemeColor.primary,
        title: Text('${item['desc']}', style: NunitoStyle.body1,),
        onChanged: (val) => _selectItem('${item['value']}',val,_queProvider),
        value: _queProvider.problemAreas != null && _queProvider.problemAreas.indexOf(item['value']) != -1,
      );
    }).toList();
  }
}