import 'package:json_annotation/json_annotation.dart';

part 'DataOutletData.g.dart';

@JsonSerializable()
class DataOutletData {
  final String id_outlet, updated_at, smart_contract;
  final int balance;

  DataOutletData({
    required this.id_outlet,
    required this.updated_at,
    required this.smart_contract,
    required this.balance,
  });

  factory DataOutletData.fromJson(Map<String, dynamic> json) =>
      _$DataOutletDataFromJson(json);

  Map<String, dynamic> toJson() => _$DataOutletDataToJson(this);
}
