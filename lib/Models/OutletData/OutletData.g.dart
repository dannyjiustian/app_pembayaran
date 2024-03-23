// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OutletData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutletData _$OutletDataFromJson(Map<String, dynamic> json) => OutletData(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : DataOutletData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutletDataToJson(OutletData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
