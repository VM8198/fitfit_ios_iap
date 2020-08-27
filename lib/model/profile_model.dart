import 'package:flutter_fitfit/model/question_model.dart';
import 'package:intl/intl.dart';

class ProfileModel {
  String name;
  QuestionModel questionModel;

  ProfileModel({
    this.name,
    this.questionModel
  });

  String get heightInCm => (questionModel?.height != null) ? '${questionModel.height}cm' : null;

  String get formattedDob{
    List<String> bday = this.questionModel?.dob?.split('-') ?? [];

    if(bday.isEmpty) return null;
    var _dob = DateTime.parse('${bday[2]}-${bday[1]}-${bday[0]}');
    var formatter = DateFormat('dd-MM-yy');
    String _newVal = formatter.format(_dob);

    return _newVal;
  }

  factory ProfileModel.fromJson(dynamic results) {
    Map _data = results['data'];
    Map<String,dynamic> _question = _data?.containsKey('extras') == true && _data['extras']?.isNotEmpty == true ? 
                                    _data['extras']['questions'] 
                                    : {};

    return ProfileModel(
      name: _data['name'],
      questionModel: _question != null && _question?.isNotEmpty ? QuestionModel(
        dob: _question['dob'],
        height: _question['height'],
        weight: _question['weight'],
        targetWeight: _question['target_weight'],
        gender: _question['gender'],
        goal: _question['goal'],
        problemAreas: _question['problem_areas'],
        fitnessLevel: _question['fitness_level'],
        equipment: _question['equipment'],
      ) : QuestionModel()
    );
  }
}