import 'package:json_annotation/json_annotation.dart';

part 'DataLogin.g.dart';

@JsonSerializable()
class DataLogin {
  final String? username, accessToken, refreshToken;

  DataLogin({
    this.username,
    this.accessToken,
    this.refreshToken,
  });

  factory DataLogin.fromJson(Map<String, dynamic> json) =>
      _$DataLoginFromJson(json);

  Map<String, dynamic> toJson() => _$DataLoginToJson(this);
}
