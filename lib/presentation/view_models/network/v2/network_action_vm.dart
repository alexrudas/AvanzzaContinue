// ============================================================================
// lib/presentation/view_models/network/v2/network_action_vm.dart
// NETWORK ACTION VM — Wrapper UI-friendly de NetworkActionDto
// ============================================================================
// QUÉ HACE:
//   - Adapta NetworkActionDto a un modelo consumible por la UI.
//   - Expone los campos que la UI necesita para renderizar y enrutar acciones,
//     SIEMPRE como tipos enum (nunca strings de copy).
//
// QUÉ NO HACE:
//   - NO contiene labels en español. La copy se resuelve vía
//     NetworkLabels.actionLabel(vm.type) en el sitio de uso (UI).
//   - NO infiere `enabled`. Respeta lo que el backend calculó. Si la UI
//     intenta ejecutar una acción con `enabled=false`, debe mostrar el
//     hint vía NetworkLabels.actionDisabledHint(vm.disabledReason!).
// ============================================================================

import '../../../../data/models/network/network_action_dto.dart';

/// View-model para una acción operativa calculada por backend.
class NetworkActionVM {
  final NetworkActionType type;
  final bool enabled;
  final NetworkActionDomain? domain;
  final NetworkActionCapability? capability;

  /// Garantizado no-null cuando enabled=false (invariante del DTO).
  /// Cuando enabled=true puede venir como informativo.
  final NetworkActionDisabledReason? disabledReason;

  const NetworkActionVM({
    required this.type,
    required this.enabled,
    required this.domain,
    required this.capability,
    required this.disabledReason,
  });

  /// Construye desde el DTO sin perder fidelidad ni validar de nuevo
  /// (el DTO ya validó las invariantes en su `fromJson`).
  factory NetworkActionVM.fromDto(NetworkActionDto dto) => NetworkActionVM(
        type: dto.type,
        enabled: dto.enabled,
        domain: dto.domain,
        capability: dto.capability,
        disabledReason: dto.reason,
      );

  /// True si la acción puede ejecutarse en este momento.
  bool get isExecutable => enabled;

  /// True si requiere mostrar hint de motivo deshabilitado.
  /// (Equivalente lógico a `!enabled`, pero más legible en widgets.)
  bool get showsDisabledHint => !enabled;
}
