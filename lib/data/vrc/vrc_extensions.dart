// ============================================================================
// lib/data/vrc/vrc_extensions.dart
// VRC EXTENSIONS — Data Layer / Getters ligeros sobre DTOs
//
// QUÉ HACE:
// - Expone getters de conveniencia sobre VrcDataModel y VrcOwnerRuntModel.
// - Evita repetir lógica de acceso a campos nullable en controller y UI.
//
// QUÉ NO HACE:
// - No contiene reglas operativas (ver vrc_rules.dart).
// - No toma decisiones de negocio (APPROVE/REJECT/bloqueo).
// - No accede a meta.sources.
//
// PRINCIPIOS:
// - Solo getters puros sobre la forma del dato, sin interpretación semántica.
// - Un getter devuelve siempre el tipo más estricto posible.
// ============================================================================

import 'models/vrc_models.dart';

/// Getters de conveniencia sobre [VrcDataModel].
extension VrcDataExtension on VrcDataModel {
  /// true si el propietario es una empresa (type == "COMPANY").
  bool get isCompany => owner?.type == 'COMPANY';

  /// true si el propietario es una persona natural (type == "PERSON").
  bool get isPerson => owner?.type == 'PERSON';

  /// true si el resumen SIMIT está disponible.
  ///
  /// false NO significa "sin multas" — significa que SIMIT no tiene datos.
  bool get hasSimitData => owner?.simit?.summary != null;

  /// true si el RUNT persona devolvió un error.
  ///
  /// Señal de degradación: la consulta llegó pero faltó información del propietario.
  bool get hasRuntOwnerError => owner?.runt?.error != null;

  /// Etiqueta display del tipo de propietario.
  ///
  /// Retorna '—' cuando el tipo no está disponible.
  String get ownerDisplayType {
    if (isPerson) return 'Persona';
    if (isCompany) return 'Empresa';
    return '—';
  }
}

/// Getters de conveniencia sobre [VrcOwnerRuntModel].
extension VrcOwnerRuntExtension on VrcOwnerRuntModel {
  /// true si hay al menos una licencia de conducción.
  ///
  /// false puede significar licencias no disponibles o propietario empresa.
  bool get hasLicenses => licenses != null && licenses!.isNotEmpty;
}
