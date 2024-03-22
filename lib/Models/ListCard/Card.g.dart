// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataListCard.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
