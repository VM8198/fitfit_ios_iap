import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/provider/homepage_provider.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:provider/provider.dart';

class QuestionCompletePage extends StatelessWidget{
  static const routeName = '/question-complete';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      bottomNavigationBar: _button(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _topBar(context),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Your Personalized Training Plan Is Ready!',
                      textAlign: TextAlign.center,
                      style: NunitoStyle.h3,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                      child: Text(
                        'You’ll start with Beginner 1.0',
                        style: NunitoStyle.body1.copyWith(color: ThemeColor.black[56]),
                      ),
                    ),
                    DecoratedBox(
                      child: Image.asset(Utility.imagePath + 'question_complete.png', height: 150.0,), 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 10.0,
                            spreadRadius: 0,
                            offset: Offset(4.0,10.0)
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(50.0,24.0,50.0,24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                '5 Workouts',
                                style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Text(
                                  'PER WEEK',
                                  style: NunitoStyle.caption1.copyWith(color: ThemeColor.black[80]),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Avg 30 Mins',
                                style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Text(
                                  'PER WORKOUT',
                                  style: NunitoStyle.caption1.copyWith(color: ThemeColor.black[80]),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(context){
    final homeProvider = Provider.of<HomePageProvider>(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => {
            Nav.clearAllAndPush(HomePage.routeName),
            homeProvider.changeNav(1)
          },
        ),
      ],
    );
  }

  Widget _button(){
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: CtaButton(
          'Choose your plan',
        ),
      ),
    );
  }

}