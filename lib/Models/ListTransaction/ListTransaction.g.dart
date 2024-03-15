// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListTransaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransaction _$ListTransactionFromJson(Map<String, dynamic> json) =>
    ListTransaction(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataListTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListTransactionToJson(ListTransaction instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };
