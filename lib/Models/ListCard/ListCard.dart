import 'package:json_annotation/json_annotation.dart';

import 'DataListCard.dart';

part 'ListCard.g.dart';

@JsonSerializable(explicitToJson: true)
class ListCard {
  final bool status;
  final String message;
  final List<DataListCard>? data;

  ListCard({
    required this.status,
    required this.message,
    this.data,
  });
  factory ListCard.fromJson(Map<String, dynamic> json) => _$ListCardFromJson(json);
  Map<String, dynamic> toJson() => _$ListCardToJson(this);
}
