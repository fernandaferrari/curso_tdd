import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

class LocalStoraAdapter {
  final LocalStorage localStorage;
  LocalStoraAdapter({
    @required this.localStorage,
  });

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

void main() {
  LocalStorageSpy localStorage;
  LocalStoraAdapter sut;
  String key;
  String value;

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStoraAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
  });
  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorage.setItem(key, value)).called(1);
  });
}
