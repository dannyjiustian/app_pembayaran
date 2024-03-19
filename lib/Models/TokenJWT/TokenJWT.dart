import 'package:json_annotation/json_annotation.dart';

import 'DataToken.dart';

part 'TokenJWT.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenJWT {
  final bool status;
  final String message;
  final DataToken? data;

  TokenJWT({
    required this.status,
    required this.message,
    this.data,
  });
  factory TokenJWT.fromJson(Map<String, dynamic> json) => _$TokenJWTFromJson(json);
  Map<String, dynamic> toJson() => _$TokenJWTToJson(this);
}
