// ============================================================================
// lib/presentation/bindings/provider/select_specialties_binding.dart
// SELECT SPECIALTIES BINDING — GetX binding del selector
//
// QUÉ HACE:
// - Resuelve `assetType` e `initialSelection` desde `Get.arguments` y
//   registra `SelectSpecialtiesController` con el `SpecialtyCatalogRepository`
//   de `DIContainer()`.
// - `initialSelection` (CAMBIO 1): el caller puede rehidratar la selección
//   previa al volver a abrir el selector (en memoria del flujo, no storage).
//
// QUÉ NO HACE:
// - NO registra repos: viven en DIContainer (regla del proyecto).
// - NO valida `assetType` localmente: el backend canoniza el error como
//   `INVALID_ASSET_TYPE` y el controller lo expone vía `errorCode`.
// - NO persiste la selección a disco: el caller decide.
//
// CONTRATO DE NAVEGACIÓN:
//   Get.toNamed(Routes.selectSpecialties, arguments: {
//     'assetType': '<assetType-id, p.ej. vehicle.car>',
//     'initialSelection': <Set<String>>{...}, // opcional
//     'initialKind': 'PRODUCT' | 'SERVICE' | 'BOTH', // opcional
//     'providerName': '<displayName>', // opcional, p.ej. "Autokorea"
//   })
// El resultado se devuelve via
//   Get.back<SpecialtiesSelectionResult>(result: ...).
//
// `providerName`: usado como título del AppBar para dar contexto
// ("estás eligiendo specialties para Autokorea"). Si null/vacío, la page
// cae a fallback "Especialidades".
//
// `initialKind`: pre-filtro single-source-of-truth desde el caller (form
// de proveedor). El selector aplica este kind al primer fetch y NO
// permite cambiarlo dentro (toggle interno eliminado para evitar
// divergencia con el form). Acepta wireName (PRODUCT/SERVICE/BOTH).
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/catalog/specialty_entity.dart';
import '../../controllers/provider/specialties/select_specialties_controller.dart';

class SelectSpecialtiesBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final assetType = _resolveAssetType(args);
    final initialSelection = _resolveInitialSelection(args);
    final initialKind = _resolveInitialKind(args);
    final providerName = _resolveProviderName(args);

    Get.lazyPut(
      () => SelectSpecialtiesController(
        repository: DIContainer().specialtyCatalogRepository,
        assetType: assetType,
        initialSelection: initialSelection,
        initialKind: initialKind,
        providerName: providerName,
      ),
      // fenix: false — el selector es flujo modal con resultado; al cerrar
      // se libera para evitar arrastrar selección a futuras invocaciones.
      fenix: false,
    );
  }

  /// Extrae `assetType` aceptando dos formas de argumento:
  /// - `String` directo: `Get.toNamed(..., arguments: 'vehicle.car')`
  /// - `Map`: `Get.toNamed(..., arguments: {'assetType': 'vehicle.car'})`
  ///
  /// Si no se provee, devuelve cadena vacía y el backend responderá
  /// `INVALID_ASSET_TYPE` — el controller lo expone como error.
  String _resolveAssetType(dynamic args) {
    if (args is String) return args;
    if (args is Map) {
      final v = args['assetType'];
      if (v is String) return v;
    }
    return '';
  }

  /// Extrae `initialSelection` desde el Map de argumentos.
  ///
  /// Acepta `Set<String>`, `List<String>` o `Iterable<String>` para mayor
  /// robustez con callers que no piensen en el tipo exacto. Cualquier
  /// elemento no-String se descarta silenciosamente — defensa en profundidad
  /// ante args malformados (no se lanza para no romper la apertura del
  /// selector por un detalle de argumento).
  Set<String>? _resolveInitialSelection(dynamic args) {
    if (args is! Map) return null;
    final raw = args['initialSelection'];
    if (raw is Set) {
      return raw.whereType<String>().toSet();
    }
    if (raw is Iterable) {
      return raw.whereType<String>().toSet();
    }
    return null;
  }

  /// Extrae `initialKind` desde el Map de argumentos.
  ///
  /// Acepta dos formas:
  /// - `SpecialtyKind` enum directo (uso interno cliente).
  /// - `String` con el `wireName` (PRODUCT | SERVICE | BOTH) — caso
  ///   habitual cuando el caller serializa el kind para no acoplar
  ///   sus argumentos al tipo de dominio del selector.
  ///
  /// Wire-values inválidos → null silencioso (defensa en profundidad).
  /// El controller del selector aplica el kind al fetch; null = sin
  /// pre-filtro (equivalente a no pasar el argumento).
  SpecialtyKind? _resolveInitialKind(dynamic args) {
    if (args is! Map) return null;
    final raw = args['initialKind'];
    if (raw is SpecialtyKind) return raw;
    if (raw is String && raw.isNotEmpty) {
      try {
        return SpecialtyKind.fromWire(raw);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Extrae `providerName` (display name del proveedor que el usuario
  /// está editando) desde el Map de argumentos. Solo acepta `String`
  /// no vacío; cualquier otra cosa → null. Trim aplicado para
  /// normalizar espacios accidentales del input del form.
  ///
  /// Se usa exclusivamente como copy del AppBar — NO afecta lógica de
  /// fetch ni viaja al backend.
  String? _resolveProviderName(dynamic args) {
    if (args is! Map) return null;
    final raw = args['providerName'];
    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }
}
