import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;
  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
  });

  Future<void> load() async {
    await remote.load();
  }
}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });
}
