// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataDetailTransaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataDetailTransaction _$DataDetailTransactionFromJson(
        Map<String, dynamic> json) =>
    DataDetailTransaction(
      id_transaction: json['id_transaction'] as String,
      id_card: json['id_card'] as String,
      id_user: json['id_user'] as String,
      id_hardware: json['id_hardware'] as String?,
      id_outlet: json['id_outlet'] as String?,
      txn_hash: json['txn_hash'] as String?,
      total_payment: json['total_payment'] as int,
      type: json['type'] as int,
      status: json['status'] as String,
      updated_at: json['updated_at'] as String,
    );

Map<String, dynamic> _$DataDetailTransactionToJson(
        DataDetailTransaction instance) =>
    <String, dynamic>{
      'id_transaction': instance.id_transaction,
      'id_card': instance.id_card,
      'id_user': instance.id_user,
      'updated_at': instance.updated_at,
      'status': instance.status,
      'txn_hash': instance.txn_hash,
      'id_hardware': instance.id_hardware,
      'id_outlet': instance.id_outlet,
      'total_payment': instance.total_payment,
      'type': instance.type,
    };
