import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/pt_model.dart';
import 'package:flutter_fitfit/model/workout_model.dart';
import 'package:flutter_fitfit/provider/pt_provider.dart';
import 'package:flutter_fitfit/screen/forgot_password.dart';
import 'package:flutter_fitfit/screen/pt_circular_timer.dart';
import 'package:flutter_fitfit/screen/workout_detail.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/pref.dart';
import 'package:flutter_fitfit/widget/curved_app_bar.dart';
import 'package:flutter_fitfit/widget/custom_loading.dart';
import 'package:flutter_fitfit/widget/exercise_list.dart';
import 'package:flutter_fitfit/widget/exercise_slider.dart';
import 'package:flutter_fitfit/widget/pt_finish_week_card.dart';
import 'package:flutter_fitfit/widget/pt_non_subscriber_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class PersonalizedTrainingPage extends StatefulWidget{
  static const routeName = '/personal-training';

  @override
  _PersonalizedTrainingPageState createState() => _PersonalizedTrainingPageState();
}

class _PersonalizedTrainingPageState extends State<PersonalizedTrainingPage> {
  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    _getIfQueCompleted();
  }

  void _getIfQueCompleted() async{
    bool _isQueCompleted = await Pref.getQuesCompleted() ?? false;
    if(_isQueCompleted) {
      Provider.of<PtProvider>(context, listen: false).updateIsPTQueCompleted(true);
    }
  }

  _initData() async {
    final ptProvider = Provider.of<PtProvider>(context, listen: false);

    await ptProvider.getList();
    return ptProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PtProvider, bool>(
      selector: (context, provider) => provider.isPTQueCompleted,
      builder: (context, isPTQueCompleted, _) {
        if(!isPTQueCompleted){
          return PtNonSubscriberCard();
        }
        return Scaffold(
          backgroundColor: ThemeColor.background,
          extendBodyBehindAppBar: true,
          appBar: isPTQueCompleted ? _getAppBar() : null,
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
                  return Center(child: Text(snapshot.error));
                }

                PtProvider ptProvider = snapshot.data;

                List<Widget> _ptWorkoutList = ptProvider.ptWorkoutGroups.map<Widget>((PtModel data){
                  return HorizontalCategorySection(
                    data.categoryName,
                    data.workoutGroups,
                    workoutType: data.workoutType,
                    totalCompleted: data.completedWorkouts,
                    totalWorkouts: data.totalWorkouts
                  );
                }).toList();

                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: ptProvider.isAllWorkoutsCompleted ? Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: PtFinishWeeklyWorkoutCard(),
                      ) : SizedBox(),
                    ),
                    ..._ptWorkoutList
                    // _favoriteSection()
                  ],
                );
              }
            ),
          ),
        );
      },
    );
  }

  Widget _favoriteSection(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColor.primary.withOpacity(0.08),Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.center
        ),
      ),
      padding: EdgeInsets.only(top: 16.0),
      child: VerticalCategorySection(
        'Favorite Workouts',
        ExerciseSliderModel.dummyExerciseSliderList1
      ),
    );
  }

  Widget _getAppBar(){
    return curvedAppBar(
      title: Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Wrap(
              direction: Axis.vertical,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8.0,
              children: <Widget>[
                Text(
                  'This Week’s Training',
                  textAlign: TextAlign.center,
                  style: NunitoStyle.h4.copyWith(color: ThemeColor.primaryDark),
                ),
                Selector<PtProvider, String>(
                  selector: (_, provider) => provider.levelName,
                  builder: (_, level, __){
                    return Text(
                      level != null ? '$level'.toUpperCase() : '',
                      textAlign: TextAlign.center,
                      style: NunitoStyle.caption1.copyWith(color: ThemeColor.primaryDark),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class HorizontalCategorySection extends StatelessWidget{
  final String title;
  final List list;
  final PtWorkoutType workoutType;
  final int totalCompleted;
  final int totalWorkouts;

  HorizontalCategorySection(this.title,this.list,{this.workoutType,this.totalCompleted,this.totalWorkouts});

  @override
  Widget build(BuildContext context) {
    Color _themeColor = workoutType == PtWorkoutType.resistance ? ThemeColor.secondaryDark : ThemeColor.primaryDark;
    int _completedWorkout = totalCompleted ?? 0;

    // Commented to hide own cardio until custom timer is done
    // need to minus 1 for Cardio total workout code to exclude LI Cardio
    // int _totalWorkout = totalWorkouts != null ? workoutType == PtWorkoutType.cardio ? totalWorkouts - 1 : totalWorkouts : 0;
    int _totalWorkout = totalWorkouts ?? 0;
    List _exList = list;
    
    // Hide own cardio until custom timer is done
    if(workoutType == PtWorkoutType.cardio && _exList?.last?.title == 'Low Intensity Cardio') {
      _exList.removeLast();
    }

    double _completionFraction = _completedWorkout / _totalWorkout;

    // safety checking
    int _completion = (_completionFraction.isInfinite ? 100 : (_completionFraction * 100)).toInt();

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: NunitoStyle.h4,),
                  RichText(
                    text: TextSpan(
                      text: '${_completedWorkout > _totalWorkout ? _totalWorkout : _completedWorkout}',
                      style: NunitoStyle.title.copyWith(color: _themeColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: '/$_totalWorkout Workouts',
                          style: NunitoStyle.title.copyWith(color: ThemeColor.black[56]),
                        ),
                      ]
                    ),
                  )
                ],
              ),
              CircularPercentIndicator(
                percent: _completedWorkout / _totalWorkout > 1 ? 1 : _completedWorkout / _totalWorkout,
                radius: 50.0,
                progressColor: _themeColor,
                backgroundColor: ThemeColor.black[08],
                center: Text(
                  '${_completion > 100 ? 100 : _completion}%',
                  style: NunitoStyle.caption2.copyWith(color: _themeColor),
                ),
              )
            ],
          ),
        ),
        ExerciseSlider(
          imgList: _exList,
          withCaption: true,
          captionStyle: SliderCaptionStyle.overlay,
          onImageTap: ({index}){
            ExerciseSliderModel item = list[index];

            Nav.navigateTo(WorkoutDetailPage.routeName, args: {
              'pt_workout_id': item.id,
              'image': item.thumbnail,
            });
            
            // Commented to hide own cardio until custom timer is done
            // if last index then it's LI
            // if(index == list.length - 1 && workoutType == PtWorkoutType.cardio){
            //   Nav.navigateTo(PtCircularTimerPage.routeName, args: {
            //     'title': 'Low Intensity Cardio',
            //     'pt_workout_id': item.id,
            //   });
            // }
            // else{
            //   Nav.navigateTo(WorkoutDetailPage.routeName, args: {
            //     'pt_workout_id': item.id,
            //     'image': item.thumbnail,
            //   });
            // }
          }
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CategoryHeader(
            title: '$title',
            actionText: 'View All',
            actionNavRoute: ForgotPasswordPage.routeName,
          ),
        ),
        ExerciseList(
          imgList: list,
          withCaption: true,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: NunitoStyle.h4,),
        FlatButton(
          child: Text(
            '$actionText',
            style: NunitoStyle.body2.copyWith(
              color: ThemeColor.secondaryDark,
            ),
          ),
          onPressed: () => Nav.navigateTo(actionNavRoute),
        ),
      ],
    );
  }
}