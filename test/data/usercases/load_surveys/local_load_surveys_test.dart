import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;
  LocalLoadSurveys({
    @required this.fetchCacheStorage,
  });

  Future<void> load() async {
    await fetchCacheStorage.fetch('surveys');
  }
}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {
  FetchCacheStorageSpy fetchCacheStorage;
  LocalLoadSurveys sut;
  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
  });
  test('Should call FetchCachaStorage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });
}
