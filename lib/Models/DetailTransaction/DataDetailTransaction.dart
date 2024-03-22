import 'package:json_annotation/json_annotation.dart';

part 'DataDetailTransaction.g.dart';

@JsonSerializable()
class DataDetailTransaction {
  final String id_transaction, id_card, id_user, updated_at, status;
  final String? txn_hash, id_hardware, id_outlet;
  final int total_payment, type;

  DataDetailTransaction({
    required this.id_transaction,
    required this.id_card,
    required this.id_user,
    this.id_hardware,
    this.id_outlet,
    this.txn_hash,
    required this.total_payment,
    required this.type,
    required this.status,
    required this.updated_at,
  });

  factory DataDetailTransaction.fromJson(Map<String, dynamic> json) =>
      _$DataDetailTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$DataDetailTransactionToJson(this);
}
