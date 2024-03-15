// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListCard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCard _$ListCardFromJson(Map<String, dynamic> json) => ListCard(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataListCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListCardToJson(ListCard instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };
