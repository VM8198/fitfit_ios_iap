import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/homepage_provider.dart';
import 'package:flutter_fitfit/provider/pt_provider.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/pref.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class QuestionAnalyzePage extends StatefulWidget{
  static const routeName = '/question-analyze';

  @override
  _QuestionAnalyzePageState createState() => _QuestionAnalyzePageState();
}

class _QuestionAnalyzePageState extends State<QuestionAnalyzePage> {
  int _countdownTimer = 0;
  int _ms = 4000;

  @override
  void initState() {
		super.initState();
		_countdown();
	}

  Future<void> _countdown() async {
    final _queProvider = Provider.of<QuestionProvider>(context,listen: false);
    bool _submissionSuccess = await _queProvider.submitQuestions();

    Timer.periodic(new Duration(milliseconds: 40), (timer) {
      setState(() {
        _countdownTimer = timer.tick;
      });
      
      if(timer.tick == 100){
        timer.cancel();
        if(_submissionSuccess) {
          // Temporary redirect them to PT homepage
          // Nav.clearAllAndPush(QuestionCompletePage.routeName);
          Provider.of<PtProvider>(context,listen: false).updateIsPTQueCompleted(true);
          Pref.setQuesCompleted(true);
          Provider.of<HomePageProvider>(context,listen: false).changeNav(1);
          Nav.clearAllAndPush(HomePage.routeName);
          _queProvider.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ThemeColor.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'Analyzing your answers',
                    style: NunitoStyle.h3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 60.0),
                    child: Text(
                      'Generating your personalized training plan..',
                      style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 8.0,
                    percent: 1,
                    animation: true,
                    animationDuration: _ms,
                    animateFromLastPercent: true,
                    center: Image.asset(Utility.emojiPath + 'biceps.png', width: 40,height: 40,),
                    footer: Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        '$_countdownTimer%',
                        style: NunitoStyle.body2.copyWith(color: ThemeColor.primaryDark),
                      ),
                    ),
                    progressColor: ThemeColor.primaryDark,
                    backgroundColor: ThemeColor.black[08],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
