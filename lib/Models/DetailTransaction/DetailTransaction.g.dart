// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DetailTransaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailTransaction _$DetailTransactionFromJson(Map<String, dynamic> json) =>
    DetailTransaction(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataDetailTransaction.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailTransactionToJson(DetailTransaction instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
