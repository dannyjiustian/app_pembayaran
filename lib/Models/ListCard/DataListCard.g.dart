// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataListCard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataListCard _$DataListCardFromJson(Map<String, dynamic> json) => DataListCard(
      id_card: json['id_card'] as String,
      id_user: json['id_user'] as String,
      id_rfid: json['id_rfid'] as String,
      wallet_address: json['wallet_address'] as String,
      balance_eth: (json['balance_eth'] as num).toDouble(),
      balance: json['balance'] as int,
      is_active: json['is_active'] as bool,
      created_at: json['created_at'] as String,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map(
              (e) => DataDetailTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataListCardToJson(DataListCard instance) =>
    <String, dynamic>{
      'id_card': instance.id_card,
      'id_user': instance.id_user,
      'id_rfid': instance.id_rfid,
      'wallet_address': instance.wallet_address,
      'created_at': instance.created_at,
      'balance': instance.balance,
      'balance_eth': instance.balance_eth,
      'is_active': instance.is_active,
      'transactions': instance.transactions,
    };
