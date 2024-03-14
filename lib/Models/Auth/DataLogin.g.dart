// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataLogin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataLogin _$DataLoginFromJson(Map<String, dynamic> json) => DataLogin(
      username: json['username'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$DataLoginToJson(DataLogin instance) => <String, dynamic>{
      'username': instance.username,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
