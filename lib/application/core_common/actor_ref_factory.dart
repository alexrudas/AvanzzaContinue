// ============================================================================
// lib/application/core_common/actor_ref_factory.dart
// ActorRefFactory — única fuente de decisión sobre attestSelf en el cliente
// ============================================================================
// QUÉ HACE:
//   - Centraliza la construcción de List<ActorRef> + decisión de attestSelf.
//   - Expone dos métodos con semántica explícita:
//       * fromKnownLocalContactIds(ids)           → attestSelf=false (default).
//       * fromFreshlyCreatedLocalContactIds(ids)  → attestSelf=true (excepción).
//
// POR QUÉ EXISTE (ADR actor-canon):
//   - attestSelf es EXCEPCIÓN, no default. Ver docs/adr/0001-actor-canon.md §8.
//   - El flag autoriza crear LocalRefAttestation server-side en el mismo
//     write, y está acotado por un rate limit en backend. No debe usarse
//     como "por si acaso".
//   - Flujo normal: el cliente ya pasó por probe (save_local_contact_with_probe,
//     save_local_organization_with_probe) al crear/editar el contacto, así
//     que el backend YA tiene attestation. Enviar attestSelf=true en ese
//     caso es ruido y agota la ventana de gracia.
//   - Excepción: "primer write post-alta sin probe previo confirmado". Por
//     ejemplo una pantalla combinada "crear proveedor + enviar solicitud"
//     que aún no ha disparado probe cuando golpea el endpoint vertical.
//
// REGLA DE USO:
//   - Por default, SIEMPRE `fromKnownLocalContactIds`.
//   - Solo usar `fromFreshlyCreatedLocalContactIds` cuando se pueda
//     justificar explícitamente la excepción en el call site.
//
// See docs/adr/0001-actor-canon.md (addendum §8 — attestSelf acotado).
// ============================================================================

import '../../domain/entities/core_common/actor_ref.dart';

/// Paquete resultado de la construcción: refs + flag attestSelf decidido.
///
/// ⚠ CONSTRUCTOR PRIVADO: solo `ActorRefFactory` puede producir instancias.
/// Esto blinda por TIPOS la disciplina del ADR §8: nadie puede saltarse el
/// factory ni decidir `attestSelf` por fuera. Cualquier call site que quiera
/// construir un `BuiltActorRefs` a mano obtiene compile error.
class BuiltActorRefs {
  final List<ActorRef> refs;

  /// `true` autoriza crear attestation server-side en el mismo write.
  /// `false` exige probe previo (caso normal).
  final bool attestSelf;

  const BuiltActorRefs._({required this.refs, required this.attestSelf});
}

class ActorRefFactory {
  const ActorRefFactory._();

  // --------------------------------------------------------------------------
  // Flujo normal: los contactos ya existen en la libreta desde hace tiempo,
  // por tanto ya pasaron por probe y el backend los tiene en attestation.
  // attestSelf=false → el campo NO viajará en el wire (el DTO solo emite
  // attestSelf cuando es true explícito).
  // --------------------------------------------------------------------------
  static BuiltActorRefs fromKnownLocalContactIds(
    Iterable<String> localContactIds,
  ) {
    final refs = localContactIds
        .map((id) => actorRefFromLocalContactId(id))
        .toList(growable: false);
    return BuiltActorRefs._(refs: refs, attestSelf: false);
  }

  // --------------------------------------------------------------------------
  // Flujo excepción: "primer write post-alta". Los contactos acaban de
  // crearse en el cliente y NO se puede garantizar que el probe ya haya
  // registrado attestation server-side. Usar con justificación explícita
  // en el call site.
  // --------------------------------------------------------------------------
  static BuiltActorRefs fromFreshlyCreatedLocalContactIds(
    Iterable<String> localContactIds,
  ) {
    final refs = localContactIds
        .map((id) => actorRefFromLocalContactId(id))
        .toList(growable: false);
    return BuiltActorRefs._(refs: refs, attestSelf: true);
  }

  // --------------------------------------------------------------------------
  // Flujo normal para organizaciones locales.
  // --------------------------------------------------------------------------
  static BuiltActorRefs fromKnownLocalOrganizationIds(
    Iterable<String> localOrgIds,
  ) {
    final refs = localOrgIds
        .map((id) => actorRefFromLocalOrganizationId(id))
        .toList(growable: false);
    return BuiltActorRefs._(refs: refs, attestSelf: false);
  }

  // --------------------------------------------------------------------------
  // Flujo excepción para organizaciones locales recién creadas.
  // --------------------------------------------------------------------------
  static BuiltActorRefs fromFreshlyCreatedLocalOrganizationIds(
    Iterable<String> localOrgIds,
  ) {
    final refs = localOrgIds
        .map((id) => actorRefFromLocalOrganizationId(id))
        .toList(growable: false);
    return BuiltActorRefs._(refs: refs, attestSelf: true);
  }
}
