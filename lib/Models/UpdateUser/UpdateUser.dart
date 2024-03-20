import 'package:json_annotation/json_annotation.dart';

part 'UpdateUser.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateUser {
  final String id_user, name, username, email;

  UpdateUser({
    required this.id_user,
    required this.name,
    required this.username,
    required this.email,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserToJson(this);
}
