import 'package:flutter_fitfit/api/repo.dart';

class CwRepository extends Repository{
  getCuratedWorkout() {
    return api.get('/curated-workouts');
  }
}