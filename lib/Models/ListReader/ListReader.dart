import 'package:json_annotation/json_annotation.dart';

import 'DataListReader.dart';

part 'ListReader.g.dart';

@JsonSerializable(explicitToJson: true)
class ListReader {
  final bool status;
  final String message;
  final List<DataListReader>? data;

  ListReader({
    required this.status,
    required this.message,
    this.data,
  });
  factory ListReader.fromJson(Map<String, dynamic> json) => _$ListReaderFromJson(json);
  Map<String, dynamic> toJson() => _$ListReaderToJson(this);
}
