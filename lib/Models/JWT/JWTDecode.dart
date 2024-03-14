import 'package:json_annotation/json_annotation.dart';

part 'JWTDecode.g.dart';

@JsonSerializable(explicitToJson: true)
class JWTDecode {
  final String id_user;
  final String name;
  final String email;
  final String role;

  JWTDecode({
    required this.id_user,
    required this.name,
    required this.email,
    required this.role,
  });

  factory JWTDecode.fromJson(Map<String, dynamic> json) =>
      _$JWTDecodeFromJson(json);
  Map<String, dynamic> toJson() => _$JWTDecodeToJson(this);
}
