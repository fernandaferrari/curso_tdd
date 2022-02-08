import 'package:curso_tdd/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';

void main() {
  late SecureStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
    secureStorage.mockFetchSecure(value);
  });

  group('save', () {
    test('Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      secureStorage.mockSaveSecureError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    test('Should call fetch secure with correct value', () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetch secure throws', () async {
      secureStorage.mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if delete throws', () async {
      secureStorage.mockDeleteSecureError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
