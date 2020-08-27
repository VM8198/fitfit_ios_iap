class TimestampModel {
  SubTimestampModel warmup;
  SubTimestampModel exercise;
  SubTimestampModel cooldown;

  TimestampModel({
    this.warmup,
    this.exercise,
    this.cooldown,
  });
}

class SubTimestampModel {
  List<StartEndModel> pauses;
  StartEndModel workout;

  SubTimestampModel({
    this.pauses,
    this.workout,
  });
}

class StartEndModel {
  int start;
  int end;

  StartEndModel({
    this.start,
    this.end,
  });
}