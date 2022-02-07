
class QolSurvey {
  int global02;
  int global03;
  int global04;
  int global05;
  int global07;
  int global08;
  int global09;
  int global10;
  int globalPhysicalHealth;
  int globalMentalHealth;
  DateTime dateTaken;
  String userId;

  QolSurvey({
    this.global02,
    this.global03,
    this.global04,
    this.global05,
    this.global07,
    this.global08,
    this.global09,
    this.global10,
    this.globalPhysicalHealth,
    this.globalMentalHealth,
    this.dateTaken,
    this.userId
  });

  Map<String, dynamic> toJson() {
    return {
      'global02': global02,
      'global03': global03,
      'global04': global04,
      'global05': global05,
      'global07': global07,
      'global08': global08,
      'global09': global09,
      'global10': global10,
      'globalPhysicalHealth': globalPhysicalHealth,
      'globalMentalHealth': globalMentalHealth,
      'dateTaken': dateTaken.toIso8601String(),
      'userId': userId
    };
  }
}