import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/text_field.dart';

class FavoriteDialog extends StatelessWidget{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Dialog(
      child: Container(
        width: size.width * 0.8,
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: <Widget>[
              Text(
                'Name your workout',
                style: NunitoStyle.title.copyWith(color: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0, bottom: 32.0),
                child: TextFieldWidget(
                  placeholder: 'Workout 1',
                  // validator: (val) => val.length == 0 ? 'Please type a name${val.length}' : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: NunitoStyle.button2.copyWith(color: ThemeColor.black[56]),
                    ),
                  ),
                  CtaButton(
                    'Save',
                    onPressed: (context) {
                      bool isValidated = _formKey.currentState.validate();
                      if(isValidated){
                        Navigator.of(context).pop();
                        Flushbar(
                          messageText: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: ThemeColor.favoriteRed,
                                ),
                              ),
                              Text(
                                'Successfully added to favourite!',
                                style: NunitoStyle.body2,
                              )
                            ],
                          ),
                          backgroundColor: Colors.white,
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: Duration(seconds: 3),
                          animationDuration: Duration(milliseconds: 500),
                        ).show(context);
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  
}