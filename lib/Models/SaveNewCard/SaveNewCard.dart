import 'package:json_annotation/json_annotation.dart';

part 'SaveNewCard.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SaveNewCard {
  final String id_user, id_rfid, balance;

  SaveNewCard({
    required this.id_user,
    required this.id_rfid,
    required this.balance,
  });
  factory SaveNewCard.fromJson(Map<String, dynamic> json) =>
      _$SaveNewCardFromJson(json);
  Map<String, dynamic> toJson() => _$SaveNewCardToJson(this);
}
