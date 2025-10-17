import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_context.freezed.dart';
part 'active_context.g.dart';

@freezed
abstract class ActiveContext with _$ActiveContext {
  const factory ActiveContext({
    required String orgId,
    required String orgName,
    required String
        rol, // 'administrador'|'propietario'|'arrendatario'|'proveedor'|...
    String? providerType, // 'servicios'|'articulos'
    @Default(<String>[])
    List<String> categories, // categorías proveedor seleccionadas
    @Default(<String>[]) List<String> assetTypes, // tipos de activos de interés
  }) = _ActiveContext;

  factory ActiveContext.fromJson(Map<String, dynamic> json) =>
      _$ActiveContextFromJson(json);
}

/// Extension para getters de conveniencia del campaign system
extension ActiveContextX on ActiveContext {
  String get userRole => rol;
  String? get currentCityId => null; // No existe cityId real en ActiveContext
}
