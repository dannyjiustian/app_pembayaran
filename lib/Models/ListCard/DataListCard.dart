import 'package:json_annotation/json_annotation.dart';

import '../DetailTransaction/DataDetailTransaction.dart';

part 'DataListCard.g.dart';

@JsonSerializable()
class DataListCard {
  final String id_card, id_user, id_rfid, wallet_address, created_at;
  final int balance;
  final double balance_eth;
  final bool is_active;
  final List<DataDetailTransaction>? transactions;

  DataListCard({
    required this.id_card,
    required this.id_user,
    required this.id_rfid,
    required this.wallet_address,
    required this.balance_eth,
    required this.balance,
    required this.is_active,
    required this.created_at,
    this.transactions,
  });

  factory DataListCard.fromJson(Map<String, dynamic> json) =>
      _$DataListCardFromJson(json);

  Map<String, dynamic> toJson() => _$DataListCardToJson(this);
}
