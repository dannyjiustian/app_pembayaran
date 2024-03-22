import 'package:json_annotation/json_annotation.dart';

import 'DataUpdateCard.dart';

part 'UpdateCard.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateCard {
  final bool status;
  final String message;
  final DataUpdateCard? data;

  UpdateCard({
    required this.status,
    required this.message,
    this.data,
  });

  factory UpdateCard.fromJson(Map<String, dynamic> json) => _$UpdateCardFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateCardToJson(this);
}
