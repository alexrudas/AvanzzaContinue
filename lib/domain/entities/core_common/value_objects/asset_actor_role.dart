// ============================================================================
// lib/domain/entities/core_common/value_objects/asset_actor_role.dart
// AssetActorRole — roles canónicos del vínculo actor↔activo
// ============================================================================
// QUÉ HACE:
//   - Espejo del enum Prisma `AssetActorRole` del backend.
//   - Enum FUERTE por diseño del ADR §2.9: no se usa role string libre en la
//     capa canónica. Si aparece un rol fuera de esta lista, se extiende
//     conscientemente aquí y en backend (migración Prisma).
//
// QUÉ NO HACE:
//   - No mapea a labels de UI (eso vive en presentación / i18n).
//   - No define permisos por rol.
//
// EVOLUCIÓN:
//   - 2026-05: +manager (administrador del activo sin ser dueño/operador/taller).
//     Es append-only por contrato wire-stable; no reordenar ni eliminar valores.
//
// See docs/adr/0001-actor-canon.md §2.9 (role enum fuerte) + §9 (checklist).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

enum AssetActorRole {
  /// Propietario del activo.
  @JsonValue('owner')
  owner,

  /// Arrendatario (contrato de arriendo sobre el activo).
  @JsonValue('tenant')
  tenant,

  /// Operador / gestor operativo del activo.
  @JsonValue('operator')
  operator,

  /// Conductor (vehículos).
  @JsonValue('driver')
  driver,

  /// Técnico asignado.
  @JsonValue('technician')
  technician,

  /// Taller asignado / recurrente.
  @JsonValue('workshop')
  workshop,

  /// Representación legal del activo (abogado, apoderado).
  @JsonValue('legal')
  legal,

  /// Administrador del activo: organización/persona que gestiona el activo
  /// sin ser propietaria, operadora ni proveedora de servicios. Caso típico:
  /// administradora de flota / inmuebles que coordina uso, mantenimiento y
  /// disposición sin tenerlo en su patrimonio.
  ///
  /// Distinto de:
  /// - `owner`     — titular patrimonial.
  /// - `operator`  — ejecuta el uso operativo.
  /// - `workshop`  — provee servicios al activo.
  /// - `tenant`    — usa el activo bajo contrato de arriendo.
  @JsonValue('manager')
  manager,
}

extension AssetActorRoleX on AssetActorRole {
  String get wireName {
    switch (this) {
      case AssetActorRole.owner:
        return 'owner';
      case AssetActorRole.tenant:
        return 'tenant';
      case AssetActorRole.operator:
        return 'operator';
      case AssetActorRole.driver:
        return 'driver';
      case AssetActorRole.technician:
        return 'technician';
      case AssetActorRole.workshop:
        return 'workshop';
      case AssetActorRole.legal:
        return 'legal';
      case AssetActorRole.manager:
        return 'manager';
    }
  }

  /// Parsea wire name a su valor canónico. Throws [ArgumentError] si el
  /// string no está en el catálogo. Mantiene el contrato estricto histórico
  /// del repo para datos confiables.
  static AssetActorRole fromWire(String raw) {
    switch (raw) {
      case 'owner':
        return AssetActorRole.owner;
      case 'tenant':
        return AssetActorRole.tenant;
      case 'operator':
        return AssetActorRole.operator;
      case 'driver':
        return AssetActorRole.driver;
      case 'technician':
        return AssetActorRole.technician;
      case 'workshop':
        return AssetActorRole.workshop;
      case 'legal':
        return AssetActorRole.legal;
      case 'manager':
        return AssetActorRole.manager;
      default:
        throw ArgumentError('AssetActorRole desconocido: $raw');
    }
  }

  /// Versión no-throw: retorna `null` si [raw] es null o no pertenece al
  /// catálogo. Apta para lectura de datos persistidos cuyo schema puede
  /// contener wire names futuros desconocidos por la build actual.
  ///
  /// Lista de wire names válidos:
  ///   owner | tenant | operator | driver | technician | workshop | legal | manager
  static AssetActorRole? tryFromWire(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'owner':
        return AssetActorRole.owner;
      case 'tenant':
        return AssetActorRole.tenant;
      case 'operator':
        return AssetActorRole.operator;
      case 'driver':
        return AssetActorRole.driver;
      case 'technician':
        return AssetActorRole.technician;
      case 'workshop':
        return AssetActorRole.workshop;
      case 'legal':
        return AssetActorRole.legal;
      case 'manager':
        return AssetActorRole.manager;
      default:
        return null;
    }
  }

  /// Snapshot inmutable de wire names en el orden de declaración del enum.
  static List<String> get allWireNames =>
      AssetActorRole.values.map((r) => r.wireName).toList(growable: false);
}
