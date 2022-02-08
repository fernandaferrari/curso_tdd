import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AuthenticationSpy extends Mock implements IAuthentication {
  When mockAuthenticationCall() => when(() => auth(any()));

  void mockAuthentication(AccountEntity data) =>
      mockAuthenticationCall().thenAnswer((_) async => data);

  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);
}
