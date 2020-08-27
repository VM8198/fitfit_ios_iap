import 'package:flutter_fitfit/api/repo.dart';
import 'package:flutter_fitfit/model/question_model.dart';

class QueRepository extends Repository{
  postQuestionnaires(QuestionModel questionModel) {
    return api.postAuth('/users/questions',questionModel.toSubmitQuestionReq());
  }
}