// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataUpdateReader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataUpdateReader _$DataUpdateReaderFromJson(Map<String, dynamic> json) =>
    DataUpdateReader(
      name: json['name'] as String?,
      is_active: json['is_active'] as bool,
    );

Map<String, dynamic> _$DataUpdateReaderToJson(DataUpdateReader instance) {
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
