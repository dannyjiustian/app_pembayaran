import 'package:json_annotation/json_annotation.dart';

import 'DataDataReader.dart';

part 'DataReader.g.dart';

@JsonSerializable(explicitToJson: true)
class DataReader {
  final bool status;
  final String message;
  final DataDataReader? data;

  DataReader({
    required this.status,
    required this.message,
    this.data,
  });
  factory DataReader.fromJson(Map<String, dynamic> json) => _$DataReaderFromJson(json);
  Map<String, dynamic> toJson() => _$DataReaderToJson(this);
}
