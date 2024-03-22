import 'package:json_annotation/json_annotation.dart';

import 'DataListCard.dart';

part 'Card.g.dart';

@JsonSerializable(explicitToJson: true)
class Card {
  final bool status;
  final String message;
  final DataListCard? data;

  Card({
    required this.status,
    required this.message,
    this.data,
  });
  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
  Map<String, dynamic> toJson() => _$CardToJson(this);
}
