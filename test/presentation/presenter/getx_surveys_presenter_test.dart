import 'package:curso_tdd/domain/entities/survey_entity.dart';
import 'package:curso_tdd/domain/usecases/load_surveys.dart';
import 'package:curso_tdd/presentation/presenter/getx_surveys_presenter.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveysStream;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2021, 2, 10),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2022, 1, 10),
            didAnswer: false)
      ];

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    when(loadSurveysStream.load()).thenAnswer((_) async => data);
  }

  setUp(() {
    loadSurveysStream = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveysStream: loadSurveysStream);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveysStream.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveysViewModel(
              id: surveys[0].id,
              question: surveys[0].question,
              date: '10 Fev 2021',
              didAnswer: surveys[0].didAnswer),
          SurveysViewModel(
              id: surveys[1].id,
              question: surveys[1].question,
              date: '10 Jan 2022',
              didAnswer: surveys[1].didAnswer),
        ])));

    await sut.loadData();
  });
}
