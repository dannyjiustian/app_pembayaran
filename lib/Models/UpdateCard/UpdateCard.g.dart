// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateCard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCard _$UpdateCardFromJson(Map<String, dynamic> json) => UpdateCard(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataUpdateCard.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateCardToJson(UpdateCard instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
