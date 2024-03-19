import 'package:json_annotation/json_annotation.dart';

part 'DataToken.g.dart';

@JsonSerializable()
class DataToken {
  final String accessToken, refreshToken;

  DataToken({
    required this.accessToken,
    required this.refreshToken,
  });

  factory DataToken.fromJson(Map<String, dynamic> json) =>
      _$DataTokenFromJson(json);

  Map<String, dynamic> toJson() => _$DataTokenToJson(this);
}
