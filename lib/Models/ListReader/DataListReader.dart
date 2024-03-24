import 'package:json_annotation/json_annotation.dart';

import '../DetailTransaction/DataDetailTransaction.dart';

part 'DataListReader.g.dart';

@JsonSerializable()
class DataListReader {
  final String id_hardware, id_user, created_at, updated_at, sn_sensor, name;
  final bool is_active;
  final List<DataDetailTransaction> transactions;

  DataListReader({
    required this.id_hardware,
    required this.id_user,
    required this.sn_sensor,
    required this.name,
    required this.is_active,
    required this.created_at,
    required this.updated_at,
    required this.transactions,
  });

  factory DataListReader.fromJson(Map<String, dynamic> json) =>
      _$DataListReaderFromJson(json);

  Map<String, dynamic> toJson() => _$DataListReaderToJson(this);
}
