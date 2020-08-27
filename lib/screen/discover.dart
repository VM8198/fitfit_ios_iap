import 'dart:io' show Platform;

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/provider/cw_provider.dart';
import 'package:flutter_fitfit/screen/forgot_password.dart';
import 'package:flutter_fitfit/screen/workout_group.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/custom_loading.dart';
import 'package:flutter_fitfit/widget/exercise_list.dart';
import 'package:flutter_fitfit/widget/exercise_slider.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class DiscoverPage extends StatefulWidget{
  static const routeName = '/discover';

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    Utility.sendAnalyticsEvent(AnalyticsEventType.discover_cw);
    super.initState();
    // checkVersionUpdate();
    // _initList();
  }

  _initList() async{
    CwProvider provider = Provider.of<CwProvider>(context, listen:false);
    await provider.getList();
    return provider;
  }

  Future<String> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();

    return remoteConfig?.getString('dev_version');
  }

  void checkVersionUpdate() async {
    String appVersion = await setupRemoteConfig();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    if(appVersion != version){
      _showUpdateAppDialog();
    }
  }

  Future<void> _showUpdateAppDialog() async {
    String _launchUrl = Platform.isIOS ? 'https://itunes.apple.com' : '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Version Available',style: NunitoStyle.title,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Update to the latest version to continue using FitFit & enjoy all new features.',style: NunitoStyle.body1,),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Update Now',style: NunitoStyle.button1,),
              onPressed: () {
                _launchURL(_launchUrl);
              },
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: FutureBuilder(
            future: _initList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CustomLoading(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Icon(Icons.warning),
                );
              }

              CwProvider provider = snapshot.data;

              return ListView(
                children: <Widget>[
                  provider.getSectionName(0) != null ? GridCategorySection(
                    provider.getSectionName(0),
                    provider.getSectionList(0),
                  ) : SizedBox(),
                  provider.getSectionName(1) != null ? HorizontalCategorySection(
                    provider.getSectionName(1),
                    provider.getSectionList(1),
                  ) : SizedBox(),
                  provider.getSectionName(2) != null ? VerticalCategorySection(
                    provider.getSectionName(2),
                    provider.getSectionList(2),
                  ) : SizedBox()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class GridCategorySection extends StatelessWidget{
  final String title;
  final List<ExerciseSliderModel> list;

  GridCategorySection(this.title,this.list);

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: <Widget>[
    //     Padding(
    //       padding: EdgeInsets.fromLTRB(16.0,16.0,16.0,8.0),
    //       child: CategoryHeader(
    //         // title: '$title',
    //         title: 'Our Picks',
    //         actionText: 'View All',
    //         actionNavRoute: ForgotPasswordPage.routeName,
    //       ),
    //     ),
    //     ExerciseSlider(
    //       imgList: list,
    //       withCaption: true,
    //       onImageTap: ({index}){
    //         Nav.navigateTo(WorkoutGroupPage.routeName, args: list[index]);
    //       },
    //     ),
    //   ],
    // );
    return Container(
      height: 280,
      padding: EdgeInsets.only(top: 16),
      child: _buildPageCarousel(context, list),
    );
  }

  Widget _buildPageCarousel(BuildContext context, List<ExerciseSliderModel> list) {
    final int numItemsPerPage = 3;
    int pages = (list.length/numItemsPerPage).ceil();
    
    // split into chunk
    List<List<ExerciseSliderModel>> chunk = [];

    for(int i = 0; i < pages; i++) {
      chunk.add([...list.skip( i * numItemsPerPage).take(numItemsPerPage)]);
    }

    // Calculate the real fraction, sorry for my OCD
    // 32 is Padding(16)*2
    final width = MediaQuery.of(context).size.width;
    double fraction = (width - 32) / width;

    return PageView.builder(
      controller: PageController(viewportFraction: fraction),
      itemBuilder: (BuildContext context, int position) {
        return _buildPageCarouselItem(context, position, chunk[position]);
      },
      itemCount: pages,
    );
  }

  Widget _buildPageCarouselItem(BuildContext context, int position, List<ExerciseSliderModel> list) {
    return VerticalCategorySection('', list);
  }
}

class HorizontalCategorySection extends StatelessWidget{
  final String title;
  final List<ExerciseSliderModel> list;

  HorizontalCategorySection(this.title,this.list);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.0,24.0,16.0,16.0),
          child: CategoryHeader(
            title: '$title',
            actionText: 'View All',
            actionNavRoute: ForgotPasswordPage.routeName,
          ),
        ),
        ExerciseSlider(
          imgList: list,
          withCaption: true,
          onImageTap: ({index}){
            Nav.navigateTo(WorkoutGroupPage.routeName, args: list[index]);
          },
        ),
      ],
    );
  }
}

class VerticalCategorySection extends StatelessWidget{
  final String title;
  final List list;

  VerticalCategorySection(this.title,this.list);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        title != '' ? Padding(
          padding: EdgeInsets.fromLTRB(16.0,24.0,16.0,16.0),
          child: CategoryHeader(
            title: '$title'
          ),
        ) : SizedBox(),
        ExerciseList(
          imgList: list,
          withCaption: true,
          withFavIcon: false,
          withLrPadding: true,
          tapSplash: false,
          onImageTap: (param){
            int index = param['index'];
            Nav.navigateTo(WorkoutGroupPage.routeName, args: list[index]);
          }
        )
      ],
    );
  }

}

class CategoryHeader extends StatelessWidget{
  final String title;
  final String actionText;
  final String actionNavRoute;

  CategoryHeader({this.title,this.actionText,this.actionNavRoute});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: title != 'General',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: NunitoStyle.h4,
          ),
          // FlatButton(
          //   child: Text(
          //     '$actionText',
          //     style: NunitoStyle.body2.copyWith(
          //       color: ThemeColor.secondaryDark,
          //     ),
          //   ),
          //   onPressed: () => Nav.navigateTo(actionNavRoute),
          // ),
        ],
      ),
    );
  }
}