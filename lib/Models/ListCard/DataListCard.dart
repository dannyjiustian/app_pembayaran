import 'package:json_annotation/json_annotation.dart';

part 'DataListCard.g.dart';

@JsonSerializable()
class DataListCard {
  final String id_card, id_user, id_rfid, wallet_address;
  final int balance;
  final double balance_eth;

  DataListCard({
    required this.id_card,
    required this.id_user,
    required this.id_rfid,
    required this.wallet_address,
    required this.balance_eth,
    required this.balance,
  });

  factory DataListCard.fromJson(Map<String, dynamic> json) =>
      _$DataListCardFromJson(json);

  Map<String, dynamic> toJson() => _$DataListCardToJson(this);
}
