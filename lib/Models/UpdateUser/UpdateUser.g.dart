// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUser _$UpdateUserFromJson(Map<String, dynamic> json) => UpdateUser(
      id_user: json['id_user'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UpdateUserToJson(UpdateUser instance) =>
    <String, dynamic>{
      'id_user': instance.id_user,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
    };
