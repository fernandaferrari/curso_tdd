import 'package:curso_tdd/infra/cache/cache.dart';
import 'package:localstorage/localstorage.dart';

LocalStorageAdapter makeLocalStorageAdapter() =>
    LocalStorageAdapter(localStorage: LocalStorage('fordev'));
