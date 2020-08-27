import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/fitfit_icon.dart';
import 'package:flutter_fitfit/model/nav_button_model.dart';
import 'package:flutter_fitfit/screen/discover.dart';
import 'package:flutter_fitfit/screen/personalized_training.dart';
import 'package:flutter_fitfit/screen/profile/profile.dart';

class HomePageProvider extends ChangeNotifier {

  HomePageProvider();

  int _navIndex = 0;
  List<NavButtonModel> _navBtn = [
    NavButtonModel(
      isActive: true,
      content: DiscoverPage(),
      icon: FitFitIcon.discover
    ),
    NavButtonModel(
      content: PersonalizedTrainingPage(),
      icon: FitFitIcon.dumbbell
    ),
    // NavButtonModel(
    //   content: MyProgressPage(),
    //   icon: FitFitIcon.graph
    // ),
    NavButtonModel(
      content: ProfilePage(),
      icon: Icons.settings
    ),
  ];

  int get navIndex => _navIndex;
  List<NavButtonModel> get navBtn => _navBtn;
  get currentPage => _navBtn[_navIndex].content;

  void changeNav(int index){
    if(_navIndex != index){
      _navIndex = index;
      for(int i=0; i<navBtn.length; i++){
        NavButtonModel n = navBtn[i];
        _navIndex == i ? n.isActive = true : n.isActive = false;
      }
      notifyListeners();
    }
  }

  clear() {
    _resetPageIndex();
  }

  _resetPageIndex(){
    _navIndex = 0;
  }

}