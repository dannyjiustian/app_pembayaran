// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CreateReader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReader _$CreateReaderFromJson(Map<String, dynamic> json) => CreateReader(
      id_user: json['id_user'] as String,
      name: json['name'] as String,
      sn_sensor: json['sn_sensor'] as String,
      is_active: json['is_active'] as String,
    );

Map<String, dynamic> _$CreateReaderToJson(CreateReader instance) =>
    <String, dynamic>{
      'id_user': instance.id_user,
      'is_active': instance.is_active,
      'name': instance.name,
      'sn_sensor': instance.sn_sensor,
    };
