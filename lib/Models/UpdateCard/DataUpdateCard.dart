import 'package:json_annotation/json_annotation.dart';

part 'DataUpdateCard.g.dart';

@JsonSerializable()
class DataUpdateCard {
  final int balance;

  DataUpdateCard({
    required this.balance,
  });

  factory DataUpdateCard.fromJson(Map<String, dynamic> json) =>
      _$DataUpdateCardFromJson(json);

  Map<String, dynamic> toJson() => _$DataUpdateCardToJson(this);
}
