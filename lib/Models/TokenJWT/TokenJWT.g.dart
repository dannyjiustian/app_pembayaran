// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TokenJWT.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenJWT _$TokenJWTFromJson(Map<String, dynamic> json) => TokenJWT(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataToken.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenJWTToJson(TokenJWT instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
