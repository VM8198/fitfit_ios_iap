import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/profile_model.dart';
import 'package:flutter_fitfit/model/question_model.dart';
import 'package:flutter_fitfit/provider/profile_provider.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/screen/profile/settings.dart';
import 'package:flutter_fitfit/screen/question/update_question.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/question_util.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/custom_loading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget{
  static const routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _initData() async{
    final _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final _queProvider = Provider.of<QuestionProvider>(context, listen: false);
    ProfileModel profileModel = await _profileProvider.getMyProfile();

    // initial set
    _queProvider.setInitalQuestionData(profileModel.questionModel);

    return profileModel;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _initData(),
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

            ProfileModel _profileModel = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _topBar(),
                  _avatarSection(profile: _profileModel),
                  _infoSection(size,profile: _profileModel),
                  _fitnessSettingSection(size,profile: _profileModel)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topBar(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Center(child: Text('Profile', style: NunitoStyle.h4,)),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Nav.navigateTo(SettingsPage.routeName),
            ),
          )
        ],
      ),
    );
  }

  Widget _avatarSection({ProfileModel profile}){
    return Wrap(
      spacing: 8,
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: ThemeColor.secondary,
          radius: 32.0,
          child: Text(
            (profile?.name != null) ? profile.name[0] : '-',
            style: NunitoStyle.h1.copyWith(color: ThemeColor.white),
          ),
        ),
        Text(
          profile?.name ?? '-',
          style: NunitoStyle.title.copyWith(color: ThemeColor.black[80]),
        )
      ],
    );
  }

  Widget _infoSection(Size size,{ProfileModel profile}){
    // 2 is divider width
    double _width = (size.width - 2) / 3;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          Container(
            width: _width,
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Icon(Icons.person_outline,size: 18,),
                  Text(Utility.capitalize(profile?.questionModel?.gender ?? '-'), style: NunitoStyle.title2.copyWith(color: ThemeColor.black[80]),)
                ],
              ),
            ),
          ),
          Container(height: 16, width: 1, child: VerticalDivider(color: ThemeColor.black[24])),
          Container(
            width: _width,
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(Utility.iconPath+'icon_height.svg',width: 18,),
                  Text(profile?.heightInCm ?? '-', style: NunitoStyle.title2.copyWith(color: ThemeColor.black[80]),)
                ],
              ),
            ),
          ),
          Container(height: 16, width: 1, child: VerticalDivider(color: ThemeColor.black[24])),
          Container(
            width: _width,
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(Utility.iconPath+'icon_cake.svg',width: 18,),
                  Text(profile?.formattedDob ?? '-', style: NunitoStyle.title2.copyWith(color: ThemeColor.black[80]),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _fitnessSettingSection(Size size,{ProfileModel profile}){
    QuestionModel _question = profile?.questionModel;
    
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Fitness Setting', style: NunitoStyle.h4,),
          ),
          _list(
            'Goal',
            QuestionUtil.mapValueToDesc(_question?.goal,QuestionUtil.goalValues) ?? '-',
            _question?.goal != null ? 2 : null,
            'goal'
          ),
          _list(
            'Problem Area',
            QuestionUtil.mapValueArrayToDesc(_question?.problemAreas ?? [], QuestionUtil.problemAreasValues)?.toString() ?? '-',
            _question?.problemAreas != null ? 3 : null,
            'problem_area'
          ),
          _list(
            'Fitness Level','${_question?.fitnessLevel ?? '-'}',
            _question?.fitnessLevel != null ? 4 : null,
            'level'
          ),
          _list(
            'Equipment',
            QuestionUtil.mapValueToDesc(_question?.equipment,QuestionUtil.equipmentValues) ?? '-',
            _question?.equipment != null ? 5 : null,
            'equipment'
          ),
        ],
      ),
    );
  }

  Widget _list(String title, String desc, int quePage, String submitFrom){
    return InkWell(
      onTap: () => quePage != null ? Nav.navigateTo(UpdateQuestionPage.routeName,args: {'question': quePage, 'submitFrom': submitFrom}) : null,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: NunitoStyle.title2,),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 150,
                  child: TextOneLine(
                    desc,
                    textAlign: TextAlign.right,
                    style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
                  ),
                ),
                Icon(Icons.chevron_right, color: ThemeColor.black[56],),
              ],
            )
          ],
        ),
      ),
    );
  }
}