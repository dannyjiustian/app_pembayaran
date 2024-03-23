import 'package:json_annotation/json_annotation.dart';

import 'DataOutletData.dart';

part 'OutletData.g.dart';

@JsonSerializable(explicitToJson: true)
class OutletData {
  final bool status;
  final String message;
  final DataOutletData? data;

  OutletData({
    required this.status,
    required this.message,
    this.data,
  });
  factory OutletData.fromJson(Map<String, dynamic> json) => _$OutletDataFromJson(json);
  Map<String, dynamic> toJson() => _$OutletDataToJson(this);
}
