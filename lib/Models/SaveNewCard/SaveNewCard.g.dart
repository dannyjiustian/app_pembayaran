// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SaveNewCard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveNewCard _$SaveNewCardFromJson(Map<String, dynamic> json) => SaveNewCard(
      id_user: json['id_user'] as String,
      id_rfid: json['id_rfid'] as String,
      balance: json['balance'] as String,
    );

Map<String, dynamic> _$SaveNewCardToJson(SaveNewCard instance) =>
    <String, dynamic>{
      'id_user': instance.id_user,
      'id_rfid': instance.id_rfid,
      'balance': instance.balance,
    };
