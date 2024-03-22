// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CreateTransaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTransaction _$CreateTransactionFromJson(Map<String, dynamic> json) =>
    CreateTransaction(
      id_card: json['id_card'] as String,
      id_user: json['id_user'] as String,
      id_hardware: json['id_hardware'] as String?,
      id_outlet: json['id_outlet'] as String?,
      txn_hash: json['txn_hash'] as String?,
      total_payment: json['total_payment'] as String,
      type: json['type'] as String,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$CreateTransactionToJson(CreateTransaction instance) {
  final val = <String, dynamic>{
    'id_card': instance.id_card,
    'id_user': instance.id_user,
    'total_payment': instance.total_payment,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('txn_hash', instance.txn_hash);
  writeNotNull('id_hardware', instance.id_hardware);
  writeNotNull('id_outlet', instance.id_outlet);
  writeNotNull('status', instance.status);
  return val;
}
