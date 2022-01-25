import 'package:curso_tdd/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageSpy localStorage;
  LocalStoraAdapter sut;
  String key;
  dynamic value;

  PostExpectation mockDeleteCall() => when(localStorage.deleteItem(any));
  void mockExceptionDelete() => mockDeleteCall().thenThrow(Exception);

  PostExpectation mockSetCall() => when(localStorage.setItem(any, any));
  void mockExceptionSet() => mockSetCall().thenThrow(Exception);

  PostExpectation mockGetCall() => when(localStorage.getItem(any));
  void mockExceptionGet() => mockGetCall().thenThrow(Exception);

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStoraAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
  });

  group('save', () {
    test('Should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockExceptionDelete();
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(Exception));
    });

    test('Should throw if setItem throws', () async {
      mockExceptionSet();
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(Exception));
    });
  });

  group('delete', () {
    test('Should call localStorage with correct values', () async {
      await sut.delete(key);

      verify(localStorage.deleteItem(key)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockExceptionDelete();
      final future = sut.delete(key);

      expect(future, throwsA(Exception));
    });
  });

  group('fetch', () {
    test('Should call localStorage with correct values', () async {
      await sut.fetch(key);

      verify(localStorage.getItem(key)).called(1);
    });

    test('Should throw if fetch throws', () async {
      mockExceptionGet();
      final future = sut.fetch(key);

      expect(future, throwsA(Exception));
    });
  });
}
