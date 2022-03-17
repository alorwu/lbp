
class PSQIQuestion{
  String number;
  String question;
  String subtitle;
  bool status;
  String type;
  String notInPastMonth;
  String lessThanOnceAWeek;
  String onceOrTwiceAWeek;
  String threeOrMoreAWeek;
  String data;

  PSQIQuestion(
      {
        this.number,
        this.question,
        this.subtitle,
        this.status,
        this.type,
        this.notInPastMonth,
        this.lessThanOnceAWeek,
        this.onceOrTwiceAWeek,
        this.threeOrMoreAWeek,
        this.data
      }
    );
}