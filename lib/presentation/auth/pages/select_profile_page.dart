import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../services/telemetry/telemetry_service.dart';
import '../../../routes/app_pages.dart';
import '../../widgets/wizard/bottom_sheet_selector.dart';
import '../../widgets/wizard/wizard_bottom_bar.dart';
import '../controllers/registration_controller.dart';

class SelectProfilePage extends StatefulWidget {
  const SelectProfilePage({super.key});

  @override
  State<SelectProfilePage> createState() => _SelectProfilePageState();
}

class _SelectProfilePageState extends State<SelectProfilePage> {
  String? _holderType; // 'persona' | 'empresa'
  String? _role; // valor normalizado
  String? _roleLabel; // etiqueta legible
  late RegistrationController _reg;
  TelemetryService? _telemetry;
  late DateTime _openedAt;

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();
    _reg = Get.find<RegistrationController>();
    _telemetry = Get.isRegistered<TelemetryService>()
        ? Get.find<TelemetryService>()
        : null;

    final p = _reg.progress.value;
    _holderType = p?.titularType?.isNotEmpty == true ? p!.titularType : null;
    _role = p?.selectedRole?.isNotEmpty == true ? p!.selectedRole : null;

    if (_holderType != null && _role != null) {
      final items = _rolesByHolder(_holderType!);
      _roleLabel = items.firstWhereOrNull((e) => e.value == _role)?.label;
    }

    _log('profile_open', extra: {
      'holderType': _holderType,
      'role': _role,
      'country': p?.countryId,
      'region': p?.regionId,
      'city': p?.cityId,
    });

    if (Get.currentRoute == Routes.holderType ||
        Get.currentRoute == Routes.role) {
      _log('legacy_profile_route_access', extra: {'from': Get.currentRoute});
    }
  }

  bool get _canContinue =>
      _holderType != null &&
      _holderType!.isNotEmpty &&
      _role != null &&
      _role!.isNotEmpty;

  Future<void> _selectHolderType() async {
    final items = [
      SelectorItem(
          value: 'persona',
          label: 'Persona',
          subtitle: 'Actúas como persona natural'),
      SelectorItem(
          value: 'empresa',
          label: 'Empresa',
          subtitle: 'Actúas representando a una empresa'),
    ];
    _log('sheet_open', extra: {
      'step': 'holder_type',
      'items_count': items.length,
      'holderType': _holderType
    });
    final openedAt = DateTime.now();

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
            }
          });
          await _reg.setTitularType(it.value);
          if (changed) await _reg.clearSelectedRole();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Seleccionado: ${it.label}')),
          );
          _log('sheet_select', extra: {
            'step': 'holder_type',
            'selected_id': it.value,
            'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
          });
        },
      ),
    );
  }

  void _onSelectRole(_RoleItem role) async {
    HapticFeedback.lightImpact();
    setState(() {
      _role = role.value;
      _roleLabel = role.label;
    });
    await _reg.setRole(role.value);

    _log('role_select', extra: {
      'holderType': _holderType,
      'role': _role,
      'country': _reg.progress.value?.countryId,
      'region': _reg.progress.value?.regionId,
      'city': _reg.progress.value?.cityId,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Perfil: ${_holderType == 'empresa' ? 'Empresa' : 'Persona'} · Rol: ${role.label}'),
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  void _onBack() async {
    try {
      Get.back();
      // Get.offNamed(Routes.countryCity);
    } catch (e) {
      debugPrint('[WARN] Navigation back to ${Routes.countryCity} failed: $e');
    }
  }

  Future<void> _onContinue() async {
    if (!_canContinue) return;
    final elapsed = DateTime.now().difference(_openedAt).inMilliseconds;

    await _reg.setTitularType(_holderType!);
    await _reg.setRole(_role!);

    _log('profile_continue', extra: {
      'holderType': _holderType,
      'role': _role,
      'country': _reg.progress.value?.countryId,
      'region': _reg.progress.value?.regionId,
      'city': _reg.progress.value?.cityId,
      'duration_ms': elapsed,
    });

    final passedNext = (Get.parameters['next'] ??
        (Get.arguments is String ? Get.arguments as String : null));
    final nextRoute = passedNext ??
        (_role == 'proveedor' ? Routes.providerProfile : Routes.home);
    try {
      if (_role == 'proveedor') {
        Get.toNamed(nextRoute);
      } else {
        Get.offAllNamed(nextRoute);
      }
    } catch (e) {
      debugPrint('[WARN] Navigation to $nextRoute failed: $e');
    }
  }

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
      builder: (_) {
        final titleSuffix = type == 'empresa' ? 'Empresa' : 'Persona';
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Text('Elige tu rol — $titleSuffix',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...items.map((item) {
                  final isSelected = _role == item.value;
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    title: Text(item.label),
                    subtitle: Text(item.description,
                        style: TextStyle(color: Theme.of(context).hintColor)),
                    trailing: isSelected
                        ? Icon(Icons.check,
                            color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () => _onSelectRole(item),
                    minVerticalPadding: 12,
                  );
                }),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

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
          'Recibien un activo en calidad de arriendo. Ej. Conductor (Vehículo), Inquilino (Inmueble)'),
      _RoleItem('proveedor', 'Proveedor',
          'Ofrece Productos o Servicios para mantenimiento y reparación de activos (Ej. Vehículos, Inmuebles)'),
      _RoleItem('asesor_seguros', 'Asesor de seguros',
          'Profesionales que asesoran/venden distintos tipos de seguros'),
      _RoleItem('abogado', 'Abogado',
          'Especialistas legales (Accidentes de tránsito, reclamaciones, ventas o arriendos de activos, etc)'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('Completa la información de tu perfil',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBack,
          tooltip: 'Volver',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Tipo de usuario'),
            subtitle: Text(
              _holderType == null
                  ? 'Selecciona tu tipo'
                  : (_holderType == 'persona' ? 'Persona' : 'Empresa'),
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _selectHolderType,
          ),
          const Divider(),
          ListTile(
            title: const Text('Tu rol'),
            subtitle: Text(
              _roleLabel ?? 'Selecciona un rol',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () {
              if (_holderType == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Primero elige el tipo de usuario')));
                return;
              }
              _openRolesBottomSheet(_holderType!);
            },
          ),
          const Divider(),
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

class _RoleItem {
  final String value;
  final String label;
  final String description;
  const _RoleItem(this.value, this.label, this.description);
}
