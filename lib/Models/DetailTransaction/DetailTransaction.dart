import 'package:json_annotation/json_annotation.dart';

import 'DataDetailTransaction.dart';

part 'DetailTransaction.g.dart';

@JsonSerializable(explicitToJson: true)
class DetailTransaction {
  final bool status;
  final String message;
  final DataDetailTransaction? data;

  DetailTransaction({
    required this.status,
    required this.message,
    this.data,
  });
  factory DetailTransaction.fromJson(Map<String, dynamic> json) => _$DetailTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$DetailTransactionToJson(this);
}
