// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JWTDecode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWTDecode _$JWTDecodeFromJson(Map<String, dynamic> json) => JWTDecode(
      id_user: json['id_user'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$JWTDecodeToJson(JWTDecode instance) => <String, dynamic>{
      'id_user': instance.id_user,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };
