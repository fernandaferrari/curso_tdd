import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AddAccountSpy extends Mock implements AddAccount {
  When mockAddAccountCall() => when(() => add(any()));
  void mockAddAccount(AccountEntity data) =>
      mockAddAccountCall().thenAnswer((_) async => data);
  void mockAddAccountError(DomainError error) =>
      mockAddAccountCall().thenThrow(error);
}
