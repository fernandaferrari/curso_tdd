import 'package:curso_tdd/domain/entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> load();
}
