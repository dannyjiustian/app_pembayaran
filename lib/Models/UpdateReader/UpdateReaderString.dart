import 'package:json_annotation/json_annotation.dart';

part 'UpdateReaderString.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UpdateReaderString {
  final String? name;
  final String is_active;

  UpdateReaderString({
    this.name,
    required this.is_active,
  });

  factory UpdateReaderString.fromJson(Map<String, dynamic> json) =>
      _$UpdateReaderStringFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateReaderStringToJson(this);
}
