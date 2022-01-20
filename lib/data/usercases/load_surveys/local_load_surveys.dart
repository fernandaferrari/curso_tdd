import 'package:curso_tdd/data/cache/cache.dart';
import 'package:curso_tdd/data/model/model.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/load_surveys.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;
  LocalLoadSurveys({
    @required this.cacheStorage,
  });

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return _map(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      _map(data);
    } catch (error) {
      await cacheStorage.delete('surveys');
    }
  }

  List<SurveyEntity> _map(List<Map> list) => list
      .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
      .toList();
}
