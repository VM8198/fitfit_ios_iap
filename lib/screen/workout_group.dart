import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_group_model.dart';
import 'package:flutter_fitfit/provider/cw_provider.dart';
import 'package:flutter_fitfit/screen/scroll_page_template.dart';
import 'package:flutter_fitfit/screen/workout_detail.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/custom_loading.dart';
import 'package:flutter_fitfit/widget/exercise_list.dart';
import 'package:provider/provider.dart';

class WorkoutGroupPage extends StatefulWidget{
  static const routeName = '/workout-group';

  @override
  _WorkoutGroupPageState createState() => _WorkoutGroupPageState();
}

class _WorkoutGroupPageState extends State<WorkoutGroupPage> {
  ExerciseSliderModel _exerciseSliderModel;
  WorkoutGroupModel _workoutGroupModel;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Utility.sendAnalyticsEvent(
        AnalyticsEventType.discover_cw_group, 
        param: {'name': _exerciseSliderModel.title}
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _exerciseSliderModel = ModalRoute.of(context).settings.arguments;
    return ScrollPageTemplate(
      _exerciseSliderModel.thumbnail,
      content: _content(context),
    );
  }

  _initList(context) async{
    CwProvider provider = Provider.of<CwProvider>(context, listen: false);

    await provider.getDetails(_exerciseSliderModel.id);
    return provider;
  }

  Widget _content(context){
    return FutureBuilder(
      future: _initList(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoading());
        }

        if (snapshot.hasError) {
          return Center(child: Icon(Icons.warning));
        }

        _workoutGroupModel = snapshot.data.workoutGroupModel;

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _workoutGroupModel.name,
                      style: NunitoStyle.h3,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${_workoutGroupModel.totalWorkouts} workouts',
                      style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Divider(
                  color: ThemeColor.black[08],
                  thickness: 1.0,
                ),
              ),
              ExerciseList(
                withLeading: false,
                imgList: _workoutGroupModel.workouts.map( (workout) => workout.toExerciseSlider()).toList(),
                withCaption: true,
                onImageTap: (param){
                  ExerciseSliderModel item = param['items'];
                  Nav.navigateTo(WorkoutDetailPage.routeName, args: {
                    'workoutModel': item.ref,
                    'image': _exerciseSliderModel.thumbnail,
                  });
                },
              )
            ],
          )
        );
      }
    );
  }
}