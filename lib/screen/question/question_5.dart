import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/utility/question_util.dart';
import 'package:flutter_fitfit/widget/select_card.dart';
import 'package:provider/provider.dart';

class Question5Page extends StatelessWidget {
  final List<Map> _displayValues = QuestionUtil.equipmentValues;

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
          'How would you like to train?',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
      ],
    );
  }

  Widget _content(BuildContext context){
    return Column(
      children: _generateItems(_displayValues,context),
    );
  }

  List<Widget> _generateItems(items,BuildContext context){
    final _queProvider = Provider.of<QuestionProvider>(context);
    
    return items.map<Widget>((item) {
      return SelectCardWidget(
        marginBottom: 16.0,
        content: Column(
          children: <Widget>[
            Text(
              '${item['desc']}',
              style: NunitoStyle.title,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                '${item['desc_paragraph']}',
                textAlign: TextAlign.center,
                style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
              ),
            ),
          ],
        ),
        onTap: () => _queProvider.equipment = item['value'],
        selected: _queProvider.equipment == item['value']
      );
    }).toList();
  }
}