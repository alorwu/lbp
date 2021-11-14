
import 'PromisQuestion.dart';

class PromisQuestionnaire {

  int _questionNumber = 0;

  List<PromisQuestion> _questionList = [
    PromisQuestion(
        number: '1',
        question: 'In general, would you say your health is:',
        type: 'likert',
        data: null,
        one: 'Poor',
        two: 'Fair',
        three: 'Good',
        four: 'Very good',
        five: 'Excellent'
    ),
    PromisQuestion(
        number: '2',
        question: 'In general, would you say your quality of life is:',
        type: 'likert',
        data: null,
        one: 'Poor',
        two: 'Fair',
        three: 'Good',
        four: 'Very good',
        five: 'Excellent'
    ),
    PromisQuestion(
        number: '3',
        question: 'In general, how would you rate your physical health?',
        type: 'likert',
        data: null,
        one: 'Poor',
        two: 'Fair',
        three: 'Good',
        four: 'Very good',
        five: 'Excellent'
    ),
    PromisQuestion(
        number: '4',
        question: 'In general, how would you rate your mental health, including your mood and your ability to think?',
        type: 'likert',
        data: null,
        one: 'Poor',
        two: 'Fair',
        three: 'Good',
        four: 'Very good',
        five: 'Excellent'
    ),
    PromisQuestion(
        number: '5',
        question: 'In general, how would you rate your satisfaction with your social activities and relationships?',
        type: 'likert',
        data: null,
        one: 'Poor',
        two: 'Fair',
        three: 'Good',
        four: 'Very good',
        five: 'Excellent'
    ),
    PromisQuestion(
        number: '6',
        question: 'In general, please rate how well you carry out your usual social activities and roles. (e.g. activities at home and at work, and responsibilities as a parent, child, spouse, employee, etc.)',
        type: 'likert',
        data: null,
        one: 'Poor',
        two: 'Fair',
        three: 'Good',
        four: 'Very good',
        five: 'Excellent'
    ),
    PromisQuestion(
        number: '7',
        question: 'To what extent are you able to carry out your everyday physical activities such as walking, climbing stairs, carrying groceries, or moving a chair?',
        type: 'likert',
        data: null,
        one: 'Not at all',
        two: 'A little',
        three: 'Moderately',
        four: 'Mostly',
        five: 'Completely'
    ),
    PromisQuestion(
        number: '8',
        question: 'How often have you been bothered by emotional problems such as feeling anxious, depressed or irritable?',
        type: 'likert',
        data: null,
        one: 'Always',
        two: 'Often',
        three: 'Sometimes',
        four: 'Rarely',
        five: 'Never'
    ),
    PromisQuestion(
        number: '9',
        question: 'How would you rate your fatigue on average?',
        type: 'likert',
        data: null,
        one: 'Very severe',
        two: 'Severe',
        three: 'Moderate',
        four: 'Mild',
        five: 'None'
    ),
    PromisQuestion(
        number: '10',
        question: 'How would you rate your pain on average?',
        type: 'slider',
        data: '0',
        low: 'No pain',
        high: 'Worst imaginable pain'
    ),

  ];

  dynamic nextPromisQuestion() {
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

  PromisQuestion getPromisQuestion(){
    return _questionList[_questionNumber];
  }

  List<PromisQuestion> getPromisQuestions() {
    return _questionList;
  }

  int getQuestionnaireLength() {
    return _questionList.length;
  }

}