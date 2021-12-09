import 'package:curso_tdd/domain/entities/entities.dart';

class RemoteAccountModel {
  final String acessToken;

  RemoteAccountModel(this.acessToken);

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(json['acessToken']);

  AccountEntity toEntity() => AccountEntity(acessToken);
}
