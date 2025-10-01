import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_entity.freezed.dart';
part 'branch_entity.g.dart';

@freezed
abstract class BranchEntity with _$BranchEntity {
  const factory BranchEntity({
    required String id,
    required String orgId,
    required String name,
    String? address,
    required String countryId,
    String? regionId,
    String? cityId,
    @Default(<String>[]) List<String> coverageCities, // 'PAIS/REGION/CIUDAD'
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BranchEntity;

  factory BranchEntity.fromJson(Map<String, dynamic> json) => _$BranchEntityFromJson(json);
}
