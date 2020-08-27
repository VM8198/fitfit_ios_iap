import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/workout_intermediate.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/select_card.dart';
import 'package:provider/provider.dart';

class WarmupPage extends StatefulWidget{
  static const routeName = '/warmup';

  @override
  _WarmupPageState createState() => _WarmupPageState();
}

class _WarmupPageState extends State<WarmupPage> {
  List<Map> _displayValues = [
    {
      'value': WarmUpType.stretch,
      'desc_title': 'Mobility/Stretching',
      'desc_paragraph': 'Activate your muscles and get ready for the workout',
    },
    {
      'value': WarmUpType.cardio,
      'desc_title': 'Cardio • 5 mins',
      'desc_paragraph': 'Increase your heart rate by doing your own choice of cardio',
    },
  ];

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Utility.sendAnalyticsEvent(AnalyticsEventType.cw_warmup);
    });
  }

  @override
  Widget build(BuildContext context) {
  
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: ThemeColor.background,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _button(arguments),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0),
              child: _description(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0),
              child: _content(),
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
          'Choose your warm up option',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'It is highly recommended to warm up before your workout',
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
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);
    
    return items.map<Widget>((item) {
      return SelectCardWidget(
        marginBottom: 16.0,
        suffixCheckbox: true,
        leftAlign: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '${item['desc_title']}',
              style: NunitoStyle.title,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, right: 8.0),
              child: Text(
                '${item['desc_paragraph']}',
                textAlign: TextAlign.left,
                style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
              ),
            ),
          ],
        ),
        onTap: () => _workoutProvider.updateWarmUpSelection(item['value']),
        onCheckboxChanged: (_) => _workoutProvider.updateWarmUpSelection(item['value']),
        checkboxSelected: _workoutProvider.warmUpSelection.contains(item['value']),
      );
    }).toList();
  }

  Widget _button(Map args){

    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            CtaButton(
              'Start Warm Up',
              disabled: _workoutProvider.warmUpSelection.length == 0,
              onPressed: (_) {
                Utility.sendAnalyticsEvent(AnalyticsEventType.cw_warmup_start);
                _workoutProvider.startWorkout(args['workoutModel']);
                Nav.navigateTo(WorkoutIntermediatePage.routeName, args: {'isBeginning': true});
              },
            ),
            FlatButton(
              child: Text(
                'Skip Warm Up',
                style: NunitoStyle.body1.copyWith(
                  color: ThemeColor.black[80],
                  decoration: TextDecoration.underline
                ),
              ),
              onPressed: () {
                Utility.sendAnalyticsEvent(AnalyticsEventType.cw_warmup_skip);
                _workoutProvider.resetWarmUpSelection();
                _workoutProvider.startWorkout(args['workoutModel']);
                Nav.navigateTo(WorkoutIntermediatePage.routeName, args: {'isBeginning': true});
              },
            ),
          ],
        ),
      ),
    );
  }
}