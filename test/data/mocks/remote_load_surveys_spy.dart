import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {
  When mockRemoteLoadCall() => when(() => load());

  void mockRemoteLoad(List<SurveyEntity> remoteSurveys) =>
      mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);
}
