import 'package:flutter_fitfit/api/repo.dart';

class PtRepository extends Repository{
  getPtWorkout() {
    return api.getAuth('/pt');
  }

  getPtWorkoutDetail(String id){
    return api.getAuth('/pt/$id');
  }

  postCompleteWorkout(String id){
    return api.postAuth('/pt/$id/complete', {});
  }

  postWorkoutFeedback(String id, int level){
    return api.postAuth('/pt/$id/difficulty', {
      'difficulty_level': level
    });
  }
}