import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/circuit_model.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/workout_model.dart';
import 'package:flutter_fitfit/provider/pt_provider.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/screen/preview_exercise.dart';
import 'package:flutter_fitfit/screen/scroll_page_template.dart';
import 'package:flutter_fitfit/screen/warmup.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/utility/workout_helper.dart';
import 'package:flutter_fitfit/widget/badge.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/custom_loading.dart';
import 'package:flutter_fitfit/widget/exercise_slider.dart';
import 'package:provider/provider.dart';

class WorkoutDetailPage extends StatefulWidget{
  static const routeName = '/workout-detail';
  
  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  bool _isFavorited = false;
  WorkoutModel _workoutModel;

  @override
  void initState(){
    super.initState();
  }

  _getData(Map<String, dynamic> args) async {
    if(args['workoutModel'] != null){
      // For CW
      _workoutModel = args['workoutModel'];
    }
    else if(args['pt_workout_id'] != null){
      // For PT
      final ptProvider = Provider.of<PtProvider>(context, listen: false);
      _workoutModel = await ptProvider.getWorkoutDetail(args['pt_workout_id']);
    }
    return _workoutModel;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
      future: _getData(arguments),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CustomLoading(),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        return ScrollPageTemplate(
          arguments['image'],
          content: _content(),
          bottomNavigationBar: _bottomNavigationBar(context)
        );
      },
    );
  }
  
  Widget _content(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _headingSection(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: ThemeColor.black[08],
              thickness: 1.0,
            ),
          ),
          _focusAreaSection(),
          ..._circuitSection(),
          _equipmentSection()
        ],
      )
    );
    
  }

  Widget _headingSection(){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 2.0,
        children: <Widget>[
          _workoutModel.level != null ? Badge(_workoutModel.levelString, theme: 'orange',) : SizedBox(),
          Text(
            _workoutModel.name,
            style: NunitoStyle.h3,
          ),
          Text(
            // '${_workoutModel.duration} mins • 15 Exercises • 100 kcal', // temp hide it first
            '${_workoutModel.duration} min',
            style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
          )
        ],
      ),
    );
  }

  Widget _focusAreaSection(){
    bool _isPtCardio = WorkoutHelper.isPtCardio(_workoutModel);

    // hide focus area if is PT Cardio
    return (_workoutModel.focusAreas.isNotEmpty && !_isPtCardio) ? Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Focus Areas',style: NunitoStyle.title,),
          ),
          Wrap(
            spacing: 8.0,
            children: _workoutModel.focusAreas.map<Widget>((area) {
              return Badge(area,theme: 'outline');
            }).toList(),
          ),
        ],
      ),
    ) : SizedBox();
  }

  List<Widget> _circuitSection(){
    bool _isPtResistance = WorkoutHelper.isPtResistance(_workoutModel);
    bool _isPtCardio = WorkoutHelper.isPtCardio(_workoutModel);

    return _workoutModel.exerciseCircuits.asMap().entries.map<Widget>( (entry) {
      int _id = entry.key;
      CircuitModel circuit = entry.value;
      bool _isPtUnlimitedSet = _isPtResistance && _id >= 1;
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(circuit.name ?? 'Circuit', style: NunitoStyle.title,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    '${circuit.duration} mins • ${circuit.totalExercises} Exercises ${_isPtUnlimitedSet ? '' : '(${circuit.noSet} Sets)'}',
                    style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _isPtUnlimitedSet ? 'Complete as many sets as you can within the indicated period.' : _isPtCardio ? 'Complete as many reps as you can within the indicated period.' : 'Complete the indicated number of sets',
                            style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56], fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExerciseSlider(
            imgList: circuit.exercisesOnly.map<ExerciseSliderModel>( (exercise) => exercise.toExerciseSlider()).toList(),
            withCaption: true,
            onImageTap: ({index}){
              Nav.navigateTo(PreviewExercisePage.routeName, args: {
                'exerciseDetail': circuit.exercisesOnly[index]
              });
            },
          ),
        ],
      );
    }).toList();
  }

  Widget _equipmentSection(){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 2.0,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Equipment',style: NunitoStyle.title,),
          ),
          ..._workoutModel.equipments.map( (eq) => Text(
            eq,
            style: NunitoStyle.body2.copyWith(color: ThemeColor.black[100]),
          )),
          Visibility(
            visible: _workoutModel.equipments.length == 0,
            child: Text('None', style: NunitoStyle.body2.copyWith(color: ThemeColor.black[100]),)
          )
        ],
      )
    );
  }

  Widget _bottomNavigationBar(BuildContext context){
    final _workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: ThemeColor.black[08])
          ),
          color: Colors.transparent
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: CtaButton(
                'Start Workout',
                onPressed: (_) {
                  _workoutProvider.currentWorkoutName = _workoutModel.name;
                  Nav.navigateTo(WarmupPage.routeName,
                  args: {
                    'workoutModel': _workoutModel,
                  });
                },
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: FavoriteButton(
            //     isFavorited: _isFavorited,
            //     onTap: () {
            //       setState(() {
            //         _isFavorited = !_isFavorited;
            //       });
            //     }
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}