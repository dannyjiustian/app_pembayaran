import 'package:json_annotation/json_annotation.dart';

part 'CreateReader.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class CreateReader {
  final String id_user, is_active, name, sn_sensor;

  CreateReader({
    required this.id_user,
    required this.name,
    required this.sn_sensor,
    required this.is_active,
  });
  factory CreateReader.fromJson(Map<String, dynamic> json) =>
      _$CreateReaderFromJson(json);
  Map<String, dynamic> toJson() => _$CreateReaderToJson(this);
}
