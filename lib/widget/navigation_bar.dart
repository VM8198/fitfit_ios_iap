import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/nav_button_model.dart';
import 'package:flutter_fitfit/provider/homepage_provider.dart';
import 'package:flutter_fitfit/screen/question.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/pref.dart';
import 'package:provider/provider.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: ThemeColor.white,
          border: Border(
            top: BorderSide(
              color: ThemeColor.black[08],
              width: 1
            )
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              homeProvider.navBtn.length,
              (index){
                return Selector<HomePageProvider, List<NavButtonModel>>(
                  selector: (_, hp) => hp.navBtn,
                  builder: (_, data, child){
                    Color _getColor(int idx){
                      return idx == homeProvider.navIndex ? ThemeColor.primary : ThemeColor.black[56];
                    }
                    return MaterialButton(
                      onPressed: () async{
                        bool isQueCompleted = await Pref.getQuesCompleted();
                        // (index == 1 && (isQueCompleted == null || !isQueCompleted)) ? Nav.navigateTo(QuestionPage.routeName) : homeProvider.changeNav(index);
                        homeProvider.changeNav(index);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            data[index].icon,
                            color: _getColor(index),
                            size: 24
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
          ),
        ),
      ),
    );
  }
}
