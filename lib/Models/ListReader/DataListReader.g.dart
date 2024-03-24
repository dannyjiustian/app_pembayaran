// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataListReader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataListReader _$DataListReaderFromJson(Map<String, dynamic> json) =>
    DataListReader(
      id_hardware: json['id_hardware'] as String,
      id_user: json['id_user'] as String,
      sn_sensor: json['sn_sensor'] as String,
      name: json['name'] as String,
      is_active: json['is_active'] as bool,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => DataDetailTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataListReaderToJson(DataListReader instance) =>
    <String, dynamic>{
      'id_hardware': instance.id_hardware,
      'id_user': instance.id_user,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'sn_sensor': instance.sn_sensor,
      'name': instance.name,
      'is_active': instance.is_active,
      'transactions': instance.transactions,
    };
