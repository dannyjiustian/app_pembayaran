// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateReader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReader _$UpdateReaderFromJson(Map<String, dynamic> json) => UpdateReader(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataUpdateReader.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateReaderToJson(UpdateReader instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
