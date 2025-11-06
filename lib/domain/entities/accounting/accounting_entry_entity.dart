import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_entry_entity.freezed.dart';
part 'accounting_entry_entity.g.dart';

@freezed
abstract class AccountingEntryEntity with _$AccountingEntryEntity {
  const factory AccountingEntryEntity({
    @Default('') String id,
    @Default('') String orgId,
    @Default('') String countryId,
    String? cityId,
    @Default('ingreso') String tipo,
    @Default(0.0) double monto,
    @Default('COP') String currencyCode,
    @Default('') String descripcion,
    required DateTime fecha, // required, no @Default here
    @Default('') String referenciaType,
    @Default('') String referenciaId,
    String? counterpartyId,
    @Default('cash') String method,
    @Default(0.0) double taxAmount,
    @Default(0.0) double taxRate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AccountingEntryEntity;

  factory AccountingEntryEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountingEntryEntityFromJson(json);
}
