import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/telemetry/telemetry_service.dart';
import '../../../data/models/auth/registration_progress_model.dart';
import '../../../routes/app_pages.dart';
import '../../controllers/session_context_controller.dart';
import '../../widgets/wizard/bottom_sheet_selector.dart';
import '../../widgets/wizard/wizard_bottom_bar.dart';
import '../controllers/registration_controller.dart';

/// Selección de Perfil (tipo de usuario + rol)
/// Incluye pregunta contextual y un cuadro informativo que
/// explica qué rol(es) y workspace(s) se habilitarán al continuar.
class SelectProfilePage extends StatefulWidget {
  const SelectProfilePage({super.key});

  @override
  State<SelectProfilePage> createState() => _SelectProfilePageState();
}

// ---- Enums para follow-ups ----
enum AdminFU { own, third, both }

enum OwnerFU { self, third, both }

// ---- Helpers de serialización ----
String? _encodeAdminFU(AdminFU? v) {
  if (v == null) return null;
  switch (v) {
    case AdminFU.own:
      return 'own';
    case AdminFU.third:
      return 'third';
    case AdminFU.both:
      return 'both';
  }
}

String? _encodeOwnerFU(OwnerFU? v) {
  if (v == null) return null;
  switch (v) {
    case OwnerFU.self:
      return 'self';
    case OwnerFU.third:
      return 'third';
    case OwnerFU.both:
      return 'both';
  }
}

AdminFU? _decodeAdminFU(String? s) {
  if (s == null) return null;
  switch (s) {
    case 'own':
      return AdminFU.own;
    case 'third':
      return AdminFU.third;
    case 'both':
      return AdminFU.both;
    default:
      return null;
  }
}

OwnerFU? _decodeOwnerFU(String? s) {
  if (s == null) return null;
  switch (s) {
    case 'self':
      return OwnerFU.self;
    case 'third':
      return OwnerFU.third;
    case 'both':
      return OwnerFU.both;
    default:
      return null;
  }
}

class _SelectProfilePageState extends State<SelectProfilePage> {
  // Estado base
  String? _holderType; // 'persona' | 'empresa'
  String? _role; // clave interna del rol
  String? _roleLabel;

  // Seguimientos contextuales (usando enums)
  AdminFU? _adminFollowUp;
  OwnerFU? _ownerFollowUp;

  // Aceptación de términos y condiciones.
  // En append mode se omite el checkbox — el usuario ya los aceptó al registrarse.
  bool _termsAccepted = false;

  // URL temporal de T&C — reemplazar con la URL propia cuando esté disponible.
  static const _termsUrl = 'https://saludtotal.com.co/';

  late RegistrationController _reg;
  SessionContextController? _session;
  TelemetryService? _telemetry;
  late DateTime _openedAt;

  // Getter para modo append
  bool get _appendMode =>
      (Get.parameters['append'] == '1') ||
      ((Get.arguments is Map) && ((Get.arguments as Map)['append'] == true));

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();
    _reg = Get.find<RegistrationController>();
    _session = Get.isRegistered<SessionContextController>()
        ? Get.find<SessionContextController>()
        : null;
    _telemetry = Get.isRegistered<TelemetryService>()
        ? Get.find<TelemetryService>()
        : null;

    if (!_appendMode) {
      final p = _reg.progress.value;
      _holderType = p?.titularType?.isNotEmpty == true ? p!.titularType : null;
      _role = p?.selectedRole?.isNotEmpty == true ? p!.selectedRole : null;

      // Restaurar follow-ups desde el modelo
      _adminFollowUp = _decodeAdminFU(p?.adminFollowUp);
      _ownerFollowUp = _decodeOwnerFU(p?.ownerFollowUp);

      if (_holderType != null && _role != null) {
        final items = _rolesByHolder(_holderType!);
        _roleLabel = items.firstWhereOrNull((e) => e.value == _role)?.label;
      }

      _log(_appendMode ? 'profile_add_workspace_start' : 'profile_open',
          extra: {
            'holderType': _holderType,
            'role': _role,
            'admin_followup': _encodeAdminFU(_adminFollowUp),
            'owner_followup': _encodeOwnerFU(_ownerFollowUp),
            'country': p?.countryId,
            'region': p?.regionId,
            'city': p?.cityId,
            'append_mode': _appendMode,
          });
    }
  }

  // Flags de rol seleccionado
  bool get _isAdminRoleSelected =>
      _role != null &&
      (_role!.startsWith('admin_activos') || _role == 'admin_activos_org');

  bool get _isOwnerRoleSelected =>
      _role == 'propietario' || _role == 'propietario_emp';

  // Validación continuar
  bool get _canContinue {
    if (_holderType == null || _holderType!.isEmpty) return false;
    if (_role == null || _role!.isEmpty) return false;
    if (_isAdminRoleSelected && _adminFollowUp == null) return false;
    if (_isOwnerRoleSelected && _ownerFollowUp == null) return false;
    // En append mode el usuario ya aceptó T&C — no se requiere de nuevo.
    if (!_appendMode && !_termsAccepted) return false;
    return true;
  }

  // Selector tipo de usuario
  Future<void> _selectHolderType() async {
    final items = [
      SelectorItem(
        value: 'persona',
        label: 'Persona',
        subtitle: 'Actúas como persona natural',
      ),
      SelectorItem(
        value: 'empresa',
        label: 'Empresa',
        subtitle: 'Actúas representando a una empresa',
      ),
    ];
    final openedAt = DateTime.now();
    _log('sheet_open',
        extra: {'step': 'holder_type', 'items_count': items.length});

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BottomSheetSelector<String>(
        title: 'Tipo de usuario',
        items: items,
        selectedValue: _holderType,
        onSelect: (it) async {
          HapticFeedback.lightImpact();
          final changed = _holderType != it.value;
          setState(() {
            _holderType = it.value;
            if (changed) {
              _role = null;
              _roleLabel = null;
              _adminFollowUp = null;
              _ownerFollowUp = null;
            }
          });
          await _reg.setTitularType(it.value);
          if (changed) await _reg.clearSelectedRole();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Seleccionado: ${it.label}')));
          _log('sheet_select', extra: {
            'step': 'holder_type',
            'selected_id': it.value,
            'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
          });
        },
      ),
    );
  }

  // Bottom sheet de roles — un único sheet con dos páginas (slide horizontal).
  // Página 0: lista de roles. Página 1: follow-up para Admin y Propietario.
  void _openRolesBottomSheet(String type) {
    final items = _rolesByHolder(type);
    _log('sheet_open', extra: {'holderType': type, 'role': _role});

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _RoleBottomSheet(
        items: items,
        holderType: type,
        initialRole: _role,
        onConfirmed: _onRoleConfirmed,
      ),
    );
  }

  /// Invocado por [_RoleBottomSheet] cuando el usuario completa la selección
  /// (rol + follow-up para Admin/Propietario, o solo rol para los demás).
  void _onRoleConfirmed(
      _RoleItem role, AdminFU? adminFU, OwnerFU? ownerFU) async {
    HapticFeedback.lightImpact();
    setState(() {
      _role = role.value;
      _roleLabel = role.label;
      _adminFollowUp = adminFU;
      _ownerFollowUp = ownerFU;
    });
    await _reg.setRole(role.value);
    if (!mounted) return;

    _log('role_select', extra: {
      'holderType': _holderType,
      'role': _role,
      'admin_followup': _encodeAdminFU(adminFU),
      'owner_followup': _encodeOwnerFU(ownerFU),
      'country': _reg.progress.value?.countryId,
      'region': _reg.progress.value?.regionId,
      'city': _reg.progress.value?.cityId,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Perfil: ${_holderType == 'empresa' ? 'Empresa' : 'Persona'} · Rol: ${role.label}'),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Getters de contexto follow-up para _AccessPreviewCard ─────────────────

  /// Título de la opción follow-up seleccionada (Admin o Propietario).
  /// Null para roles que no requieren follow-up.
  String? get _followUpLabel {
    if (_adminFollowUp != null) {
      return switch (_adminFollowUp!) {
        AdminFU.own => 'Solo los míos',
        AdminFU.third => 'Solo los de terceros',
        AdminFU.both => 'Los míos y los de terceros',
      };
    }
    if (_ownerFollowUp != null) {
      return switch (_ownerFollowUp!) {
        OwnerFU.self => 'Yo mismo administro mis activos',
        OwnerFU.third => 'Un tercero administra mis activos',
        OwnerFU.both => 'Yo administro algunos y otros un tercero',
      };
    }
    return null;
  }

  /// Subtítulo descriptivo de la opción follow-up seleccionada.
  /// Null para roles que no requieren follow-up.
  String? get _followUpSubtitle {
    if (_adminFollowUp != null) {
      return switch (_adminFollowUp!) {
        AdminFU.own => 'Administrarás únicamente activos de tu propiedad',
        AdminFU.third =>
          'Gestionarás activos de otros propietarios (Personas o empresas)',
        AdminFU.both => 'Administración mixta de activos',
      };
    }
    if (_ownerFollowUp != null) {
      return switch (_ownerFollowUp!) {
        OwnerFU.self => 'Tú gestionas la operación de tus activos',
        OwnerFU.third => 'Otra persona o empresa los administra',
        OwnerFU.both => 'Esquema mixto de administración',
      };
    }
    return null;
  }

  void _onBack() {
    try {
      Get.back();
    } catch (e) {
      debugPrint('[WARN] Navigation back failed: $e');
    }
  }

  String pickActiveRoleCode({
    required String currentRole,
    required List<String> workspaces,
    required String holderType, // 'persona' | 'empresa'
  }) {
    final ws = workspaces.map((w) => w.toLowerCase()).toList();

    bool has(String k) => ws.any((w) => w.contains(k));

    if (has('proveedor')) return 'proveedor';

    if (has('administrador')) {
      if (currentRole.startsWith('admin_activos')) return currentRole;
      return holderType == 'empresa'
          ? 'admin_activos_org'
          : 'admin_activos_ind';
    }

    if (has('propietario')) {
      return holderType == 'empresa' ? 'propietario_emp' : 'propietario';
    }

    if (has('arrendatario')) {
      return holderType == 'empresa' ? 'arrendatario_emp' : 'arrendatario';
    }

    if (has('asesor de seguros') || has('asesor')) return 'asesor_seguros';
    if (has('aseguradora')) return 'aseguradora';
    if (has('abogado')) {
      return holderType == 'empresa' ? 'abogados_firma' : 'abogado';
    }

    // Fallback: conserva el código actual
    return currentRole;
  }

  Future<void> _onContinue() async {
    if (!_canContinue) return;
    final adminFollowUpStr = _encodeAdminFU(_adminFollowUp);
    final ownerFollowUpStr = _encodeOwnerFU(_ownerFollowUp);
    final elapsed = DateTime.now().difference(_openedAt).inMilliseconds;

    // MODO APPEND: añadir workspace a sesión existente
    if (_appendMode) {
      final preview = _reg.resolveAccessPreview(
        selectedRole: _role,
        adminFollowUp: adminFollowUpStr,
        ownerFollowUp: ownerFollowUpStr,
      );
      await _handleAppendMode(
        activeRoleCode: _role!,
        newWorkspaces: preview.workspaces,
        adminFollowUpStr: adminFollowUpStr,
        ownerFollowUpStr: ownerFollowUpStr,
        elapsed: elapsed,
      );
    } else {
      await _reg.setTitularType(_holderType!);

      if (_isAdminRoleSelected && adminFollowUpStr != null) {
        await _reg.setAdminFollowUp(adminFollowUpStr);
      }
      if (_isOwnerRoleSelected && ownerFollowUpStr != null) {
        await _reg.setOwnerFollowUp(ownerFollowUpStr);
      }

      // 1) Resolver y persistir workspaces finales
      await _reg.resolveAndSaveWorkspaces(
        selectedRole: _role!, // código interno elegido en UI
        adminFollowUp: adminFollowUpStr,
        ownerFollowUp: ownerFollowUpStr,
      );

      // 2) Leer fuente de verdad y fijar rol ACTIVO coherente
      final p = _reg.progress.value;
      final finalRoles = p?.resolvedRoles ?? const <String>[];
      final finalWorkspaces = p?.resolvedWorkspaces ?? const <String>[];

      final activeRoleCode = pickActiveRoleCode(
        currentRole: _role!,
        workspaces: finalWorkspaces,
        holderType: _holderType!,
      );
      await _reg.setRole(activeRoleCode);
      // 3) Telemetría (flujo original)
      _log('profile_continue', extra: {
        'holderType': _holderType,
        'role_selected_code': activeRoleCode,
        'admin_followup': adminFollowUpStr,
        'owner_followup': ownerFollowUpStr,
        'roles_finales': finalRoles.join(','),
        'workspaces_finales': finalWorkspaces.join(','),
        'duration_ms': elapsed,
      });

      // 4) Aceptar T&C (el checkbox ya fue validado en _canContinue).
      await _reg.acceptTerms();

      // 5) Navegación basada en workspaces resueltos (flujo original).
      // Proveedores van a providerProfile primero; todos los demás van a
      // registerSummary → finalizeRegistration.
      // NUNCA saltar a Routes.home desde aquí en el flujo de registro.
      String routeForWorkspaces(List<String> wss) {
        final low = wss.map((w) => w.toLowerCase()).toList();
        if (low.any((w) => w.contains('proveedor'))) {
          return Routes.providerProfile;
        }
        return Routes.registerSummary;
      }

      final passedNext = (Get.parameters['next'] ??
          (Get.arguments is String ? Get.arguments as String : null));
      final nextRoute = passedNext ?? routeForWorkspaces(finalWorkspaces);

      try {
        final pushInsteadOfReplace = finalWorkspaces.any(
          (w) => w.toLowerCase().contains('proveedor'),
        );
        if (pushInsteadOfReplace) {
          Get.toNamed(nextRoute);
        } else {
          Get.offAllNamed(nextRoute);
        }
      } catch (e) {
        debugPrint('[WARN] Navigation to $nextRoute failed: $e');
      }
    }
  }

  // Helper para normalizar workspaces/roles
  String _normalizeWorkspace(String w) {
    return w.toLowerCase().trim();
  }

  // Modal de workspace duplicado
  Future<void> _showWorkspaceExistsModal(String role) async {
    if (!mounted) return;

    // Capitalizar primera letra y poner en negrita
    final formattedRole = (role).isEmpty
        ? ''
        : role[0].toUpperCase() + role.substring(1).toLowerCase();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Workspace existente'),
        content: RichText(
          text: TextSpan(
            style: Theme.of(ctx).textTheme.bodyMedium,
            children: [
              const TextSpan(text: 'El workspace de '),
              TextSpan(
                text: formattedRole,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' ya existe en tu cuenta actual.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAppendMode({
    required String activeRoleCode,
    required List<String> newWorkspaces,
    required String? adminFollowUpStr,
    required String? ownerFollowUpStr,
    required int elapsed,
  }) async {
    // Helper para determinar ruta según workspace
    String routeForWorkspaces(List<String> wss) {
      final low = wss.map((w) => w.toLowerCase()).toList();
      if (low.any((w) => w.contains('proveedor'))) {
        return Routes.providerProfile;
      }
      if (low.any((w) => w.contains('administrador'))) return Routes.home;
      if (low.any((w) => w.contains('propietario'))) return Routes.home;
      if (low.any((w) => w.contains('arrendatario'))) return Routes.home;
      if (low.any((w) => w.contains('aseguradora'))) return Routes.home;
      if (low.any((w) => w.contains('asesor'))) return Routes.home;
      if (low.any((w) => w.contains('abogado'))) return Routes.home;
      return Routes.home;
    }

    // a) Usuario autenticado → añadir rol a organización activa
    if (_session?.user != null) {
      // Validar que existe organización elegible
      final membership = _session!.memberships.firstWhereOrNull(
            (m) => m.orgId == _session!.user?.activeContext?.orgId,
          ) ??
          _session!.memberships.firstWhereOrNull((m) => m.roles.isNotEmpty) ??
          _session!.memberships.firstOrNull;

      if (membership == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No hay organización activa para añadir el workspace. Selecciona o crea una organización primero.',
            ),
          ),
        );
        return;
      }

      // VERIFICAR SI EL WORKSPACE YA EXISTE
      final normalizedNewRole = _normalizeWorkspace(activeRoleCode);
      final existingRoles = membership.roles.map(_normalizeWorkspace).toSet();

      if (existingRoles.contains(normalizedNewRole)) {
        final overlappingRoles = membership.roles
            .where((r) => _normalizeWorkspace(r) == normalizedNewRole)
            .toList();
        _log('profile_add_workspace_skipped_exists', extra: {
          'role_attempted': activeRoleCode,
          'roles_existing': membership.roles.join(','),
          'orgId': membership.orgId,
        });
        await _showWorkspaceExistsModal(overlappingRoles[0]);
        return;
      }

      try {
        // Añadir workspace a la organización activa
        await _session!.appendWorkspaceToActiveOrg(
          role: activeRoleCode,
          providerType:
              _reg.providerType.value.isEmpty ? null : _reg.providerType.value,
        );

        // MERGE: fix append workspace - recargar memberships para reactividad
        await _session!.reloadMembershipsFromRepo();

        // Telemetría éxito
        _log('profile_add_workspace_success', extra: {
          'role_added': activeRoleCode,
          'workspaces_after': newWorkspaces.join(','),
          'duration_ms': elapsed,
        });

        // Navegar sin romper sesión
        final nextRoute = routeForWorkspaces(newWorkspaces);
        Get.offNamedUntil(
          nextRoute,
          (r) =>
              r.settings.name == Routes.home ||
              r.settings.name == Routes.profile,
        );
      } catch (e) {
        _log('profile_add_workspace_error', extra: {'error': e.toString()});
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir workspace: $e')),
        );
      }
      return;
    }

    // b) Usuario en registro (sin autenticación completa) → fusionar en progress
    final p =
        _reg.progress.value ?? (RegistrationProgressModel()..id = 'current');

    final preview = _reg.resolveAccessPreview(
      selectedRole: _role,
      adminFollowUp: adminFollowUpStr,
      ownerFollowUp: ownerFollowUpStr,
    );

    // VERIFICAR SI EL WORKSPACE YA EXISTE EN RESOLVED WORKSPACES
    final existingWorkspaces =
        p.resolvedWorkspaces.map(_normalizeWorkspace).toSet();
    final normalizedNewWorkspaces =
        preview.workspaces.map(_normalizeWorkspace).toSet();

    // Verificar si alguno de los nuevos workspaces ya existe
    final hasOverlap = normalizedNewWorkspaces.any(existingWorkspaces.contains);

    print("existingWorkspaces $existingWorkspaces");
    print("normalizedNewWorkspaces $normalizedNewWorkspaces");
    print("hasOverlap $hasOverlap");

    if (hasOverlap) {
      final overlap = normalizedNewWorkspaces.intersection(existingWorkspaces);
      _log('profile_add_workspace_skipped_exists_progress', extra: {
        'role_attempted': activeRoleCode,
        'workspaces_existing': p.resolvedWorkspaces.join(','),
        'workspaces_new': preview.workspaces.join(','),
      });
      await _showWorkspaceExistsModal(overlap.first);
      return;
    }

    final mergedRoles = {...p.resolvedRoles, ...preview.roles}.toList();

    final mergedWs = {...p.resolvedWorkspaces, ...preview.workspaces}.toList();

    p.resolvedRoles = mergedRoles;
    p.resolvedWorkspaces = mergedWs;
    p.selectedRole = activeRoleCode;
    await _reg.progressDS.upsert(p);

    // Determinar siguiente ruta según el rol
    String nextRoute;
    final roleLower = activeRoleCode.toLowerCase();
    if (roleLower.contains('proveedor')) {
      nextRoute = Routes.providerProfile;
    } else if (roleLower.contains('administrador') ||
        roleLower.contains('propietario') ||
        roleLower.contains('arrendatario')) {
      nextRoute = Routes.home;
    } else {
      nextRoute = Routes.home;
    }

    Get.toNamed(nextRoute, parameters: {'append': '1'});
  }

  // Roles por tipo
  List<_RoleItem> _rolesByHolder(String type) {
    if (type == 'empresa') {
      return const [
        _RoleItem('propietario_emp', 'Propietario de activos',
            'Organizaciones dueñas de activos'),
        _RoleItem('admin_activos_org', 'Administrador de activos',
            'Empresas que gestionan activos'),
        _RoleItem('arrendatario_emp', 'Arrendatario de activos',
            'Empresas que arriendan activos'),
        _RoleItem('proveedor', 'Proveedor', 'Talleres, constructoras, firmas'),
        _RoleItem('aseguradora', 'Aseguradora / Broker',
            'Empresas que ofrecen pólizas y seguros'),
        _RoleItem('abogados_firma', 'Abogados (firmas/despachos)',
            'Firmas legales especializadas'),
      ];
    }
    return const [
      _RoleItem('propietario', 'Propietario de activos',
          'Dueños de activos que son administrados por otros'),
      _RoleItem('admin_activos_ind', 'Administrador de activos',
          'Gestiona y administra activos propios o de terceros'),
      _RoleItem('arrendatario', 'Arrendatario de activos',
          'Reciben un activo en calidad de arriendo. Ej. Conductor (Vehículo), Inquilino (Inmueble)'),
      _RoleItem('proveedor', 'Proveedor',
          'Ofrece Productos o Servicios para mantenimiento y reparación de activos'),
      _RoleItem('asesor_seguros', 'Asesor de seguros',
          'Profesionales que asesoran/venden seguros'),
      _RoleItem('abogado', 'Abogado', 'Especialistas legales y reclamaciones'),
    ];
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Usar el resolver del controlador para el preview
    final preview = (_isAdminRoleSelected && _adminFollowUp != null) ||
            (_isOwnerRoleSelected && _ownerFollowUp != null)
        ? _reg.resolveAccessPreview(
            selectedRole: _role,
            adminFollowUp: _encodeAdminFU(_adminFollowUp),
            ownerFollowUp: _encodeOwnerFU(_ownerFollowUp),
          )
        : null;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Volver'), // El 'textAlign' no es necesario aquí.
      //   centerTitle: false, // ¡Esta es la clave!
      //   // bottom: PreferredSize(
      //   //    ... (código comentado)
      //   // ),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: _onBack,
      //     tooltip: 'Volver',
      //   ),
      // ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Selecciona el modo\ncon el que te identifiques\n",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20,
          ),
          // Tipo de usuario
          ListTile(
            title: const Text('Tipo de usuario'),
            subtitle: Text(
              _holderType == null
                  ? 'Selecciona tu tipo'
                  : (_holderType == 'persona' ? 'Persona' : 'Empresa'),
              style: TextStyle(color: theme.hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _selectHolderType,
          ),
          const Divider(),

          // Rol
          ListTile(
            title: const Text('Tu rol'),
            subtitle: Text(
              _roleLabel ?? 'Selecciona un rol',
              style: TextStyle(color: theme.hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () {
              if (_holderType == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Primero elige el tipo de usuario')),
                );
                return;
              }
              _openRolesBottomSheet(_holderType!);
            },
          ),
          const Divider(),

          // Follow-up seleccionado dentro del sheet — ya no hay radio tiles inline.

          // Cuadro informativo dinámico
          if (preview != null) ...[
            _AccessPreviewCard(
              preview: preview,
              contextLabel: _followUpLabel,
              contextSubtitle: _followUpSubtitle,
            ),
            if (_appendMode) ...[
              const SizedBox(height: 8),
              Text(
                'Estás añadiendo un nuevo workspace a tu sesión.',
                style:
                    theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
              ),
            ],
          ],

          // Checkbox de T&C — solo en flujo de registro, no en append mode.
          if (!_appendMode) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (v) =>
                      setState(() => _termsAccepted = v ?? false),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final uri = Uri.parse(_termsUrl);
                      if (!await launchUrl(uri,
                          mode: LaunchMode.externalApplication)) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No se pudo abrir los términos y condiciones'),
                          ),
                        );
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall,
                        children: [
                          const TextSpan(text: 'Acepto los '),
                          TextSpan(
                            text: 'Términos y condiciones',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
      bottomNavigationBar: WizardBottomBar(
        onBack: _onBack,
        onContinue: _onContinue,
        continueEnabled: _canContinue,
      ),
    );
  }

  void _log(String event, {Map<String, Object?>? extra}) {
    try {
      _telemetry?.log(event, {
        'holderType': _holderType,
        'role': _role,
        'country': _reg.progress.value?.countryId,
        'region': _reg.progress.value?.regionId,
        'city': _reg.progress.value?.cityId,
        if (extra != null) ...extra,
      });
    } catch (_) {}
  }
}

// ---- Modelos UI auxiliares ----
class _RoleItem {
  final String value;
  final String label;
  final String description;
  const _RoleItem(this.value, this.label, this.description);
}

// ---- Acceso sugerido ----
class _AccessPreviewCard extends StatelessWidget {
  final AccessPreview preview;

  /// Título de la opción follow-up seleccionada (Admin/Propietario).
  /// Null para roles sin follow-up → muestra texto genérico.
  final String? contextLabel;

  /// Subtítulo descriptivo del follow-up seleccionado.
  final String? contextSubtitle;

  const _AccessPreviewCard({
    required this.preview,
    this.contextLabel,
    this.contextSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user,
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Acceso que se habilitará',
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: preview.workspaces
                  .map((w) => Chip(
                        label: Text(w),
                        avatar: const Icon(Icons.dashboard_customize, size: 16),
                        visualDensity: const VisualDensity(vertical: -3),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 12),
            // Cuando hay follow-up seleccionado muestra la opción elegida;
            // para roles sin follow-up mantiene el texto genérico original.
            Text(
              contextLabel ??
                  'Al continuar se creará y activará el/los workspace(s) indicados.',
              style: theme.textTheme.bodySmall!.copyWith(
                color: contextLabel != null
                    ? theme.colorScheme.onSurface
                    : theme.hintColor,
                fontWeight: contextLabel != null
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
            if (contextSubtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                contextSubtitle!,
                style:
                    theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---- Sheet de roles con slide horizontal ----

/// Bottom sheet con dos páginas internas animadas con slide horizontal:
/// - Página 0: lista de roles disponibles para el tipo de usuario.
/// - Página 1: opciones de follow-up (solo para Administrador y Propietario).
///
/// Para roles que no requieren follow-up, la selección cierra el sheet
/// directamente desde la página 0. Para Admin/Propietario, desliza a la
/// página 1 donde el usuario completa la selección antes de cerrar.
class _RoleBottomSheet extends StatefulWidget {
  final List<_RoleItem> items;
  final String holderType;
  final String? initialRole;
  final void Function(_RoleItem role, AdminFU? adminFU, OwnerFU? ownerFU)
      onConfirmed;

  const _RoleBottomSheet({
    required this.items,
    required this.holderType,
    required this.onConfirmed,
    this.initialRole,
  });

  @override
  State<_RoleBottomSheet> createState() => _RoleBottomSheetState();
}

class _RoleBottomSheetState extends State<_RoleBottomSheet> {
  late final PageController _pageCtrl;
  _RoleItem? _pendingRole;

  static const _slideDuration = Duration(milliseconds: 280);
  static const _slideCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  bool _needsFollowUp(_RoleItem role) =>
      role.value.startsWith('admin_activos') ||
      role.value == 'propietario' ||
      role.value == 'propietario_emp';

  bool get _isPendingAdmin =>
      _pendingRole != null &&
      _pendingRole!.value.startsWith('admin_activos');

  void _onTapRole(_RoleItem role) {
    HapticFeedback.lightImpact();
    if (_needsFollowUp(role)) {
      setState(() => _pendingRole = role);
      _pageCtrl.animateToPage(1,
          duration: _slideDuration, curve: _slideCurve);
    } else {
      widget.onConfirmed(role, null, null);
      Navigator.of(context).pop();
    }
  }

  void _onTapBack() {
    _pageCtrl.animateToPage(0,
        duration: _slideDuration, curve: _slideCurve);
  }

  void _onSelectFollowUp({AdminFU? adminFU, OwnerFU? ownerFU}) {
    HapticFeedback.lightImpact();
    widget.onConfirmed(_pendingRole!, adminFU, ownerFU);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final titleSuffix =
        widget.holderType == 'empresa' ? 'Empresa' : 'Persona';
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (ctx, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            // Drag handle visual
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildRolePage(ctx, scrollController, titleSuffix),
                  _buildFollowUpPage(ctx),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRolePage(BuildContext context, ScrollController scrollController,
      String titleSuffix) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Text(
          'Elige tu rol — $titleSuffix',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...widget.items.map((item) {
          final isSelected = widget.initialRole == item.value;
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            title: Text(item.label),
            subtitle: Text(
              item.description,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: isSelected
                ? Icon(Icons.check,
                    color: Theme.of(context).colorScheme.primary)
                : _needsFollowUp(item)
                    ? Icon(Icons.chevron_right_rounded,
                        size: 20, color: Theme.of(context).hintColor)
                    : null,
            onTap: () => _onTapRole(item),
            minVerticalPadding: 12,
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFollowUpPage(BuildContext context) {
    final theme = Theme.of(context);
    if (_pendingRole == null) return const SizedBox.shrink();

    final isAdmin = _isPendingAdmin;
    final title = isAdmin
        ? '¿Qué activos administrarás?'
        : '¿Quién administra tus activos?';

    final options = isAdmin
        ? [
            (
              label: 'Solo los míos',
              subtitle: 'Administrarás únicamente activos de tu propiedad',
              onTap: () => _onSelectFollowUp(adminFU: AdminFU.own),
            ),
            (
              label: 'Solo los de terceros',
              subtitle:
                  'Gestionarás activos de otros propietarios (Personas o empresas)',
              onTap: () => _onSelectFollowUp(adminFU: AdminFU.third),
            ),
            (
              label: 'Los míos y los de terceros',
              subtitle: 'Administración mixta de activos',
              onTap: () => _onSelectFollowUp(adminFU: AdminFU.both),
            ),
          ]
        : [
            (
              label: 'Yo mismo administro mis activos',
              subtitle: 'Tú gestionas la operación de tus activos',
              onTap: () => _onSelectFollowUp(ownerFU: OwnerFU.self),
            ),
            (
              label: 'Un tercero administra mis activos',
              subtitle: 'Otra persona o empresa los administra',
              onTap: () => _onSelectFollowUp(ownerFU: OwnerFU.third),
            ),
            (
              label: 'Yo administro algunos y otros un tercero',
              subtitle: 'Esquema mixto de administración',
              onTap: () => _onSelectFollowUp(ownerFU: OwnerFU.both),
            ),
          ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: _onTapBack,
              tooltip: 'Volver a roles',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 2, bottom: 8),
          child: Text(
            _pendingRole!.label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.hintColor),
          ),
        ),
        ...options.map(
          (opt) => ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            title: Text(opt.label),
            subtitle: Text(
              opt.subtitle,
              style: TextStyle(color: theme.hintColor),
            ),
            onTap: opt.onTap,
            minVerticalPadding: 12,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
