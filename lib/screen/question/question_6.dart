import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/screen/question/analyze.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/widget/text_field.dart';
import 'package:provider/provider.dart';

class Question6Page extends StatefulWidget {

  @override
  _Question6PageState createState() => _Question6PageState();
}

class _Question6PageState extends State<Question6Page> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dobController = new TextEditingController();

  final TextEditingController heightController = new TextEditingController();

  final TextEditingController weightController = new TextEditingController();

  final TextEditingController targetWeightController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      bottomNavigationBar: SafeArea(
        child: CtaButton(
          'Next',
          disabled: _shouldBtnDisabled(),
          onPressed: (_) => _onButtonClicked(),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
        ),
      ),
    );
  }

  Widget _description(){
    return Column(
      children: <Widget>[
        Text(
          'Complete your profile',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'We’ll help you track your progress and calories burned with these info',
            textAlign: TextAlign.center,
            style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
          ),
        ),
      ],
    );
  }

  Widget _content(){
    return _form();
  }

  Widget _form() {

    final _ageField = Consumer<QuestionProvider>(
      builder: (_,qp,__){
        return TextFieldWidget(
          placeholder: 'How old are you?',
          suffixItem: Icon(Icons.calendar_today,color: ThemeColor.black[56],),
          onTap: () => _showDobPicker(context),
          controller: TextEditingController(text: qp.dob)
        );
      },
    );

    final _heightField = TextFieldWidget(
      placeholder: 'What\'s your height?',
      suffixItem: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('cm',style: NunitoStyle.body2,),
      ),
      keyboardType: TextInputType.number,
      validator: (val) => val.length > 3 || val.length == 1 ? 'Please insert valid height.' : null,
      autovalidate: true,
      onValueChanged: (val) => _onValueChanged('height',val),
      controller: heightController
    );

    final _weightField = TextFieldWidget(
      placeholder: 'What\'s your weight?',
      suffixItem: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('kg',style: NunitoStyle.body2,),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (val) => val.length > 3 || val.length == 1 ? 'Please insert valid weight.' : null,
      autovalidate: true,
      onValueChanged: (val) => _onValueChanged('weight',val),
      controller: weightController
    );

    final _targetWeightField = TextFieldWidget(
      placeholder: 'What\'s your target weight?',
      suffixItem: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('kg',style: NunitoStyle.body2,),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (val) => val.length > 3 || val.length == 1 && val.length != 0 ? 'Please insert valid weight.' : null,
      autovalidate: true,
      onValueChanged: (val) => _onValueChanged('targetWeight',val),
      controller: targetWeightController
    );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: _ageField,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: _heightField,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: _weightField,
            ),
            // Padding(
            //   padding: EdgeInsets.only(bottom: 12.0),
            //   child: _targetWeightField,
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 16.0),
            //   child: Text(
            //     'This field is optional',
            //     textAlign: TextAlign.left,
            //     style: NunitoStyle.body2.copyWith(color: ThemeColor.black[24]),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _showDobPicker(context) async{
    await showCupertinoModalPopup(
      context: context, 
      builder: (context){
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Stack(
            children: <Widget>[
              CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                onDateTimeChanged: (dateTime) {
                  DateFormat _df = DateFormat('dd-MM-yyyy');
                  String _formattedDate = _df.format(dateTime);
                  _onValueChanged('dob',_formattedDate);
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: FlatButton(
                  child: Text('Done', style: TextStyle(color: Colors.blue),),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _onValueChanged(field,val) {
    final _queProvider = Provider.of<QuestionProvider>(context, listen: false);

    if(field == 'dob'){
      _queProvider.dob = val;
    }
    else if(field == 'height'){
      _queProvider.height = heightController.text != '' ? int.parse(heightController.text) : null;
    }
    else if(field == 'weight'){
      _queProvider.weight = weightController.text != '' ? int.parse(weightController.text) : null;
    }
    else if(field == 'targetWeight'){
      _queProvider.targetWeight = targetWeightController.text != '' ? int.parse(targetWeightController.text) : null;
    }
  }

  bool _shouldBtnDisabled(){
    final qp = Provider.of<QuestionProvider>(context);

    return (qp.dob == null || qp.height == null || qp.weight == null || qp.weight == '') ? true : false;
  }

  void _onButtonClicked(){
    bool _validated = _formKey.currentState.validate();
    if(_validated) Nav.navigateTo(QuestionAnalyzePage.routeName);
  }
}