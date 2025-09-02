import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/common/money.dart' as domain;

part 'money_model.g.dart';

@embedded
@JsonSerializable()
class MoneyModel {
  double? amount;
  String? currencyCode;

  MoneyModel({this.amount, this.currencyCode});

  // JSON
  factory MoneyModel.fromJson(Map<String, dynamic> json) =>
      _$MoneyModelFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyModelToJson(this);

  // Converters
  factory MoneyModel.fromEntity(domain.Money e) =>
      MoneyModel(amount: e.amount, currencyCode: e.currencyCode);

  domain.Money toEntity() =>
      domain.Money(amount: amount!, currencyCode: currencyCode!);
}
