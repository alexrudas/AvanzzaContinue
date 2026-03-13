// ============================================================================
// lib/presentation/widgets/activation/activation_gate_config.dart
// ACTIVATION GATE CONFIG — Enterprise Ultra Pro (Presentation / Activation)
//
// QUÉ HACE
// - Centraliza el copy dinámico del ActivationGateOverlay según el rol activo.
// - Encapsula título, subtítulo, CTA e ícono en un modelo inmutable.
// - Permite que la UI cambie su copy según el contexto del usuario.
//
// QUÉ NO HACE
// - No consulta repositorios.
// - No contiene lógica de negocio.
// - No decide si el gate se muestra o no.
//
// PRINCIPIOS
// - Single Responsibility: solo configuración de presentación.
// - Matching centralizado para evitar lógica duplicada.
// - Copy profesional y consistente con el modelo de Avanzza.
// - Preparado para migrar de role → WorkspaceMode.
//
// ENTERPRISE NOTE
// Actualmente el sistema usa ActiveContext.rol.
// En Sprint 2 esto debe migrar a:
//
//     ActivationGateConfig.forWorkspaceMode()
//
// donde WorkspaceMode será la verdadera fuente de verdad del contexto UI.
// ============================================================================

import 'package:flutter/material.dart';

/// Categoría semántica interna derivada del rol activo.
///
/// No debe salir de la capa de presentación.
enum _RoleCategory {
  proveedor,
  propietario,
  arrendatario,
  asesorOAseguradora,
  abogado,
  tecnico,

  /// Administrador de activos y fallback para roles no categorizados.
  adminActivos,
}

/// Configuración visual y textual del ActivationGateOverlay.
///
/// Este modelo encapsula todo el contenido que el overlay necesita:
/// título, subtítulo, explicación, CTA e ícono.
///
/// Es completamente inmutable.
class ActivationGateConfig {
  /// Título principal del overlay.
  final String title;

  /// Subtítulo / propuesta de valor.
  final String lead;

  /// Texto explicativo principal.
  final String body;

  /// Texto del botón principal.
  final String ctaLabel;

  /// Ícono representativo del contexto.
  final IconData icon;

  const ActivationGateConfig({
    required this.title,
    required this.lead,
    required this.body,
    required this.ctaLabel,
    required this.icon,
  });

  /// Factory actual basado en rol.
  ///
  /// Este método existe por compatibilidad con la arquitectura actual.
  ///
  /// TODO Sprint 2
  /// Migrar a:
  ///     ActivationGateConfig.forWorkspaceMode()
  factory ActivationGateConfig.forRole(String? role) {
    final category = _resolveRoleCategory(role);
    return _configForCategory(category);
  }

  /// Retorna la configuración adecuada según la categoría semántica.
  static ActivationGateConfig _configForCategory(_RoleCategory category) {
    return switch (category) {
      _RoleCategory.proveedor => const ActivationGateConfig(
          title: 'Bienvenido a Avanzza',
          lead: 'Activa tu espacio como proveedor.',
          body:
              'Configura tu catálogo de productos o servicios para comenzar a recibir solicitudes de clientes.',
          ctaLabel: 'Configurar mi catálogo',
          icon: Icons.miscellaneous_services_outlined,
        ),
      _RoleCategory.propietario => const ActivationGateConfig(
          title: 'Bienvenido a Avanzza',
          lead: 'Gestiona tu portafolio de activos.',
          body:
              'Registra el primer activo de tu portafolio para comenzar a visualizar rentabilidad, documentos y control operativo.',
          ctaLabel: 'Registrar mi primer activo',
          icon: Icons.real_estate_agent_outlined,
        ),
      _RoleCategory.arrendatario => const ActivationGateConfig(
          title: 'Bienvenido a Avanzza',
          lead: 'Gestiona los activos que tienes asignados.',
          body:
              'Desde aquí podrás consultar pagos, reportar incidencias y revisar documentos relacionados con tus activos asignados.',
          ctaLabel: 'Explorar mis activos',
          icon: Icons.key_outlined,
        ),
      _RoleCategory.asesorOAseguradora => const ActivationGateConfig(
          title: 'Bienvenido a Avanzza',
          lead: 'Activa tu espacio de trabajo de seguros.',
          body:
              'Comienza a gestionar activos, pólizas y seguimiento de cartera desde una sola plataforma.',
          ctaLabel: 'Registrar mi primer activo',
          icon: Icons.shield_outlined,
        ),
      _RoleCategory.abogado => const ActivationGateConfig(
          title: 'Bienvenido a Avanzza',
          lead: 'Gestiona los activos vinculados a tus casos.',
          body:
              'Comienza a organizar documentos, reclamaciones y seguimiento legal de los activos de tus clientes.',
          ctaLabel: 'Registrar mi primer activo',
          icon: Icons.gavel_outlined,
        ),
      _RoleCategory.tecnico => const ActivationGateConfig(
          title: 'Bienvenido a Avanzza',
          lead: 'Activa tu espacio técnico.',
          body:
              'Configura tu espacio de trabajo para comenzar a gestionar servicios, incidencias y atención técnica sobre activos.',
          ctaLabel: 'Configurar mi espacio técnico',
          icon: Icons.build_outlined,
        ),
      _RoleCategory.adminActivos => const ActivationGateConfig(
          title: 'Bienvenido a Avanzza',
          lead: 'Gestiona y controla tus activos desde una sola plataforma.',
          body:
              'Para activar tu espacio de trabajo debes registrar el primer activo que vas a administrar.',
          ctaLabel: 'Registrar mi primer activo',
          icon: Icons.inventory_2_outlined,
        ),
    };
  }
}

/// Determina la categoría semántica del rol.
_RoleCategory _resolveRoleCategory(String? rawRole) {
  final role = _normalizeRole(rawRole);

  if (role.isEmpty) return _RoleCategory.adminActivos;

  if (_containsAny(role, const ['proveedor'])) {
    return _RoleCategory.proveedor;
  }

  if (_containsAny(role, const ['propietario'])) {
    return _RoleCategory.propietario;
  }

  if (_containsAny(role, const ['arrendatario'])) {
    return _RoleCategory.arrendatario;
  }

  if (_containsAny(role, const ['asesor', 'aseguradora', 'seguro'])) {
    return _RoleCategory.asesorOAseguradora;
  }

  if (_containsAny(role, const ['abogado', 'legal', 'juridico'])) {
    return _RoleCategory.abogado;
  }

  if (_containsAny(role, const ['tecnico', 'mecanico', 'taller'])) {
    return _RoleCategory.tecnico;
  }

  return _RoleCategory.adminActivos;
}

/// Normaliza el rol para facilitar matching seguro.
///
/// - elimina espacios
/// - pasa a lowercase
/// - elimina tildes
String _normalizeRole(String? value) {
  if (value == null) return '';

  return value
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ñ', 'n');
}

/// Helper reutilizable para detectar coincidencias.
bool _containsAny(String source, List<String> needles) {
  for (final needle in needles) {
    if (source.contains(needle)) {
      return true;
    }
  }
  return false;
}
