import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/exercise_model.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:flutter_fitfit/widget/badge.dart';
import 'package:flutter_fitfit/widget/custom_loading.dart';
import 'package:video_player/video_player.dart';

class PreviewExercisePage extends StatefulWidget{
  static const routeName = '/preview-exercise';
  final Map<String,ExerciseModel> argument;

  PreviewExercisePage({this.argument});

  @override
  _PreviewExercisePageState createState() => _PreviewExercisePageState();
}

class _PreviewExercisePageState extends State<PreviewExercisePage> {
  ExerciseModel _exerciseDetail;
  VideoPlayerController _videoController;

  @override
  void initState() {
    _videoController = VideoPlayerController.network(
        widget.argument['exerciseDetail'].videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });

    WidgetsBinding.instance.addPostFrameCallback((_){
      Utility.sendAnalyticsEvent(
        AnalyticsEventType.exercise_detail, 
        param: {'name': _exerciseDetail.name}
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    _exerciseDetail = widget.argument['exerciseDetail'];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              expandedHeight: size.width,
              leading: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.4),
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 24,
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: _videoController.value.initialized ? VideoPlayer(_videoController) : 
                        Center(child: CustomLoading()),
                      // child: VideoPlayer(_videoController),
                    ),
                  ]
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _mainSection(),
                  _focusAreaSection(),
                  ..._renderInstructionSection(),
                  _equipmentSection()
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainSection(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        '${_exerciseDetail.name}',
        style: NunitoStyle.h3,
      ),
    );
  }

  Widget _focusAreaSection(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Focus On',style: NunitoStyle.title.copyWith(fontWeight: FontWeight.w700),),
          ),
          Wrap(
            spacing: 8.0,
            children: _exerciseDetail.focusAreas.map<Widget>((area) {
              return Badge(area,theme: 'outline');
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _renderInstructionSection(){
    Map _instruction = _exerciseDetail.instruction;
    List<Widget> _sections = [];
    

    _instruction.forEach((ins,_) {
      String title = '';

      switch (ins) {
        case 'getting_ready':
          title = 'Getting Ready';
          break;
        case 'execution':
          title = 'Execution';
          break;
        case 'tips':
          title = 'Tips';
          break;
      }

      _sections.add(
        _instructionSection(title,_instruction[ins])
      );
    });

    return _sections;
  }

  Widget _instructionSection(String title, String desc){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(title,style: NunitoStyle.title.copyWith(fontWeight: FontWeight.w700),),
              ),
            ],
          ),
          Text(
            desc ?? '',
            style: NunitoStyle.body2.copyWith(color: ThemeColor.black[100]),
          ),
        ],
      ),
    );
  }

  Widget _equipmentSection(){
    return Visibility(
      visible: _exerciseDetail.equipments != null && _exerciseDetail.equipments.isNotEmpty,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('Equipment',style: NunitoStyle.title.copyWith(fontWeight: FontWeight.w700),),
                ),
              ],
            ),
            ..._exerciseDetail.equipments.map( (eq) => Text(
              eq,
              style: NunitoStyle.body2.copyWith(color: ThemeColor.black[100]),
            )),
          ],
        ),
      ),
    );
  }
}