import 'package:flutter_fitfit/api/repo.dart';

class WorkoutGroupRepository extends Repository{
  getDetails(id) {
    return api.get('/workout-groups/$id');
  }
}