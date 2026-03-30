// ============================================================================
// lib/data/sync/asset_policy_merger.dart
// ASSET POLICY MERGER — Fusión determinista de pólizas de cumplimiento
//
// QUÉ HACE:
// - Fusiona dos listas de pólizas: `existing` (estado Firestore/servidor) e
//   `incoming` (estado local propuesto).
// - Identidad principal: `policyId` (UUID único por póliza).
// - Unicidad lógica: `complianceType:policyNumber` para pólizas ACTIVE
//   (detecta actualizaciones de la misma póliza aunque cambie policyId).
// - Respeta `override.isLocked`: no sobreescribe pólizas bloqueadas.
// - Mantiene `activeLogicalKey` consistente a lo largo de todo el merge.
// - Preserva pólizas legacy sin `policyId`.
//
// QUÉ NO HACE:
// - No accede a Isar ni Firestore.
// - No valida reglas de negocio de pólizas (cobertura, vigencia, etc.).
// - No genera ni persiste `policyId` — el caller garantiza policyId no-null
//   en incoming.
//
// PRINCIPIOS:
// - El caller (AssetDocumentBuilder) valida que incoming no tenga policyId null
//   antes de invocar este merger.
// - Función pura: mismo input → mismo output siempre.
// - activeLogicalKey refleja SOLO pólizas con status=ACTIVE al final del merge.
// - El resultado `merged` se retorna en orden estable.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Asset Schema v1.3.4.
// CONTRATO:
//   - incoming[*]['policyId'] NUNCA es null (validado por caller).
//   - La key de activeLogicalKey es '${complianceType}:${policyNumber}'.
//   - override.isLocked == true → servidor gana, se registra en lockedAttempts.
// ============================================================================

import '../../domain/entities/asset/asset_policy_override.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONSTANTES INTERNAS
// ─────────────────────────────────────────────────────────────────────────────

const _kStatusActive = 'ACTIVE';

// ─────────────────────────────────────────────────────────────────────────────
// RESULT
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado de [AssetPolicyMerger.mergePolicies].
final class PolicyMergeResult {
  /// Lista final de pólizas fusionadas.
  final List<Map<String, dynamic>> merged;

  /// Índice de pólizas activas: 'complianceType:policyNumber' → policyId.
  ///
  /// Solo contiene entradas para pólizas con `status == 'ACTIVE'`.
  final Map<String, String> activeLogicalKey;

  /// policyIds donde un incoming intentó sobreescribir una póliza bloqueada
  /// (`override.isLocked == true`). El servidor ganó — datos no modificados.
  final List<String> lockedOverrideAttempts;

  const PolicyMergeResult({
    required this.merged,
    required this.activeLogicalKey,
    required this.lockedOverrideAttempts,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// MERGER
// ─────────────────────────────────────────────────────────────────────────────

/// Fusión determinista de listas de pólizas de cumplimiento.
///
/// Ver encabezado del archivo para contrato completo.
abstract final class AssetPolicyMerger {
  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Fusiona [existing] (servidor) e [incoming] (local propuesto).
  ///
  /// Precondiciones (responsabilidad del caller):
  /// - Todos los mapas en [incoming] tienen `policyId` no-null y no-vacío.
  /// - Los mapas en [existing] pueden carecer de `policyId` (legacy):
  ///   en ese caso se preservan en el resultado final y no se fusionan por
  ///   identidad directa.
  static PolicyMergeResult mergePolicies({
    required List<Map<String, dynamic>> existing,
    required List<Map<String, dynamic>> incoming,
  }) {
    // -------------------------------------------------------------------------
    // 1. Indexar existing por policyId y separar legacy sin policyId
    // -------------------------------------------------------------------------
    final byId = <String, Map<String, dynamic>>{};
    final legacyPolicies = <Map<String, dynamic>>[];

    for (final policy in existing) {
      final id = policy['policyId'] as String?;
      if (id != null && id.trim().isNotEmpty) {
        byId[id] = Map<String, dynamic>.of(policy);
      } else {
        legacyPolicies.add(Map<String, dynamic>.of(policy));
      }
    }

    // -------------------------------------------------------------------------
    // 2. Construir activeLogicalKey desde existing con policyId
    //    Clave: '${complianceType}:${policyNumber}' → policyId
    // -------------------------------------------------------------------------
    final activeLogicalKey = <String, String>{};

    for (final entry in byId.entries) {
      final policy = entry.value;
      if (_isActive(policy)) {
        final lk = _logicalKey(policy);
        if (lk != null) activeLogicalKey[lk] = entry.key;
      }
    }

    // Incluir legacy ACTIVE con key lógica, pero solo si tienen campos válidos.
    // No se registran en activeLogicalKey porque el value exige policyId.
    final legacyActiveByLogicalKey = <String, Map<String, dynamic>>{};
    for (final policy in legacyPolicies) {
      if (_isActive(policy)) {
        final lk = _logicalKey(policy);
        if (lk != null) {
          legacyActiveByLogicalKey[lk] = policy;
        }
      }
    }

    // -------------------------------------------------------------------------
    // 3. Aplicar incoming sobre byId
    // -------------------------------------------------------------------------
    final lockedAttempts = <String>{};

    for (final inPolicy in incoming) {
      final inId = (inPolicy['policyId'] as String).trim();

      // 3a. Buscar por identidad de policyId
      if (byId.containsKey(inId)) {
        final existingPolicy = byId[inId]!;

        if (_isLocked(existingPolicy)) {
          lockedAttempts.add(inId);
          continue;
        }

        // Limpiar activeLogicalKey del estado anterior si era ACTIVE
        if (_isActive(existingPolicy)) {
          final oldLk = _logicalKey(existingPolicy);
          if (oldLk != null) activeLogicalKey.remove(oldLk);
        }

        // Actualizar en-place
        byId[inId] = Map<String, dynamic>.of(inPolicy);

        // Registrar nueva logical key si sigue/quedó ACTIVE
        if (_isActive(inPolicy)) {
          final newLk = _logicalKey(inPolicy);
          if (newLk != null) activeLogicalKey[newLk] = inId;
        }
        continue;
      }

      // 3b. Sin match por policyId: buscar por unicidad lógica ACTIVE
      final inLk = _logicalKey(inPolicy);
      if (inLk != null && _isActive(inPolicy)) {
        // Primero buscar contra existing con policyId
        if (activeLogicalKey.containsKey(inLk)) {
          final existingId = activeLogicalKey[inLk]!;
          final existingPolicy = byId[existingId]!;

          if (_isLocked(existingPolicy)) {
            lockedAttempts.add(existingId);
            continue;
          }

          byId[existingId] = {
            ...Map<String, dynamic>.of(inPolicy),
            'policyId': existingId, // preservar policyId del servidor
          };

          // La logical key sigue asociada al mismo policyId
          continue;
        }

        // Luego best-effort contra legacy ACTIVE sin policyId
        if (legacyActiveByLogicalKey.containsKey(inLk)) {
          final legacyPolicy = legacyActiveByLogicalKey[inLk]!;

          if (_isLocked(legacyPolicy)) {
            // No hay policyId que reportar; se ignora incoming sin registrar ID.
            continue;
          }

          // Reemplazar legacy por incoming con policyId válido.
          legacyPolicies.remove(legacyPolicy);
          legacyActiveByLogicalKey.remove(inLk);
          byId[inId] = Map<String, dynamic>.of(inPolicy);
          activeLogicalKey[inLk] = inId;
          continue;
        }
      }

      // 3c. Nueva póliza
      byId[inId] = Map<String, dynamic>.of(inPolicy);

      if (_isActive(inPolicy)) {
        final newLk = _logicalKey(inPolicy);
        if (newLk != null) activeLogicalKey[newLk] = inId;
      }
    }

    // -------------------------------------------------------------------------
    // 4. Construir resultado final en orden estable
    // -------------------------------------------------------------------------
    final merged = <Map<String, dynamic>>[
      ...byId.values,
      ...legacyPolicies,
    ]..sort((a, b) {
        final aKey = ((a['policyId'] as String?)?.trim().isNotEmpty == true)
            ? (a['policyId'] as String).trim()
            : (_logicalKey(a) ?? '');
        final bKey = ((b['policyId'] as String?)?.trim().isNotEmpty == true)
            ? (b['policyId'] as String).trim()
            : (_logicalKey(b) ?? '');
        return aKey.compareTo(bKey);
      });

    return PolicyMergeResult(
      merged: List.unmodifiable(merged),
      activeLogicalKey: Map.unmodifiable(activeLogicalKey),
      lockedOverrideAttempts: List.unmodifiable(lockedAttempts.toList()),
    );
  }

  // ==========================================================================
  // PRIVADOS
  // ==========================================================================

  static bool _isActive(Map<String, dynamic> policy) =>
      policy['status'] == _kStatusActive;

  static bool _isLocked(Map<String, dynamic> policy) {
    final overrideRaw = policy['override'];
    if (overrideRaw == null) return false;

    if (overrideRaw is Map<String, dynamic>) {
      return AssetPolicyOverride.fromJson(overrideRaw).isLocked;
    }

    return false;
  }

  /// Retorna 'complianceType:policyNumber' o null si faltan campos.
  ///
  /// Normalización:
  /// - complianceType → trim + lowercase
  /// - policyNumber → trim + uppercase
  static String? _logicalKey(Map<String, dynamic> policy) {
    final ct = (policy['complianceType'] as String?)?.trim().toLowerCase();
    final pn = (policy['policyNumber'] as String?)?.trim().toUpperCase();

    if (ct == null || ct.isEmpty || pn == null || pn.isEmpty) return null;
    return '$ct:$pn';
  }
}
