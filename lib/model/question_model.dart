class QuestionModel{
  String gender;
  String goal;
  List problemAreas;
  int fitnessLevel;
  String equipment;
  String dob;
  int height;
  int weight;
  int targetWeight;
  String submitFrom;

  QuestionModel({
    this.gender,
    this.goal,
    this.problemAreas,
    this.fitnessLevel = 1,
    this.equipment,
    this.dob,
    this.height,
    this.weight,
    this.targetWeight,
    this.submitFrom
  });

  toSubmitQuestionReq(){
    Map data = {
      "gender": gender,
      "goal": goal,
      "problem_areas": problemAreas,
      "fitness_level": fitnessLevel,
      "equipment": equipment,
      "dob": dob,
      "height": height,
      "weight": weight,
      "from": submitFrom
    };

    if(targetWeight != null) {
      data['target_weight'] = targetWeight;
    }
    
    return data;
  }

}
