// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListReader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListReader _$ListReaderFromJson(Map<String, dynamic> json) => ListReader(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataListReader.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListReaderToJson(ListReader instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };
