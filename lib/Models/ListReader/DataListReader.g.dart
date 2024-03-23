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
      updated_at: json['updated_at'] as String,
    );

Map<String, dynamic> _$DataListReaderToJson(DataListReader instance) =>
    <String, dynamic>{
      'id_hardware': instance.id_hardware,
      'id_user': instance.id_user,
      'updated_at': instance.updated_at,
      'sn_sensor': instance.sn_sensor,
      'name': instance.name,
      'is_active': instance.is_active,
    };
