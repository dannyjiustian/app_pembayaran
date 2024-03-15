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
      balance: json['balance'] as int,
    );

Map<String, dynamic> _$DataListCardToJson(DataListCard instance) =>
    <String, dynamic>{
      'id_card': instance.id_card,
      'id_user': instance.id_user,
      'id_rfid': instance.id_rfid,
      'wallet_address': instance.wallet_address,
      'balance': instance.balance,
    };
