import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class FakeAccountFactory {
  static Map makeApiJson() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  static AccountEntity makeEntities() =>
      AccountEntity(token: faker.guid.guid());
}
