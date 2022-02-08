import 'package:curso_tdd/ui/pages/pages.dart';

class ViewModelFactory {
  static List<SurveysViewModel> makeSurveys() => [
        SurveysViewModel(
            id: '1', question: 'Question 1', date: 'Any Date', didAnswer: true),
        SurveysViewModel(
            id: '2', question: 'Question 2', date: 'Any Date', didAnswer: false)
      ];

  static SurveysResultViewModel makeSurveyResult() => SurveysResultViewModel(
          surveyId: 'Any id',
          question: 'Question',
          answers: [
            SurveyAnswerViewModel(
                image: 'Image 0',
                answer: 'Answer 0',
                isCurrentAnswer: true,
                percent: '60%'),
            SurveyAnswerViewModel(
                answer: 'Answer 1', isCurrentAnswer: false, percent: '40%')
          ]);
}
