import 'package:lbp/model/monthly/PSQIQuestion.dart';

class PSQIQuestionnaire {

  int _questionNumber = 0;


  List<PSQIQuestion> _questionList = [
    PSQIQuestion(
        number: '1',
        question: 'During the past month, what time have you usually gone to bed at night?',
        subtitle: 'BED TIME',
        status: false,
        type: 'text',
        data: null
    ),
    PSQIQuestion(
        number: '2',
        question: 'During the past month, how long (in minutes) has it usually taken you to fall asleep each night?',
        subtitle: 'NUMBER OF MINUTES',
        status: false,
        type: 'text',
        data: null
    ),
    PSQIQuestion(
        number: '3',
        question: 'During the past month, what time have you usually gotten up in the morning?',
        subtitle: 'GETTING UP TIME',
        status: false,
        type: 'text',
        data: null
    ),
    PSQIQuestion(
        number: '4',
        question: 'During the past month, how many hours of ACTUAL SLEEP did you get at night? (This may be different than the number of hours you spent in bed)?',
        subtitle: 'HOURS OF SLEEP PER NIGHT',
        status: false,
        type: 'text',
        data: null
    ),
    PSQIQuestion(
        number: '5a',
        question: 'During the past month, how often have you had trouble sleeping because you cannot go to sleep within 30 minutes',
        subtitle: '', //'...cannot go to sleep within 30 minutes',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5b',
        question: 'During the past month, how often have you had trouble sleeping because you wake up in the middle of the night or early morning',
        subtitle: '', //'''...wake up in the middle of the night or early morning',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5c',
        question: 'During the past month, how often have you had trouble sleeping because you have to get up to use the bathroom',
        subtitle: '', //'''...have to get up to use the bathroom',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5d',
        question: 'During the past month, how often have you had trouble sleeping because you cannot breathe comfortably',
        subtitle: '', //'''...cannot breathe comfortably',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5e',
        question: 'During the past month, how often have you had trouble sleeping because you cough or snore loudly',
        subtitle: '', //'''...cough or snore loudly',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5f',
        question: 'During the past month, how often have you had trouble sleeping because you feel too cold',
        subtitle: '', //'''...feel too cold',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5g',
        question: 'During the past month, how often have you had trouble sleeping because you feel too hot',
        subtitle: '', //'''...feel too hot',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5h',
        question: 'During the past month, how often have you had trouble sleeping because you had bad dreams',
        subtitle: '', //'''...had bad dreams',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5i',
        question: 'During the past month, how often have you had trouble sleeping because you have pain',
        subtitle: '', //'''...have pain',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '5j-i',
        question: 'Besides pain, have you had trouble sleeping due to other reason(s)? Please describe below:',
        subtitle: '',
        status: false,
        type: 'freeformlikert',
        notInPastMonth: '',
        lessThanOnceAWeek: '',
        onceOrTwiceAWeek: '',
        threeOrMoreAWeek: '',
        data: null
    ),
    PSQIQuestion(
        number: '5j-ii',
        question: 'How often during the past month have you had trouble sleeping because of these other reasons?',
        subtitle: '',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '6',
        question: 'During the past month, how would you rate your sleep quality overall?',
        subtitle: '',
        status: false,
        type: 'likert',
        notInPastMonth: 'Very good',
        lessThanOnceAWeek: 'Fairly good',
        onceOrTwiceAWeek: 'Fairly bad',
        threeOrMoreAWeek: 'Very bad',
        data: null
    ),
    PSQIQuestion(
        number: '7',
        question: 'During the past month, how often have you taken medicine to help you sleep (prescribed or "over the counter")?',
        subtitle: '',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '8',
        question: 'During the past month, how often have you had trouble staying awake while driving, eating meals, or engaging in social activity?',
        subtitle: '',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '9',
        question: 'During the past month, how much of a problem has it been for you to keep up enough enthusiasm to get things done?',
        subtitle: '',
        status: false,
        type: 'likert',
        notInPastMonth: 'No problem at all',
        lessThanOnceAWeek: 'Only a very slight problem',
        onceOrTwiceAWeek: 'Somewhat of a problem',
        threeOrMoreAWeek: 'A very big problem',
        data: null
    ),
    PSQIQuestion(
        number: '10',
        question: 'Do you have a bed partner or room mate?',
        subtitle: '',
        status: false,
        type: 'likert',
        notInPastMonth: 'No bed partner or room mate',
        lessThanOnceAWeek: 'Partner/room mate in other room',
        onceOrTwiceAWeek: 'Partner in same room, but not same bed',
        threeOrMoreAWeek: 'Partner in same bed',
        data: null
    ),
    PSQIQuestion(
        number: '10a',
        question: 'If you have a room mate or bed partner, ask him/her how often in the past month you have had loud snoring',
        subtitle: '', //'''...loud snoring',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '10b',
        question: 'If you have a room mate or bed partner, ask him/her how often in the past month you have had long pauses between breaths while asleep',
        subtitle: '', //'...long pauses between breaths while asleep',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '10c',
        question: 'If you have a room mate or bed partner, ask him/her how often in the past month you have had legs twitching or jerking while you sleep',
        subtitle: '', //'''...legs twitching or jerking while you sleep',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '10d',
        question: 'If you have a room mate or bed partner, ask him/her how often in the past month you have had episodes of disorientation or confusion during sleep',
        subtitle: '', //'''...episodes of disorientation or confusion during sleep',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '10e-i',
        question: 'If you have a room mate or bed partner, ask him/her how often in the past month you have had other restlessness while you sleep; please describe:',
        subtitle: '', //'''...other restlessness while you sleep; please describe:',
        status: false,
        type: 'freeformlikert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
    PSQIQuestion(
        number: '10e-ii',
        question: 'How often during the past month have you had this type of restlessness?',
        subtitle: '',
        status: false,
        type: 'likert',
        notInPastMonth: 'Not during the past month',
        lessThanOnceAWeek: 'Less than once a week',
        onceOrTwiceAWeek: 'Once or twice a week',
        threeOrMoreAWeek: 'Three or more times a week',
        data: null
    ),
  ];


  dynamic nextPSQIQuestion(){
    if (_questionNumber <= _questionList.length - 1) {
      if (_questionNumber != _questionList.length - 1) {
        _questionNumber++;
      }
    }
  }

  dynamic prevQuestion() {
    if (_questionNumber > 0) {
      _questionNumber--;
    }
    return false;
  }

  PSQIQuestion getPSQIQuestion(){
    return _questionList[_questionNumber];
  }

  int getPSQIQuestionNumber(){
    return _questionNumber;
  }


  void setPSQIQuestionStatus(bool status) {
     _questionList[_questionNumber].status = status;
  }

  List<PSQIQuestion> getPSQIQuestions() {
    return _questionList;
  }

  int startOverPSQI(){
    return _questionNumber = 0;
  }

  bool lastQuestion() {
    return _questionNumber == _questionList.length - 1;
  }

  int getQuestionnaireLength() {
    return _questionList.length;
  }
}