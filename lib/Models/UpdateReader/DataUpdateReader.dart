import 'package:json_annotation/json_annotation.dart';

part 'DataUpdateReader.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class DataUpdateReader {
  final String? name;
  final bool is_active;

  DataUpdateReader({
    this.name,
    required this.is_active,
  });

  factory DataUpdateReader.fromJson(Map<String, dynamic> json) =>
      _$DataUpdateReaderFromJson(json);

  Map<String, dynamic> toJson() => _$DataUpdateReaderToJson(this);
}
