import 'package:json_annotation/json_annotation.dart';

part 'DataDataReader.g.dart';

@JsonSerializable()
class DataDataReader{
  final String id_user, id_hardware, name, sn_sensor, created_at, updated_at;
  final bool is_active;

  DataDataReader({
    required this.id_user,
    required this.id_hardware,
    required this.name,
    required this.sn_sensor,
    required this.is_active,
    required this.created_at,
    required this.updated_at,
  });

  factory DataDataReader.fromJson(Map<String, dynamic> json) =>
      _$DataDataReaderFromJson(json);

  Map<String, dynamic> toJson() => _$DataDataReaderToJson(this);
}
