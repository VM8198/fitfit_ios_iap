import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatelessWidget {
  static const routeName = '/question';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _button(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _topBar(context),
              Expanded(
                child: _content(),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _topBar(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _backButton(context),
        _progressBar(),
        _queCounter()
      ],
    );
  }

  Widget _backButton(context){
    return Consumer<QuestionProvider>(
      builder: (_, qp, __){
        return IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => qp.currentQue == 1 ? Navigator.of(context).pop() : qp.goToPrevQue(),
        );
      },
    );
  }

  Widget _progressBar(){
    return Consumer<QuestionProvider>(
      builder: (_, qp, __){
        return LinearPercentIndicator(
          width: 64.0,
          lineHeight: 10.0,
          percent: qp.currentQue / qp.totalQuestion,
          backgroundColor: ThemeColor.black[08],
          progressColor: ThemeColor.secondaryDark,
        );
      },
    );
  }

  Widget _queCounter(){
    return Consumer<QuestionProvider>(
      builder: (_, qp, __){
        return Text(
          '${qp.currentQue}/${qp.totalQuestion}',
          style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
        );
      },
    );
  }

  Widget _content(){
    return Consumer<QuestionProvider>(
      builder: (_, qp, __){
        return qp.currentQuePage;
      },
    );
  }

  Widget _button(){
    return Consumer<QuestionProvider>(
      builder: (context, qp, child){
        return Visibility(
          visible: qp.currentQue != 6,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CtaButton(
                'Next',
                disabled: _shouldBtnDisabled(qp),
                onPressed: (_) => qp.goToNextQue(),
              )
            )
          ),
        );
      }
    );
  }

  _shouldBtnDisabled(QuestionProvider qp){
    switch (qp.currentQue) {
      case 1:
        return qp.gender == null ? true : false;
        break;
      case 2:
        return qp.goal == null ? true : false;
        break;
      case 3:
        return qp.problemAreas != null && qp.problemAreas.length >= 3 ? false : true;
        break;
      case 4:
        return qp.fitnessLevel == null ? true : false;
        break;
      case 5:
        return qp.equipment == null ? true : false;
        break;
      case 6:
        return (qp.dob == null || qp.height == null || qp.weight == null || qp.weight == '') ? true : false;
        break;
      default:
        return true;
    }
  }
}
