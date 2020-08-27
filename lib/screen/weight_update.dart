import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/text_field.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';

class WeightUpdatePage extends StatefulWidget {
  final Function onValueChanged;
  static const routeName = '/weight-update';

  WeightUpdatePage({this.onValueChanged});

  @override
  _WeightUpdatePageState createState() => _WeightUpdatePageState();
}

class _WeightUpdatePageState extends State<WeightUpdatePage> {

  final _formKey = GlobalKey<FormState>();
  String _date;
  String _weight;

  TextEditingController dateController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();

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
              _topBar(),
              Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: _description(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 48.0),
                child: _content(context),
              ),
            ],
          )
        )
      )
    );
  }

  Widget _description(){
    return Column(
      children: <Widget>[
        Text(
          'Update your weight',
          textAlign: TextAlign.center,
          style: NunitoStyle.h3,
        )
      ],
    );
  }

  Widget _content(context){
    return _form(context);
  }

  Widget _form(context) {

    final _dateField = TextFieldWidget(
      placeholder: '01-Jan',
      suffixItem: Icon(Icons.calendar_today,color: ThemeColor.black[56],),
      onTap: () => _showDatePicker(context),
      controller: TextEditingController(text: _date)
    );

    final _weightField = TextFieldWidget(
      placeholder: '55.5',
      suffixItem: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('kg',style: NunitoStyle.body2,),
      ),
      keyboardType: TextInputType.number,
      onValueChanged: (val) {_onValueChanged('weight',val);},
      controller: weightController
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: _dateField,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: _weightField,
          ),
        ],
      ),
    );
  }

  Widget _button(){
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: CtaButton(
          'Update',
          onPressed: (context) {},
        ),
      ),
    );
  }

  Widget _topBar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  void _showDatePicker(context) async{
    DateTime _date = await showDatePicker(
      context: context, 
      initialDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(DateTime.now().year - 60, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime.now(),
    );

    if(_date != null) _onValueChanged('date','${_date.day}-${_date.month}-${_date.year}');
  }

  void _onValueChanged(field,val) {

    if(field == 'date'){
      setState(() {
        _date = val;
      });
    }
    else if(field == 'weight'){
      setState(() {
        _weight = '${weightController.text}';
      });
    }

    if(_date != null && _date != ''
      && _weight != null && _weight != ''
    ){
      Map _value = {
        'dob': _date,
        'weight': int.parse(_weight),
      };

      widget.onValueChanged(_value);
    }
    else{
      widget.onValueChanged(null);
    }
  }
}