import 'package:json_annotation/json_annotation.dart';

import 'DataUpdateReader.dart';

part 'UpdateReader.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateReader {
  final bool status;
  final String message;
  final DataUpdateReader? data;

  UpdateReader({
    required this.status,
    required this.message,
    this.data,
  });
  factory UpdateReader.fromJson(Map<String, dynamic> json) => _$UpdateReaderFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateReaderToJson(this);
}
