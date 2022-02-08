import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:curso_tdd/domain/usecases/load_current_account.dart';

import '../../domain/mocks/mocks.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetxSplashPresenter sut;

  When mockLoadCurrentCall() => when(() => loadCurrentAccount.load());

  void mockLoadCurrentAccount({required AccountEntity account}) {
    mockLoadCurrentCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentCall().thenThrow(Exception);
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: EntityFactory.makeAccount());
  });

  test('Should go to surveys page on sucess', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount();
  });

  test('should go to login page on error', () async {
    mockLoadCurrentAccountError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount();
  });
}
