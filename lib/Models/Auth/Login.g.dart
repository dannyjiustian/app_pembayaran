// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) => Login(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataLogin.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
