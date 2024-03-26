import 'package:json_annotation/json_annotation.dart';

part 'MQTTResponse.g.dart';

@JsonSerializable(explicitToJson: true)
class MQTTResponse {
  final bool status;
  final String message;
  final int code;

  MQTTResponse({
    required this.status,
    required this.message,
    required this.code,
  });
  factory MQTTResponse.fromJson(Map<String, dynamic> json) =>
      _$MQTTResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MQTTResponseToJson(this);
}
