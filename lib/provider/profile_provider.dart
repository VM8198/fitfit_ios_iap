import 'package:flutter/material.dart';
import 'package:flutter_fitfit/api/profile_repo.dart';
import 'package:flutter_fitfit/model/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  ProfileRepository _profileRepository;
  ProfileModel _profileModel;

  ProfileProvider(){
    _profileRepository = ProfileRepository();
  }

  getMyProfile() async{
    dynamic results = await _profileRepository.getMyProfile();
    _profileModel = ProfileModel.fromJson(results);
    return _profileModel;
  }
}