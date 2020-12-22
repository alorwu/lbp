import 'package:lbp/model/Question.dart';

class Questionnaire {

  int _questionNumber = 0;

// this List variable will store our questions 
// and answers as specified in the questions class

  List<Question> _questionList = [
    Question(question: 'How well do you feel this morning?'),
    Question(question: 'What is the intensity of your low back pain today?'),
    // Question(question: 'You are using this app right now, you\'ve got no choice', answer: true),
    // Question(question: 'You are in a relationship', answer: false),
    // Question(question: 'Gin is typically included in a Long Island Iced Tea', answer: true),
    // Question(question: 'Monaco is the smallest country in the world', answer: false),
    // Question(question: 'Australia is wider than the moon', answer: true),
    // Question(question: 'Queen Elizabeth II is currently the second longest reigning British monarch', answer: false),
  ];

// this function will access the question number and increment it
// also it will let us know if the questions have been completed
  dynamic nextQuestion(){
    if(_questionNumber < _questionList.length - 1){
      print(_questionNumber);
      _questionNumber++;
    }else{
      bool completed = true;
      return completed;
    }
  }

// this function will return the question text of the 
//specific question number text when called in the main.dart
  String getQuestionText(){
    return _questionList[_questionNumber].question;
  }

// this function will return the answer of the 
//specific question number when called in the main.dart
  bool getQuestionAnswer(){
    return _questionList[_questionNumber].answer;
  }

// this function will set the question 
//number back the 0 when the quiz is restarted
  int startOver(){
    return _questionNumber = 0;
  }

}