// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataOutletData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataOutletData _$DataOutletDataFromJson(Map<String, dynamic> json) =>
    DataOutletData(
      id_outlet: json['id_outlet'] as String,
      updated_at: json['updated_at'] as String,
      smart_contract: json['smart_contract'] as String,
      balance: json['balance'] as int,
      wallet_address: json['wallet_address'] as String,
      balance_eth: (json['balance_eth'] as num).toDouble(),
    );

Map<String, dynamic> _$DataOutletDataToJson(DataOutletData instance) =>
    <String, dynamic>{
      'id_outlet': instance.id_outlet,
      'updated_at': instance.updated_at,
      'smart_contract': instance.smart_contract,
      'wallet_address': instance.wallet_address,
      'balance': instance.balance,
      'balance_eth': instance.balance_eth,
    };
