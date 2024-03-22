import 'package:json_annotation/json_annotation.dart';

part 'CreateTransaction.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class CreateTransaction {
  final String id_card, id_user, total_payment, type;
  final String? txn_hash, id_hardware, id_outlet, status;

  CreateTransaction({
    required this.id_card,
    required this.id_user,
    this.id_hardware,
    this.id_outlet,
    this.txn_hash,
    required this.total_payment,
    required this.type,
    this.status,
  });
  factory CreateTransaction.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionToJson(this);
}
