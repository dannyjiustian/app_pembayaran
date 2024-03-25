// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataReader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataReader _$DataReaderFromJson(Map<String, dynamic> json) => DataReader(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataDataReader.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataReaderToJson(DataReader instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
