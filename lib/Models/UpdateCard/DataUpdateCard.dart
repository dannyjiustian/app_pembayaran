import 'package:json_annotation/json_annotation.dart';

part 'DataUpdateCard.g.dart';

@JsonSerializable()
class DataUpdateCard {
  final int balance;
  final bool is_active;

  DataUpdateCard({
    required this.balance,
    required this.is_active,
  });

  factory DataUpdateCard.fromJson(Map<String, dynamic> json) =>
      _$DataUpdateCardFromJson(json);

  Map<String, dynamic> toJson() => _$DataUpdateCardToJson(this);
}
