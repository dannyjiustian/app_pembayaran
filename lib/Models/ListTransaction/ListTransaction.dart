import 'package:json_annotation/json_annotation.dart';

import 'DataListTransaction.dart';

part 'ListTransaction.g.dart';

@JsonSerializable(explicitToJson: true)
class ListTransaction {
  final bool status;
  final String message;
  final List<DataListTransaction>? data;

  ListTransaction({
    required this.status,
    required this.message,
    this.data,
  });
  factory ListTransaction.fromJson(Map<String, dynamic> json) => _$ListTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$ListTransactionToJson(this);
}
