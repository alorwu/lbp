
class PsqiSurvey {
  int? sleepQualityComponent;
  int? sleepLatencyComponent;
  int? sleepDurationComponent;
  int? sleepEfficiencyComponent;
  int? sleepDisturbanceComponent;
  int? sleepMedicationComponent;
  int? dayTimeDysfunctionComponent;
  int? psqiScore;
  DateTime? dateTaken;
  String? userId;

  PsqiSurvey({
    this.sleepQualityComponent,
    this.sleepLatencyComponent,
    this.sleepDurationComponent,
    this.sleepEfficiencyComponent,
    this.sleepDisturbanceComponent,
    this.sleepMedicationComponent,
    this.dayTimeDysfunctionComponent,
    this.psqiScore,
    this.dateTaken,
    this.userId
});

  Map<String, dynamic> toJson() {
    return {
      'sleepQualityComponent': sleepQualityComponent,
      'sleepLatencyComponent': sleepLatencyComponent,
      'sleepDurationComponent': sleepDurationComponent,
      'sleepEfficiencyComponent': sleepEfficiencyComponent,
      'sleepDisturbanceComponent': sleepDisturbanceComponent,
      'sleepMedicationComponent': sleepMedicationComponent,
      'dayTimeDysfunctionComponent': dayTimeDysfunctionComponent,
      'psqiScore': psqiScore,
      'dateTaken': dateTaken!.toIso8601String(),
      'userId': userId
    };
  }
}