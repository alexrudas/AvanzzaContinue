/*
Estados del ciclo de vida de una publicación.
Dominio puro: sin dependencias de UI ni DS.

Uso:
- Máquina de estados con transiciones validadas.
- Mapeo a i18n y tonos semánticos en capa de presentación.
- Wire names estables para persistencia.
*/

/// Estados del ciclo de vida de una publicación.
enum PublicationStatus {
  active, // Visible en discovery
  paused, // Pausada manualmente por el usuario
  expired, // Venció el plan sin renovación
  closed, // Cerrada definitivamente
}

/// Motivos tipados para transiciones de estado.
/// Útil para auditoría y analytics.
enum PublicationTransitionReason {
  userPause, // Usuario pausó manualmente
  userResume, // Usuario reactivó desde pausa
  userClose, // Usuario cerró definitivamente
  planExpired, // Plan venció automáticamente
  planRenewed, // Plan renovado (expired→active)
}

/// Extensión con metadata y reglas de cada estado.
extension PublicationStatusX on PublicationStatus {
  /// Clave i18n estable para el nombre del estado.
  String get i18nKey {
    switch (this) {
      case PublicationStatus.active:
        return 'publication.status.active';
      case PublicationStatus.paused:
        return 'publication.status.paused';
      case PublicationStatus.expired:
        return 'publication.status.expired';
      case PublicationStatus.closed:
        return 'publication.status.closed';
    }
  }

  /// Wire name estable para persistencia (no usar enum.name).
  String get wireName {
    switch (this) {
      case PublicationStatus.active:
        return 'active';
      case PublicationStatus.paused:
        return 'paused';
      case PublicationStatus.expired:
        return 'expired';
      case PublicationStatus.closed:
        return 'closed';
    }
  }

  /// Parse seguro desde string externo.
  static PublicationStatus fromWire(String raw) {
    switch (raw) {
      case 'active':
        return PublicationStatus.active;
      case 'paused':
        return PublicationStatus.paused;
      case 'expired':
        return PublicationStatus.expired;
      case 'closed':
        return PublicationStatus.closed;
      default:
        throw ArgumentError('PublicationStatus desconocido: $raw');
    }
  }

  /// Si el estado permite visualización en discovery.
  bool get isDiscoverable => this == PublicationStatus.active;

  /// Si se puede editar en este estado.
  bool get isEditable =>
      this == PublicationStatus.active || this == PublicationStatus.paused;

  /// Si el estado es terminal (no permite más transiciones).
  bool get isTerminal => this == PublicationStatus.closed;

  /// Estados alcanzables desde este estado según el grafo de transiciones.
  Set<PublicationStatus> get allowedNext {
    switch (this) {
      case PublicationStatus.active:
        return {
          PublicationStatus.paused,
          PublicationStatus.expired,
          PublicationStatus.closed
        };
      case PublicationStatus.paused:
        return {PublicationStatus.active, PublicationStatus.closed};
      case PublicationStatus.expired:
        return {PublicationStatus.active, PublicationStatus.closed};
      case PublicationStatus.closed:
        return const {};
    }
  }

  /// Verifica si puede transicionar al estado destino.
  bool canTransitionTo(PublicationStatus target) =>
      allowedNext.contains(target);

  /// Tono semántico sugerido para UI.
  /// Mapear a SemanticColors en capa de presentación.
  String get tone {
    switch (this) {
      case PublicationStatus.active:
        return 'success';
      case PublicationStatus.paused:
        return 'warning';
      case PublicationStatus.expired:
        return 'error';
      case PublicationStatus.closed:
        return 'neutral';
    }
  }
}
