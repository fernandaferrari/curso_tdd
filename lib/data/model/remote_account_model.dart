import '../http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String acessToken;

  RemoteAccountModel(this.acessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('acessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['acessToken']);
  }

  AccountEntity toEntity() => AccountEntity(acessToken);
}
