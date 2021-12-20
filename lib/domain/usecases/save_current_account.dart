import 'package:curso_tdd/domain/entities/account_entity.dart';

abstract class ISaveCurrentAccount {
  Future<void> save(AccountEntity account);
}
