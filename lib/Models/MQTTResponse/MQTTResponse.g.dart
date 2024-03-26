// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MQTTResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MQTTResponse _$MQTTResponseFromJson(Map<String, dynamic> json) => MQTTResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
    );

Map<String, dynamic> _$MQTTResponseToJson(MQTTResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
    };
