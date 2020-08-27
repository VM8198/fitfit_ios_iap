import 'package:flutter/material.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/snackbar_ff.dart';
import 'package:provider/provider.dart';

class UpdateQuestionPage extends StatefulWidget {
  static const routeName = '/update-question';
  final Map argument;

  UpdateQuestionPage({this.argument});

  @override
  _UpdateQuestionPageState createState() => _UpdateQuestionPageState();
}

class _UpdateQuestionPageState extends State<UpdateQuestionPage> {
  String submitFrom;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final _queProvider = Provider.of<QuestionProvider>(context, listen: false);

      _queProvider.goToParticularQue(widget.argument['question']);

      // set submit from
      submitFrom = widget.argument['submitFrom'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _button(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: _topBar(context),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _content(),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _topBar(context){
    return Row(
      children: <Widget>[
        _backButton(context),
      ],
    );
  }

  Widget _backButton(context){
    return Consumer<QuestionProvider>(
      builder: (_, qp, __){
        return IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CtaButton(
              'Update',
              disabled: _shouldBtnDisabled(qp),
              onPressed: (_) async{
                bool _success = await qp.submitQuestions(submitFrom: submitFrom);
                Navigator.of(context).pop();
                if(_success){
                  FlushbarFF.showFlushBar('Training plan updated!', type: SnackBarFFType.success).show(context);
                }
                else{
                  FlushbarFF.showFlushBar('Something went wrong, please try again.', type: SnackBarFFType.error).show(context);
                }
              },
            )
          )
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
