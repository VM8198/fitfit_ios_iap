class QuestionUtil{
  static List<Map> goalValues = [
    {
      'value': 'lose-weight',
      'desc': 'Lose Weight',
    },
    {
      'value': 'build-muscle',
      'desc': 'Build Muscle',
    },
    {
      'value': 'get-toned',
      'desc': 'Get Toned',
    },
  ];

  static List<Map> problemAreasValues = [
    {
      'value': 'shoulders',
      'desc': 'Shoulders',
    },
    {
      'value': 'arms',
      'desc': 'Arms',
    },
    {
      'value': 'glutes',
      'desc': 'Glutes',
    },
    {
      'value': 'chest',
      'desc': 'Chest',
    },
    {
      'value': 'back',
      'desc': 'Back',
    },
    {
      'value': 'core',
      'desc': 'Core',
    },
    {
      'value': 'legs',
      'desc': 'Legs',
    },
  ];

  static List<Map> equipmentValues = [
    {
      'value': 'no-equipment',
      'desc': 'No equipment',
      'desc_paragraph': 'Using only chair, mat, pole, towel, wall',
    },
    {
      'value': 'minimal-equipment',
      'desc': 'Minimal equipment',
      'desc_paragraph': 'All the above plus bench and dumbbell',
    },
  ];

  static mapValueToDesc(String value,List<Map> list){
    var _mapped = list.where((obj) => obj['value'] == value);
    Map _obj = _mapped.isNotEmpty ? _mapped.first : {};

    return _obj.isNotEmpty ? _obj['desc'] : null;
  }

  static mapValueArrayToDesc(List values,List<Map> list){
    List _valueList = values.map((val){
      Map _obj = list.where((obj) => obj['value'] == val).first;
      return _obj['desc'];
    }).toList();

    return _valueList.isNotEmpty ? _valueList.join(', ') : null;
  }
}