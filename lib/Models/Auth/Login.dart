import 'package:json_annotation/json_annotation.dart';

import 'DataLogin.dart';

part 'Login.g.dart';

@JsonSerializable(explicitToJson: true)
class Login {
  final bool status;
  final String message;
  final DataLogin? data;

  Login({
    required this.status,
    required this.message,
    this.data,
  });

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
