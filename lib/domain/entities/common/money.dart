import 'package:freezed_annotation/freezed_annotation.dart';

part 'money.freezed.dart';
part 'money.g.dart';

@freezed
abstract class Money with _$Money {
  const factory Money({
    required double amount,
    required String currencyCode,
  }) = _Money;

  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);
}
