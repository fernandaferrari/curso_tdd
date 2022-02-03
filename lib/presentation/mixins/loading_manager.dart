import 'package:get/get.dart';

mixin LoadingManager on GetxController {
  final _isLoad = true.obs;
  Stream<bool> get isLoadStream => _isLoad.stream;
  set isLoading(bool value) => _isLoad.value = value;
}
