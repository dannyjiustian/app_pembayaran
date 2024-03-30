import 'package:json_annotation/json_annotation.dart';

part 'ValidateTxEth.g.dart';

@JsonSerializable(explicitToJson: true)
class ValidateTxEth {
  final bool status;
  final String message;

  ValidateTxEth({
    required this.status,
    required this.message,
  });
  factory ValidateTxEth.fromJson(Map<String, dynamic> json) => _$ValidateTxEthFromJson(json);
  Map<String, dynamic> toJson() => _$ValidateTxEthToJson(this);
}
