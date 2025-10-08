import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../services/telemetry/telemetry_service.dart';
import '../../../routes/app_pages.dart';
import '../../widgets/wizard/bottom_sheet_selector.dart';
import '../../widgets/wizard/wizard_bottom_bar.dart';
import '../controllers/registration_controller.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});
  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  late final RegistrationController _reg;
  TelemetryService? _telemetry;

  String? _providerType; // articulos|servicios
  String?
      _segment; // vehiculos|inmuebles|equipos_construccion|maquinaria|otros_equipos
  String? _vehicleType; // si segment==vehiculos
  String? _category; // dependiente del segmento

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
    _telemetry = Get.isRegistered<TelemetryService>()
        ? Get.find<TelemetryService>()
        : null;
    final p = _reg.progress.value;
    _providerType = p?.providerType;
    _segment = p?.segment;
    _vehicleType = p?.vehicleType;
    _category = p?.providerCategory;
  }

  bool get _canContinue {
    final base = _providerType != null && _segment != null && _category != null;
    return _segment == 'vehiculos' ? base && _vehicleType != null : base;
  }

  void _log(String event, Map<String, Object?> extra) {
    try {
      _telemetry?.log(event, {
        'providerType': _providerType,
        'segment': _segment,
        'vehicleType': _vehicleType,
        'category': _category,
        ...extra,
      });
    } catch (_) {}
  }

  Future<void> _selectProviderType() async {
    final items = [
      SelectorItem(
          value: 'articulos',
          label: 'Productos',
          subtitle: 'Ofreces artículos o repuestos.'),
      SelectorItem(
          value: 'servicios',
          label: 'Servicios',
          subtitle: 'Ofreces mantenimientos o asistencia técnica.'),
    ];
    _log('sheet_open', {'step': 'provider_type', 'items_count': items.length});
    final openedAt = DateTime.now();
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (_) => BottomSheetSelector<String>(
          title: 'Tipo de proveedor',
          items: items,
          selectedValue: _providerType,
          onSelect: (it) async {
            HapticFeedback.lightImpact();
            setState(() => _providerType = it.value);
            await _reg.setProviderType(it.value);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
            _log('sheet_select', {
              'step': 'provider_type',
              'selected_id': it.value,
              'selected_label': it.label,
              'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
            });
          },
        ),
      );
      if (items.isEmpty)
        _log('sheet_error', {'step': 'provider_type', 'cause': 'items_empty'});
    } catch (e) {
      _log('sheet_error', {'step': 'provider_type', 'cause': e.toString()});
    }
  }

  Future<void> _selectSegment() async {
    final items = [
      SelectorItem(value: 'vehiculos', label: 'Vehículos'),
      SelectorItem(value: 'inmuebles', label: 'Inmuebles'),
      SelectorItem(
          value: 'equipos_construccion', label: 'Equipos de construcción'),
      SelectorItem(value: 'maquinaria', label: 'Maquinaria'),
      SelectorItem(value: 'otros_equipos', label: 'Otros equipos'),
    ];
    _log('sheet_open', {'step': 'segment', 'items_count': items.length});
    final openedAt = DateTime.now();
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (_) => BottomSheetSelector<String>(
          title: 'Segmento que atiendes',
          items: items,
          selectedValue: _segment,
          onSelect: (it) async {
            HapticFeedback.lightImpact();
            setState(() {
              _segment = it.value;
              _vehicleType = null;
              _category = null;
            });
            await _reg.setSegment(it.value);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
            _log('sheet_select', {
              'step': 'segment',
              'selected_id': it.value,
              'selected_label': it.label,
              'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
            });
          },
        ),
      );
      if (items.isEmpty)
        _log('sheet_error', {'step': 'segment', 'cause': 'items_empty'});
    } catch (e) {
      _log('sheet_error', {'step': 'segment', 'cause': e.toString()});
    }
  }

  Future<void> _selectVehicleType() async {
    final items = [
      SelectorItem(value: 'motos', label: 'Motos'),
      SelectorItem(value: 'autos_livianos', label: 'Autos y livianos'),
      SelectorItem(value: 'camiones', label: 'Camiones'),
      SelectorItem(value: 'pesados', label: 'Pesados/Amarillos'),
      SelectorItem(value: 'flotas_mixtas', label: 'Flotas mixtas'),
    ];
    _log('sheet_open', {'step': 'vehicle_type', 'items_count': items.length});
    final openedAt = DateTime.now();
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (_) => BottomSheetSelector<String>(
          title: 'Tipo de vehículo',
          items: items,
          selectedValue: _vehicleType,
          onSelect: (it) async {
            HapticFeedback.lightImpact();
            setState(() {
              _vehicleType = it.value;
              _category = null;
            });
            await _reg.setVehicleType(it.value);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
            _log('sheet_select', {
              'step': 'vehicle_type',
              'selected_id': it.value,
              'selected_label': it.label,
              'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
            });
          },
        ),
      );
      if (_segment == 'vehiculos' && items.isEmpty)
        _log('sheet_error', {'step': 'vehicle_type', 'cause': 'items_empty'});
    } catch (e) {
      _log('sheet_error', {'step': 'vehicle_type', 'cause': e.toString()});
    }
  }

  List<SelectorItem<String>> _categoryItemsFor(String segment) {
    switch (segment) {
      case 'vehiculos':
        return [
          SelectorItem(value: 'lubricentro', label: 'Lubricentro'),
          SelectorItem(value: 'llanteria', label: 'Llantería'),
          SelectorItem(value: 'carwash', label: 'CarWash'),
          SelectorItem(value: 'taller_mecanico', label: 'Taller mecánico'),
          SelectorItem(value: 'accesorios', label: 'Accesorios'),
        ];
      case 'inmuebles':
        return [
          SelectorItem(value: 'ferreteria', label: 'Ferretería'),
          SelectorItem(value: 'pisos_enchapes', label: 'Pisos y enchapes'),
          SelectorItem(value: 'pinturas', label: 'Pinturas'),
          SelectorItem(value: 'plomeria', label: 'Plomería'),
        ];
      case 'maquinaria':
      case 'equipos_construccion':
      case 'otros_equipos':
        return [
          SelectorItem(value: 'arriendo', label: 'Arriendo'),
          SelectorItem(value: 'mantenimiento', label: 'Mantenimiento'),
          SelectorItem(value: 'repuestos', label: 'Repuestos'),
        ];
      default:
        return [];
    }
  }

  Future<void> _selectCategory() async {
    final items = _segment == null
        ? <SelectorItem<String>>[]
        : _categoryItemsFor(_segment!);
    final showSearch = items.length > 10;
    _log('sheet_open', {'step': 'category', 'items_count': items.length});
    final openedAt = DateTime.now();
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (_) => BottomSheetSelector<String>(
          title: 'Categoría',
          items: items,
          selectedValue: _category,
          onSelect: (it) async {
            HapticFeedback.lightImpact();
            setState(() => _category = it.value);
            await _reg.setProviderCategory(it.value);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
            _log('sheet_select', {
              'step': 'category',
              'selected_id': it.value,
              'selected_label': it.label,
              'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
            });
          },
          showSearch: showSearch,
        ),
      );
      if (_segment != null && items.isEmpty)
        _log('sheet_error', {'step': 'category', 'cause': 'items_empty'});
    } catch (e) {
      _log('sheet_error', {'step': 'category', 'cause': e.toString()});
    }
  }

  Future<void> _onContinue() async {
    final next = Get.parameters['next'] ??
        (Get.arguments is String ? Get.arguments as String : null) ??
        Routes.providerCoverage; // fallback por defecto
    _log('wizard_continue', {'next': next});
    if (!mounted) return;
    Get.toNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del proveedor'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('Completa tu información comercial',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Tipo de proveedor'),
            subtitle: Text(
              _providerType == 'articulos'
                  ? 'Productos'
                  : (_providerType == 'servicios'
                      ? 'Servicios'
                      : '¿Qué ofreces?'),
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _selectProviderType,
          ),
          const Divider(),
          ListTile(
            title: const Text('Segmento que atiendes'),
            subtitle: Text(
              _segment != null
                  ? _segmentLabel(_segment!)
                  : '¿A qué activos das servicio?',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _selectSegment,
          ),
          const Divider(),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            child: _segment == 'vehiculos'
                ? Column(
                    children: [
                      ListTile(
                        title: const Text('Tipo de vehículo'),
                        subtitle: Text(
                          _vehicleType != null
                              ? _vehicleTypeLabel(_vehicleType!)
                              : '¿En qué vehículos te especializas?',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_down),
                        onTap: _selectVehicleType,
                      ),
                      const Divider(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          ListTile(
            title: const Text('Categoría'),
            subtitle: Text(
              _category != null
                  ? _categoryLabel(_category!)
                  : '¿Qué tipo de negocio eres?',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _selectCategory,
          ),
          const Divider(),
        ],
      ),
      bottomNavigationBar: WizardBottomBar(
        onBack: () => Get.back(),
        onContinue: _onContinue,
        continueEnabled: _canContinue,
      ),
    );
  }

  String _segmentLabel(String v) {
    switch (v) {
      case 'vehiculos':
        return 'Vehículos';
      case 'inmuebles':
        return 'Inmuebles';
      case 'equipos_construccion':
        return 'Equipos de construcción';
      case 'maquinaria':
        return 'Maquinaria';
      case 'otros_equipos':
        return 'Otros equipos';
      default:
        return v;
    }
  }

  String _vehicleTypeLabel(String v) {
    switch (v) {
      case 'motos':
        return 'Motos';
      case 'autos_livianos':
        return 'Autos y livianos';
      case 'camiones':
        return 'Camiones';
      case 'pesados':
        return 'Pesados/Amarillos';
      case 'flotas_mixtas':
        return 'Flotas mixtas';
      default:
        return v;
    }
  }

  String _categoryLabel(String v) {
    switch (v) {
      case 'lubricentro':
        return 'Lubricentro';
      case 'llanteria':
        return 'Llantería';
      case 'carwash':
        return 'CarWash';
      case 'taller_mecanico':
        return 'Taller mecánico';
      case 'accesorios':
        return 'Accesorios';
      case 'ferreteria':
        return 'Ferretería';
      case 'pisos_enchapes':
        return 'Pisos y enchapes';
      case 'pinturas':
        return 'Pinturas';
      case 'plomeria':
        return 'Plomería';
      case 'arriendo':
        return 'Arriendo';
      case 'mantenimiento':
        return 'Mantenimiento';
      case 'repuestos':
        return 'Repuestos';
      default:
        return v;
    }
  }
}
