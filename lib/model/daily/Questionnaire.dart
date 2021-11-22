import 'package:lbp/model/daily/Question.dart';

class Questionnaire {

  int _questionNumber = 0;

// this List variable will store our questions 
// and answers as specified in the questions class

  List<Question> _questionList = [
    Question(question: 'At what time did you sleep last night?', status: false, type: 'date_picker', low: '', high: '', data: null),
    Question(question: 'At what time did you wake up this morning?', status: false, type: 'date_picker', low: '', high: '', data: null),
    // Question(question: 'At what time did you fall asleep yesterday?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    // Question(question: 'At what time did you wake up and leave the bed this morning?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    // Question(question: 'Compared to other days, how long did it take you to fall asleep yesterday?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    // Question(question: 'Compared to other days, how early did you wake up and leave the bed this morning?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    Question(question: 'How long did it take to fall asleep after you went to bed yesterday?', status: false, type: 'likert', low: 'Less time than normal', high: 'More time than normal', data: null),
    // Question(question: 'How often do you remember waking up during last night?', status: false, type: 'likert', low: 'Less than normal', high: 'More than normal'),
    Question(question: 'How often do you remember waking up last night?', status: false, type: 'slider', low: '', high: '', data: '0'),
    Question(question: 'How well rested did you feel after waking up today?', status: false, type: 'likert', low: 'Less rest than normal', high: 'More rest than normal', data: null),
    Question(question: 'On the scale of 0-10, how would you rate the quality of your sleep last night?', status: false, type: 'slider', low: 'Very poor', high: 'Very good', data: '0'),
    Question(question: 'How would you rate your low back pain on average during last night?', status: false, type: 'slider', low: 'No pain', high: 'Worst imaginable pain', data: '0'),
    Question(question: 'About last night, how did your pain affect your sleep and/or how did your sleep affect your pain?', status: false, type: 'notes', low: '', high: '', data: null),
    Question(question: 'Was your sleep disturbed by any factors? If so, list them here (e.g. noise, pain, pets, etc.)', status: false, type: 'notes', low: '', high: '', data: null)
  ];

  dynamic nextQuestion(){
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

  int questionNumber() {
    return _questionNumber;
  }

  bool lastQuestion() {
    return _questionNumber == _questionList.length - 1;
  }

  Question getQuestion(){
    return _questionList[_questionNumber];
  }

  int getQuestionnaireLength() {
    return _questionList.length;
  }

  List<Question> getQuestions() {
    return _questionList;
  }

  int startOver(){
    return _questionNumber = 0;
  }

}