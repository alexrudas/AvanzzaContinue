// ============================================================================
// lib/domain/entities/workspace/registration_workspace_intent.dart
// REGISTRATION WORKSPACE INTENT — Enterprise Ultra Pro Premium (Domain / Workspace)
//
// QUÉ HACE:
// - Captura la intención declarativa del usuario durante el onboarding,
//   antes de que se persista ninguna entidad.
// - Funciona como input contract puro para la resolución del contrato de salida
//   del registro.
// - Contiene workspaceType + businessMode + orgType + providerType (si aplica).
// - Normaliza inputs legacy suaves para evitar ruido semántico en la capa
//   de dominio.
//
// QUÉ NO HACE:
// - NO persiste nada.
// - NO navega ni decide rutas.
// - NO importa Flutter, GetX, Isar ni infraestructura.
// - NO contiene IDs de entidades (org, membership, user).
// - NO ejecuta lógica de resolución del contrato final.
//
// PRINCIPIOS:
// - INMUTABLE: una vez construida, la intención no cambia.
// - PRE-PERSISTENCIA: existe solo entre la selección del usuario y la escritura.
// - VALIDABLE: validate() lanza RegistrationWorkspaceIntentException cuando
//   la intención no cumple invariantes mínimas.
// - NORMALIZACIÓN TEMPRANA: orgType/providerType se limpian al construir,
//   no se arrastra ruido legacy al resolver.
// - PURE DOMAIN: cero dependencias de infraestructura.
//
// NOTAS ARQUITECTÓNICAS:
// - Aunque la ruta actual vive bajo domain/entities/workspace, este objeto se
//   comporta como un value contract transicional del dominio.
// - providerType NO es un concepto raíz del dominio; solo es metadata de
//   resolución del onboarding para supplier/workshop.
// ============================================================================

import '../../value/workspace/business_mode.dart';
import 'workspace_type.dart';

/// Excepción semántica de validación del intent de registro.
///
/// Diseñada para que controller/UI puedan capturar reasonCode y traducirlo
/// a un mensaje profesional sin producir crash en producción.
class RegistrationWorkspaceIntentException implements Exception {
  /// Código semántico estable para UI, logs y telemetría.
  final String reasonCode;

  /// Detalle técnico opcional para diagnóstico.
  final String? detail;

  const RegistrationWorkspaceIntentException(
    this.reasonCode, {
    this.detail,
  });

  @override
  String toString() {
    final suffix = detail == null ? '' : ', detail: $detail';
    return 'RegistrationWorkspaceIntentException($reasonCode$suffix)';
  }
}

/// Input contract declarativo del onboarding.
///
/// Representa lo que el usuario quiere crear antes de que exista ninguna
/// entidad persistida. Es un objeto puro de dominio y debe llegar limpio al
/// resolver del contrato de registro.
class RegistrationWorkspaceIntent {
  /// Tipo canónico del workspace seleccionado.
  ///
  /// Nunca puede ser [WorkspaceType.unknown] al momento de persistir.
  final WorkspaceType workspaceType;

  /// Modo operativo canónico del usuario dentro del workspace.
  final BusinessMode businessMode;

  /// Tipo de organización normalizado.
  ///
  /// Valores válidos:
  /// - 'personal'
  /// - 'empresa'
  final String orgType;

  /// Tipo de proveedor normalizado.
  ///
  /// Solo aplica cuando [workspaceType] es:
  /// - [WorkspaceType.workshop]
  /// - [WorkspaceType.supplier]
  ///
  /// Valores válidos:
  /// - 'articulos'
  /// - 'servicios'
  /// - null (solo cuando no aplica)
  final String? providerType;

  const RegistrationWorkspaceIntent._({
    required this.workspaceType,
    required this.businessMode,
    required this.orgType,
    required this.providerType,
  });

  /// Factory principal con normalización temprana.
  ///
  /// Normaliza:
  /// - orgType: trim + lowercase
  /// - providerType: trim + lowercase + singular/plural suaves
  factory RegistrationWorkspaceIntent({
    required WorkspaceType workspaceType,
    required BusinessMode businessMode,
    required String orgType,
    String? providerType,
  }) {
    return RegistrationWorkspaceIntent._(
      workspaceType: workspaceType,
      businessMode: businessMode,
      orgType: _normalizeOrgType(orgType),
      providerType: _normalizeProviderType(providerType),
    );
  }

  // ==========================================================================
  // SEMÁNTICA
  // ==========================================================================

  /// True si este workspace requiere providerType.
  bool get requiresProviderType =>
      workspaceType == WorkspaceType.workshop ||
      workspaceType == WorkspaceType.supplier;

  /// True si providerType aplica y está presente.
  bool get hasProviderType =>
      providerType != null && providerType!.trim().isNotEmpty;

  /// Debug string compacto y estable para logs/telemetría.
  String get debugDescription {
    return 'RegistrationWorkspaceIntent('
        'type=${workspaceType.wireName}, '
        'mode=${businessMode.wireName}, '
        'orgType=$orgType, '
        'providerType=${providerType ?? "none"}'
        ')';
  }

  // ==========================================================================
  // VALIDACIÓN
  // ==========================================================================

  /// Valida invariantes mínimas de resolubilidad.
  ///
  /// Lanza [RegistrationWorkspaceIntentException] si la intención no cumple
  /// con los requisitos mínimos del contrato aprobado.
  void validate() {
    if (workspaceType == WorkspaceType.unknown) {
      throw const RegistrationWorkspaceIntentException(
        'workspace_type_unknown',
        detail: 'workspaceType must be a valid value, not unknown',
      );
    }

    if (orgType != 'personal' && orgType != 'empresa') {
      throw RegistrationWorkspaceIntentException(
        'invalid_org_type',
        detail: 'orgType must be "personal" or "empresa", got: $orgType',
      );
    }

    if (requiresProviderType && !hasProviderType) {
      throw RegistrationWorkspaceIntentException(
        'provider_type_required',
        detail:
            'providerType is required for workspaceType=${workspaceType.wireName}',
      );
    }

    if (!requiresProviderType && hasProviderType) {
      throw RegistrationWorkspaceIntentException(
        'unexpected_provider_type',
        detail:
            'providerType is only valid for workshop/supplier, got: $providerType for workspaceType=${workspaceType.wireName}',
      );
    }

    if (hasProviderType &&
        providerType != 'articulos' &&
        providerType != 'servicios') {
      throw RegistrationWorkspaceIntentException(
        'invalid_provider_type',
        detail:
            'providerType must be "articulos" or "servicios", got: $providerType',
      );
    }
  }

  // ==========================================================================
  // UTILIDAD
  // ==========================================================================

  RegistrationWorkspaceIntent copyWith({
    WorkspaceType? workspaceType,
    BusinessMode? businessMode,
    String? orgType,
    Object? providerType = _copySentinel,
  }) {
    return RegistrationWorkspaceIntent(
      workspaceType: workspaceType ?? this.workspaceType,
      businessMode: businessMode ?? this.businessMode,
      orgType: orgType ?? this.orgType,
      providerType: identical(providerType, _copySentinel)
          ? this.providerType
          : providerType as String?,
    );
  }

  @override
  String toString() => debugDescription;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RegistrationWorkspaceIntent &&
            other.workspaceType == workspaceType &&
            other.businessMode == businessMode &&
            other.orgType == orgType &&
            other.providerType == providerType;
  }

  @override
  int get hashCode => Object.hash(
        workspaceType,
        businessMode,
        orgType,
        providerType,
      );

  // ==========================================================================
  // NORMALIZACIÓN PRIVADA
  // ==========================================================================

  static String _normalizeOrgType(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'persona') return 'personal';
    return normalized;
  }

  static String? _normalizeProviderType(String? value) {
    if (value == null) return null;

    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return null;

    if (normalized == 'articulo') return 'articulos';
    if (normalized == 'servicio') return 'servicios';

    return normalized;
  }
}

const Object _copySentinel = Object();
