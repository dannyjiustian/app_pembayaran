import 'package:json_annotation/json_annotation.dart';

part 'DataOutletData.g.dart';

@JsonSerializable()
class DataOutletData {
  final String id_outlet, updated_at, smart_contract, wallet_address;
  final int balance;
  final double balance_eth;

  DataOutletData({
    required this.id_outlet,
    required this.updated_at,
    required this.smart_contract,
    required this.balance,
    required this.wallet_address,
    required this.balance_eth,
  });

  factory DataOutletData.fromJson(Map<String, dynamic> json) =>
      _$DataOutletDataFromJson(json);

  Map<String, dynamic> toJson() => _$DataOutletDataToJson(this);
}
