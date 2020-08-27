enum WarmUpType{
  stretch,
  cardio
}

enum WorkoutType{
  curated,
  personalTraining
}

enum WorkoutLevelType{
  all,
  beginner,
  apprentice,
  intermediate,
  advanced,
  guru,
}

enum ExerciseType{
  warmUp,
  coolDown,
  rest,
  exercise,
  setRest,
  circuitRest,
}

enum CircuitType{
  warmUp,
  exercise,
  rest,
  coolDown
}

enum AnalyticsEventType{
  pageview,
  discover_cw,
  discover_cw_group, //param
  discover_cw_workout,
  exercise_detail, //param
  cw_warmup,
  cw_warmup_start,
  cw_warmup_skip,
  cw_workout_start, //param
  cw_workout_pause,
  cw_workout_skip,
  cw_workout_quit, //param
  cw_cooldown,
  cw_cooldown_start,
  cw_cooldown_skip,
  cw_workout_complete //param
}

enum PtWorkoutType{
  resistance,
  cardio
}