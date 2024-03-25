// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataDataReader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataDataReader _$DataDataReaderFromJson(Map<String, dynamic> json) =>
    DataDataReader(
      id_user: json['id_user'] as String,
      id_hardware: json['id_hardware'] as String,
      name: json['name'] as String,
      sn_sensor: json['sn_sensor'] as String,
      is_active: json['is_active'] as bool,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );

Map<String, dynamic> _$DataDataReaderToJson(DataDataReader instance) =>
    <String, dynamic>{
      'id_user': instance.id_user,
      'id_hardware': instance.id_hardware,
      'name': instance.name,
      'sn_sensor': instance.sn_sensor,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'is_active': instance.is_active,
    };
