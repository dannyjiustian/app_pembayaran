// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateReaderString.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReaderString _$UpdateReaderStringFromJson(Map<String, dynamic> json) =>
    UpdateReaderString(
      name: json['name'] as String?,
      is_active: json['is_active'] as String,
    );

Map<String, dynamic> _$UpdateReaderStringToJson(UpdateReaderString instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  val['is_active'] = instance.is_active;
  return val;
}
