import 'package:curso_tdd/data/cache/cache.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

class LocalStoraAdapter implements CacheStorage {
  final LocalStorage localStorage;
  LocalStoraAdapter({
    @required this.localStorage,
  });

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }

  Future<void> delete(String key) async {
    await localStorage.deleteItem(key);
  }

  Future<dynamic> fetch(String key) async {
    await localStorage.getItem(key);
  }
}
