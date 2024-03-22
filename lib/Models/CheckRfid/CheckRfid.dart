import 'package:json_annotation/json_annotation.dart';
part 'CheckRfid.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckRfid {
  final bool status;
  final String message;

  CheckRfid({
    required this.status,
    required this.message,
  });
  factory CheckRfid.fromJson(Map<String, dynamic> json) =>
      _$CheckRfidFromJson(json);
  Map<String, dynamic> toJson() => _$CheckRfidToJson(this);
}
