import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_profile.freezed.dart';
part 'provider_profile.g.dart';

@freezed
abstract class ProviderProfile with _$ProviderProfile {
  const factory ProviderProfile({
    required String providerType, // 'articulos' | 'servicios'
    @Default(<String>[])
    List<String>
        assetTypeIds, // ['vehiculos','inmuebles','maquinaria','equipos','otros']
    required String
        businessCategoryId, // ej: 'lubricentro' | 'mecanico_independiente'
    @Default(<String>[]) List<String> assetSegmentIds, // ej: ['moto','auto']
    @Default(<String>[]) List<String> offeringLineIds, // opcional
    @Default(<String>[]) List<String> coverageCities, // 'PAIS/REGION/CIUDAD'
    String? branchId, // si aplica
    DateTime? updatedAt,
  }) = _ProviderProfile;

  factory ProviderProfile.fromJson(Map<String, dynamic> json) =>
      _$ProviderProfileFromJson(json);
}
