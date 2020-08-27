import 'package:flutter_fitfit/api/repo.dart';

class ProfileRepository extends Repository{
  getMyProfile() {
    return api.getAuth('/users/me');
  }
}