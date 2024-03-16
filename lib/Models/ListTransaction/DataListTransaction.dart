import 'package:json_annotation/json_annotation.dart';

part 'DataListTransaction.g.dart';

@JsonSerializable()
class DataListTransaction {
  final String id_transaction, id_card, id_user, id_hardware, id_outlet, updated_at, status;
  final String? txn_hash;
  final int total_payment, type;

  DataListTransaction({
    required this.id_transaction,
    required this.id_card,
    required this.id_user,
    required this.id_hardware,
    required this.id_outlet,
    this.txn_hash,
    required this.total_payment,
    required this.type,
    required this.status,
    required this.updated_at,
  });

  factory DataListTransaction.fromJson(Map<String, dynamic> json) =>
      _$DataListTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$DataListTransactionToJson(this);
}
