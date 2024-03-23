import 'package:json_annotation/json_annotation.dart';

part 'DataListReader.g.dart';

@JsonSerializable()
class DataListReader {
  final String id_hardware, id_user, updated_at, sn_sensor, name;
  final bool is_active;

  DataListReader({
    required this.id_hardware,
    required this.id_user,
    required this.sn_sensor,
    required this.name,
    required this.is_active,
    required this.updated_at,
  });

  factory DataListReader.fromJson(Map<String, dynamic> json) =>
      _$DataListReaderFromJson(json);

  Map<String, dynamic> toJson() => _$DataListReaderToJson(this);
}
