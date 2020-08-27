import 'package:flutter/material.dart';
import 'package:flutter_fitfit/api/pt_repo.dart';
import 'package:flutter_fitfit/model/circuit_model.dart';
import 'package:flutter_fitfit/model/exercise_model.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';
import 'package:flutter_fitfit/model/time_weight.dart';
import 'package:flutter_fitfit/model/timestamp_model.dart';
import 'package:flutter_fitfit/model/workout_model.dart';
import 'package:flutter_fitfit/model/workout_timer_model.dart';
import 'package:flutter_fitfit/utility/workout_helper.dart';

class WorkoutProvider with ChangeNotifier {
  PtRepository _ptRepo;
  TimestampModel _timestampModel;

  WorkoutProvider() {
    _ptRepo = new PtRepository();
    _timestampModel = new TimestampModel(
      warmup: SubTimestampModel(
        pauses: [], 
        workout: StartEndModel(start: null, end: null)
      ),
      exercise: SubTimestampModel(
        pauses: [], 
        workout: StartEndModel(start: null, end: null)
      ),
      cooldown: SubTimestampModel(
        pauses: [], 
        workout: StartEndModel(start: null, end: null)
      ),
    );
  }

  List<WarmUpType> _warmUpSelection = [];
  List<WorkoutTimerModel> workoutList = [];
  int _currentWorkoutIndex = 0;
 
  List<CircuitModel> _workoutCircuitList = [];
  String currentWorkoutName = '';
  WorkoutModel workoutModel;
  int _workoutFeedback = 1;
  List _uniqueExercistList = [];

  int get currentWorkoutIndex => _currentWorkoutIndex;

  int get upNextIndex => _currentWorkoutIndex + 1;

  WorkoutTimerModel get nextWorkout => _currentWorkoutIndex < workoutList.length ? workoutList[_currentWorkoutIndex] : null;

  WorkoutTimerModel get upNextWorkout => upNextIndex < workoutList.length ? workoutList[upNextIndex] : null;
  
  double get workoutProgress => upNextIndex / workoutList.length;

  void setNextCircuitFirstWorkoutIndex(){
    List _remaining = workoutList.skip(currentWorkoutIndex).toList();

    for(MapEntry entry in _remaining.asMap().entries){
      int index = entry.key;
      WorkoutTimerModel workout = entry.value;
      if(workout.circuitIndex != nextWorkout.circuitIndex && workout.exerciseType == ExerciseType.circuitRest){
        _currentWorkoutIndex = index+currentWorkoutIndex;
        break;
      }
      else if(workout.circuitIndex == nextWorkout.circuitIndex && index == _remaining.length - 1){
        // last circuit
        _currentWorkoutIndex = workoutList.length;
      }
    }
  }

  get warmUpSelection => _warmUpSelection;

  void updateWarmUpSelection(WarmUpType type){
    if(_warmUpSelection.contains(type)){
      _warmUpSelection.removeWhere((warmup) => warmup == type);
    }
    else{
      _warmUpSelection.add(type);
    }
    notifyListeners();
  }

  void resetWarmUpSelection(){
    _warmUpSelection = [];
    notifyListeners();
  }

  void decreaseCurrentWorkoutIndex({int index = 1}){
    if(_currentWorkoutIndex > 0) {
      _currentWorkoutIndex = _currentWorkoutIndex - index;
      notifyListeners();
    }
  }

  void increaseCurrentWorkoutIndex({int index = 1}){
    _currentWorkoutIndex = _currentWorkoutIndex + index;
    notifyListeners();
  }

  List<WorkoutTimerModel> _temporaryPtUnlimitedSetList = [];
  List<WorkoutTimerModel> get temporaryPtUnlimitedSetList => _temporaryPtUnlimitedSetList;
  int _currentTemporaryPtUnlimitedSetTotalEx = 0; // to get how many exercise in a set

  set temporaryPtUnlimitedSetList(List<WorkoutTimerModel> list){
    _temporaryPtUnlimitedSetList = list;
    notifyListeners();

    if(_currentTemporaryPtUnlimitedSetTotalEx == 0){
      // exclude last "Rest" workout
      int _finalLength = list.where((ex) => ex.exerciseType != ExerciseType.rest && ex.exerciseType != ExerciseType.setRest).toList().length;

      _currentTemporaryPtUnlimitedSetTotalEx = _finalLength;
      notifyListeners();
    }
  }

  int _currentTemporaryPtUnlimitedSetIndex = 0;
  int get currentTemporaryPtUnlimitedSetIndex => _currentTemporaryPtUnlimitedSetIndex;

  // +1 here becoz initial value is 1
  // _temporaryPtUnlimitedSetList.length - 1 bcoz last exercise is not considered as new set
  // you can try remove the -1 to see the effect lol
  int get currentTemporaryPtUnlimitedSetNumber => _temporaryPtUnlimitedSetList.isNotEmpty ? ((_temporaryPtUnlimitedSetList.length - 1) ~/ _currentTemporaryPtUnlimitedSetTotalEx) + 1 : 1;

  void decreaseTemporaryPtUnlimitedSetIndex(){
    _currentTemporaryPtUnlimitedSetIndex = _currentTemporaryPtUnlimitedSetIndex - 1;
  }

  void increaseTemporaryPtUnlimitedSetIndex(){
    _currentTemporaryPtUnlimitedSetIndex = _currentTemporaryPtUnlimitedSetIndex + 1;
    notifyListeners();
  }

  void resetTemporaryPtUnlimitedSet(){
    _temporaryPtUnlimitedSetList = [];
    _currentTemporaryPtUnlimitedSetIndex = 0;
    _currentTemporaryPtUnlimitedSetTotalEx = 0;
  }

  int get workoutFeedback => _workoutFeedback;

  set workoutFeedback(int workoutFeedback){
    _workoutFeedback = workoutFeedback;
    notifyListeners();
  }

  Future<bool> submitWorkoutFeedback() async{
    dynamic results = await _ptRepo.postWorkoutFeedback(workoutModel.id,_workoutFeedback);

    return results['success'] ?? false;
  }


  int get totalUniqueExercises => _uniqueExercistList.length;

  TimestampModel get workoutTimestampModel => _timestampModel;

  void logTimestamp(String action){
    int currentCircuitIndex = nextWorkout.circuitIndex;
    if(_workoutCircuitList[currentCircuitIndex].type == CircuitType.rest) currentCircuitIndex = nextWorkout.circuitIndex + 1;
    CircuitType _currentCircuitType = _workoutCircuitList[currentCircuitIndex].type;
    int timestamp = new DateTime.now().millisecondsSinceEpoch;

    if(action == 'start'){
      if(_currentCircuitType == CircuitType.warmUp) {
        // log start only if it's warm up
        _timestampModel.warmup.workout.start = timestamp;
      }
      else if(_currentCircuitType == CircuitType.exercise) {
        // this will be triggered on first ex circuit Start
        if(_timestampModel.exercise.workout.start == null) {
          _timestampModel.exercise.workout.start = timestamp;
        }
      }
      else if(_currentCircuitType == CircuitType.coolDown) {
        _timestampModel.cooldown.workout.start = timestamp;
      }
    }
    else if(action == 'end'){
      if(_currentCircuitType == CircuitType.exercise) {
        // check if timestamp list already have warm up, then log end
        // this will be triggered on first ex circuit loaded
        if(_timestampModel.warmup.workout.start != null && _timestampModel.warmup.workout.end == null) {
          _timestampModel.warmup.workout.end = timestamp;
        }
      }
      else if(_currentCircuitType == CircuitType.coolDown) {
        if(_timestampModel.exercise.workout.start != null) {
          _timestampModel.exercise.workout.end = timestamp;
        }
      }
    }
    else if(action == 'pauseStart'){
      if(_currentCircuitType == CircuitType.warmUp) {
        _timestampModel.warmup.pauses.add(StartEndModel(start: timestamp));
      }
      else if(_currentCircuitType == CircuitType.exercise) {
        _timestampModel.exercise.pauses.add(StartEndModel(start: timestamp));
      }
      else if(_currentCircuitType == CircuitType.coolDown) {
        _timestampModel.cooldown.pauses.add(StartEndModel(start: timestamp));
      }
    }
    else if(action == 'pauseEnd'){
      if(_currentCircuitType == CircuitType.warmUp) {
        _timestampModel.warmup.pauses.last.end = timestamp;
      }
      else if(_currentCircuitType == CircuitType.exercise) {
        _timestampModel.exercise.pauses.last.end = timestamp;
      }
      else if(_currentCircuitType == CircuitType.coolDown) {
        _timestampModel.cooldown.pauses.last.end = timestamp;
      }
    }
  }

  List<CircuitModel> getRemainingCircuit(){
    // TODO: Add Cooldown to CircuitList and WorkoutList, exclude from this function
    int currentCircutIndex = workoutList[_currentWorkoutIndex].circuitIndex;
    List<CircuitModel> _remaining = _workoutCircuitList.skip(currentCircutIndex).where((circuit) => circuit.type != CircuitType.rest).toList();

    return _remaining;
  }

  void resetTimestampList(){
    _timestampModel = new TimestampModel(
      warmup: SubTimestampModel(
        pauses: [], 
        workout: StartEndModel(start: null, end: null)
      ),
      exercise: SubTimestampModel(
        pauses: [], 
        workout: StartEndModel(start: null, end: null)
      ),
      cooldown: SubTimestampModel(
        pauses: [], 
        workout: StartEndModel(start: null, end: null)
      ),
    );
  }

  void resetWorkout(){
    _warmUpSelection = [];
    _workoutCircuitList = [];
    workoutList = [];
    _currentWorkoutIndex = 0;
    workoutModel = WorkoutModel();
    resetTimestampList();
  }

  void resetWorkoutExceptWarmup(){
    _workoutCircuitList = [];
    workoutList = [];
    _currentWorkoutIndex = 0;
    workoutModel = WorkoutModel();
    resetTimestampList();
  }

  void startWorkout(WorkoutModel workoutModel){
    resetWorkoutExceptWarmup();
    this.workoutModel = workoutModel;
    // set unique workout exercises
    // need this for workout summary
    List _exLists = [];
    this.workoutModel.exerciseCircuits.forEach((workout){
      List _exList = workout.exercisesOnly.map((ex){
        return ex.name;
      }).toList();
      _exLists = [..._exLists,..._exList];
    });
    _uniqueExercistList = _exLists.toSet().toList();

    generateWorkoutList();
  }

  void generateWorkoutList(){
    int _cardioDurationInMin = 5;
    List<CircuitModel> circuitList = [];
    List<ExerciseModel> _warmupMobilityList = workoutModel.warmup;
    int _mobilityDurationInMin = workoutModel.warmupDuration ?? 0;
    List _warmupEquipments = workoutModel.warmupEquipments ?? [];
    List<CircuitModel> _circuits = workoutModel.circuits;
    List<ExerciseModel> _cooldownList = workoutModel.cooldown;
    int _cooldownDuration = workoutModel.cooldownDuration ?? 0;
    List _cooldownEquipments = workoutModel.cooldownEquipments ?? [];

    // Add Warm up into Circuit
    if(_warmUpSelection.isNotEmpty){
      List<ExerciseModel> _warmupEx = [];
      int _warmupDuration = 0;
      bool _hasChosenCardioWu = _warmUpSelection.contains(WarmUpType.cardio) ?? false;
      bool _hasChosenMobilityWu = _warmUpSelection.contains(WarmUpType.stretch) ?? false;

      if(_hasChosenCardioWu){
        _warmupDuration = _warmupDuration + _cardioDurationInMin;
        _warmupEx.add(
          ExerciseModel(
            name: 'Cardio',
            duration: Duration(minutes: _cardioDurationInMin).inSeconds,
            durationType: DurationType.duration,
            coverImgUrl: 'https://d37lq49mekhjll.cloudfront.net/curated-workouts/Cardio+WU+Placeholder.png',
            videoUrl: '',
            instructionUrl: '',
            type: ExerciseType.warmUp,
            primaryFocusAreas: [],
            secondaryFocusAreas: [],
            equipments: [],
            perSideExercise: false,
            instruction: {},
          )
        );
        
        // Add Cardio - Mobility warm up rest
        if(_hasChosenMobilityWu){
          _warmupEx.add(
            ExerciseModel(
              name: 'Rest',
              duration: 60,
              durationType: DurationType.duration,
              coverImgUrl: '',
              videoUrl: '',
              instructionUrl: '',
              type: ExerciseType.rest,
              primaryFocusAreas: [],
              secondaryFocusAreas: [],
              equipments: [],
              perSideExercise: false,
              instruction: {},
            )
          );
        }
      }
      
      if(_hasChosenMobilityWu){
        _warmupEx = [..._warmupEx, ..._warmupMobilityList];
        _warmupDuration = _warmupDuration + _mobilityDurationInMin;
      }

      circuitList.add(
        CircuitModel(
          name: 'Warm Up',
          type: CircuitType.warmUp,
          noSet: 1,
          duration: _warmupDuration,
          exercises: _warmupEx,
          restDuration: 60,
          equipments: _hasChosenMobilityWu ? _warmupEquipments : [],
        )
      );

      circuitList.add(
        CircuitModel(
          name: 'Circuit Rest',
          type: CircuitType.rest,
          noSet: 1,
          duration: 60,
          exercises: [],
          restDuration: 60,
          equipments: [],
        )
      );
    }

    _workoutCircuitList = [...circuitList, ..._circuits];

    // add cool down circuit
    _workoutCircuitList.add(
      CircuitModel(
        name: 'Cool Down',
        type: CircuitType.coolDown,
        noSet: 1,
        duration: _cooldownDuration,
        exercises: _cooldownList,
        restDuration: 60,
        equipments: _cooldownEquipments ?? [],
      )
    );

    // Add all exercise into workout list
    for (int currentCircuit = 0; currentCircuit < _workoutCircuitList.length; currentCircuit++) {
      CircuitModel circuit = _workoutCircuitList[currentCircuit];
      String circuitName = circuit.name;
      int _circuitNo = 0;

      if(circuitName != null && circuitName.contains('Circuit') && !circuitName.contains('Rest')){
        String _circuitNoString = circuitName.substring(8);
        _circuitNo = int.parse(_circuitNoString);
      }

      bool _shouldNotShowSet = WorkoutHelper.isPtResistance(workoutModel) && _circuitNo >= 2;

      if(circuit.type == CircuitType.exercise){
        int noOfSets = circuit.noSet;
        
        for (int s = 1; s <= noOfSets; s++) {
          String title = '$circuitName ${_shouldNotShowSet ? '' : '- Set $s/$noOfSets'}';

          List<WorkoutTimerModel> _transformedEx = circuit.exercises.map((ex) => 
            ex.toWorkoutTimerModel(
              exerciseCircuitSetTitle: title,
              circuitIndex: currentCircuit
            )).toList();

          workoutList = [...workoutList, ..._transformedEx];

          workoutList.add(
            WorkoutTimerModel(
              exerciseType: ExerciseType.setRest,
              exerciseTitle: title,
              exerciseName: 'Set $s completed',
              circuitIndex: currentCircuit,
              showDuration: true,
              exerciseDuration: Duration(seconds: 3)
            )
          );
        }

        // exclude last exercise rest in last set
        var last = workoutList[workoutList.length - 2];
        if (last.exerciseType == ExerciseType.rest) {
          workoutList.removeAt(workoutList.length - 2);
        }
        
      }
      else if(circuit.type == CircuitType.rest){
        workoutList.add(
          WorkoutTimerModel(
            exerciseType: ExerciseType.circuitRest,
            exerciseTitle: circuitName,
            exerciseName: 'Rest',
            circuitIndex: currentCircuit,
            showDuration: true,
            exerciseDuration: Duration(seconds: circuit.restDuration ?? 30)
          )
        );
      }
      else if(circuit.type == CircuitType.warmUp){
        List<WorkoutTimerModel> _transformedWuList = circuit.exercises.map((ex) => 
          ex.toWorkoutTimerModel(
            exerciseCircuitSetTitle: 'Warm Up',
            circuitIndex: currentCircuit
          )).toList();

        workoutList = [...workoutList, ..._transformedWuList];
      }
      else if(circuit.type == CircuitType.coolDown){
        // if last workout (before adding cooldown) is circuit rest, then remove this
        if(workoutList.last.exerciseType == ExerciseType.circuitRest){
          workoutList.removeLast();
        }

        WorkoutTimerModel _cdCircuitRest = WorkoutTimerModel(
          exerciseType: ExerciseType.circuitRest,
          exerciseTitle: circuitName,
          exerciseName: 'Rest',
          circuitIndex: currentCircuit,
          showDuration: true,
          exerciseDuration: Duration(seconds: 60)
        );

        workoutList = [...workoutList, ...[_cdCircuitRest]];
        
        List<WorkoutTimerModel> _transformedCdList = circuit.exercises.map((ex) => 
          ex.toWorkoutTimerModel(
            exerciseCircuitSetTitle: 'Cool Down',
            circuitIndex: currentCircuit
          )).toList();

        workoutList = [...workoutList, ..._transformedCdList];
      }


      // Commented for 8 Apr build
      // If last circuit type is not rest, then add a circuit rest to display cooldown circuit option
      // if(currentCircuit == circuits.length - 1 && circuit.type != CircuitType.rest){
      //   workoutList.add(
      //     WorkoutTimerModel(
      //       exerciseType: ExerciseType.circuitRest,
      //       exerciseTitle: circuitName,
      //       exerciseName: 'Rest',
      //       circuitIndex: 1, //why put 1? I also dunno FML
      //       showDuration: true,
      //       exerciseDuration: Duration(seconds: circuit.restDuration ?? 30)
      //     )
      //   );
      // }
    }

    // Commented for 8 Apr build
    // Add CoolDown exercises into WorkoutList
    // List<WorkoutTimerModel> _transformedCoolDown = _cooldownList.map<WorkoutTimerModel>( (exercise) => 
    //   exercise.toWorkoutTimerModel(isCoolDown: true)
    // ).toList();

    // _transformedCoolDown.forEach((ex) => {
    //   workoutList.add(ex)
    // });

    // exclude last circuit rest if there is
    var last = workoutList[workoutList.length - 1];
    if (last.exerciseType == ExerciseType.circuitRest) {
      workoutList.removeAt(workoutList.length - 1);
    }
    
    // workoutList.forEach((w){
    //   print('${w.exerciseTitle},${w.exerciseName},${w.exerciseType},${w.circuitIndex}');
    // });
    
  }
}