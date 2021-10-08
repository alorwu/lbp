import 'package:lbp/model/daily/Question.dart';

class Questionnaire {

  int _questionNumber = 0;

// this List variable will store our questions 
// and answers as specified in the questions class

  List<Question> _questionList = [
    Question(question: 'At what time did you sleep last night?', status: false, type: 'date_picker', low: '', high: ''),
    Question(question: 'At what time did you wake up this morning?', status: false, type: 'date_picker', low: '', high: ''),
    // Question(question: 'At what time did you fall asleep yesterday?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    // Question(question: 'At what time did you wake up and leave the bed this morning?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    // Question(question: 'Compared to other days, how long did it take you to fall asleep yesterday?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    // Question(question: 'Compared to other days, how early did you wake up and leave the bed this morning?', status: false, type: 'likert', low: 'Earlier than normal', high: 'Later than normal'),
    Question(question: 'How long did it take to fall asleep after you went to bed yesterday?', status: false, type: 'likert', low: 'Less time than normal', high: 'More time than normal'),
    // Question(question: 'How often do you remember waking up during last night?', status: false, type: 'likert', low: 'Less than normal', high: 'More than normal'),
    Question(question: 'How often do you remember waking up during last night?', status: false, type: 'slider', low: '', high: ''),
    Question(question: 'How well rested did you feel after waking up today?', status: false, type: 'likert', low: 'Less rest than normal', high: 'More rest than normal'),
    Question(question: 'On the scale of 0-10, how would you rate the quality of your sleep last night?', status: false, type: 'slider', low: 'Very poor', high: 'Very goof'),
    Question(question: 'How would you rate your low back pain on average during last night?', status: false, type: 'slider', low: 'No pain', high: 'Worst imaginable pain'),
  ];

// this function will access the question number and increment it
// also it will let us know if the questions have been completed
  dynamic nextQuestion(){
    if(_questionNumber < _questionList.length - 1){
      _questionNumber++;
    }else{
      bool completed = true;
      return completed;
    }
  }

// this function will return the question text of the 
//specific question number text when called in the main.dart
  Question getQuestion(){
    return _questionList[_questionNumber];
  }

// this function will return the answer of the 
//specific question number when called in the main.dart
  bool getQuestionAnswer(){
    return _questionList[_questionNumber].status;
  }


  void setQuestionStatus(bool status) {
     _questionList[_questionNumber].status = status;
  }

// this function will set the question 
//number back the 0 when the quiz is restarted
  int startOver(){
    return _questionNumber = 0;
  }

}