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

  String? _providerType; // 'articulos' | 'servicios'
  String? _assetType; // ej. 'vehiculos' | 'inmuebles' | etc.
  String? _assetSegment; // ej. 'motos' | 'camiones' | etc.
  String? _businessCategory; // categoría de negocio

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
    _telemetry = Get.isRegistered<TelemetryService>()
        ? Get.find<TelemetryService>()
        : null;

    final p = _reg.progress.value;
    _providerType = p?.providerType;
    _assetType =
        (p?.assetTypeIds.isNotEmpty ?? false) ? p!.assetTypeIds.first : null;
    _assetSegment = (p?.assetSegmentIds.isNotEmpty ?? false)
        ? p!.assetSegmentIds.first
        : null;
    _businessCategory = p?.businessCategoryId;
  }

  bool get _canContinue {
    final hasProviderType = _providerType != null && _providerType!.isNotEmpty;
    final base =
        hasProviderType && _assetType != null && _businessCategory != null;
    return _assetType == 'vehiculos' ? base && _assetSegment != null : base;
  }

  void _log(String event, Map<String, Object?> extra) {
    try {
      _telemetry?.log(event, {
        'providerType': _providerType,
        'assetType': _assetType,
        'assetSegment': _assetSegment,
        'businessCategory': _businessCategory,
        ...extra,
      });
    } catch (_) {}
  }

  Future<void> _selectAssetType() async {
    final items = [
      SelectorItem(value: 'vehiculos', label: 'Vehículos'),
      SelectorItem(value: 'inmuebles', label: 'Inmuebles'),
      SelectorItem(
          value: 'equipos_construccion', label: 'Equipos de construcción'),
      SelectorItem(value: 'maquinaria', label: 'Maquinaria'),
      SelectorItem(value: 'otros_equipos', label: 'Otros equipos'),
    ];
    _log('sheet_open', {'step': 'asset_type', 'items_count': items.length});
    final openedAt = DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => BottomSheetSelector<String>(
        title: 'Segmento que atiendes',
        items: items,
        selectedValue: _assetType,
        onSelect: (it) async {
          HapticFeedback.lightImpact();
          setState(() {
            _assetType = it.value;
            _assetSegment = null;
            _businessCategory = null;
          });
          await _reg.setAssetTypes([it.value]);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
          }
          _log('sheet_select', {
            'step': 'asset_type',
            'selected_id': it.value,
            'selected_label': it.label,
            'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
          });
        },
      ),
    );
  }

  Future<void> _selectAssetSegment() async {
    final items = [
      SelectorItem(value: 'motos', label: 'Motos'),
      SelectorItem(value: 'autos_livianos', label: 'Autos y livianos'),
      SelectorItem(value: 'camiones', label: 'Camiones'),
      SelectorItem(value: 'pesados', label: 'Pesados/Amarillos'),
      SelectorItem(value: 'flotas_mixtas', label: 'Flotas mixtas'),
    ];
    _log('sheet_open', {'step': 'asset_segment', 'items_count': items.length});
    final openedAt = DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => BottomSheetSelector<String>(
        title: 'Tipo de vehículo',
        items: items,
        selectedValue: _assetSegment,
        onSelect: (it) async {
          HapticFeedback.lightImpact();
          setState(() {
            _assetSegment = it.value;
            _businessCategory = null;
          });
          await _reg.setAssetSegments([it.value]);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
          }
          _log('sheet_select', {
            'step': 'asset_segment',
            'selected_id': it.value,
            'selected_label': it.label,
            'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
          });
        },
      ),
    );
  }

  List<SelectorItem<String>> _categoryItemsFor(String assetType) {
    switch (assetType) {
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
    final items = _assetType == null
        ? <SelectorItem<String>>[]
        : _categoryItemsFor(_assetType!);
    final showSearch = items.length > 10;
    _log('sheet_open', {'step': 'category', 'items_count': items.length});
    final openedAt = DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => BottomSheetSelector<String>(
        title: 'Categoría',
        items: items,
        selectedValue: _businessCategory,
        onSelect: (it) async {
          HapticFeedback.lightImpact();
          setState(() => _businessCategory = it.value);
          await _reg.setBusinessCategory(it.value);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
          }
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
  }

  Future<void> _selectProviderType() async {
    final items = [
      SelectorItem(value: 'articulos', label: 'Productos (artículos)'),
      SelectorItem(value: 'servicios', label: 'Servicios'),
    ];
    _log('sheet_open', {'step': 'provider_type', 'items_count': items.length});
    final openedAt = DateTime.now();

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
          setState(() {
            _providerType = it.value;
            _assetSegment = null;
            _businessCategory = null;
          });
          await _reg.setProviderType(it.value);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionado: ${it.label}')));
          }
          _log('sheet_select', {
            'step': 'provider_type',
            'selected_id': it.value,
            'selected_label': it.label,
            'duration_ms': DateTime.now().difference(openedAt).inMilliseconds,
          });
        },
      ),
    );
  }

  Future<void> _onContinue() async {
    if (!_canContinue) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa toda la información.')),
      );
      return;
    }

    await _reg.setProviderType(_providerType!);
    await _reg.setAssetTypes([_assetType!]);
    if (_assetSegment != null) await _reg.setAssetSegments([_assetSegment!]);
    await _reg.setBusinessCategory(_businessCategory!);

    final next = Get.parameters['next'] ??
        (Get.arguments is String ? Get.arguments as String : null) ??
        Routes.providerCoverage;

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
          Text('Tipo de proveedor',
              style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            title: const Text('Tipo'),
            subtitle: Text(
              _providerType == 'articulos'
                  ? 'Productos (artículos)'
                  : _providerType == 'servicios'
                      ? 'Servicios'
                      : 'Selecciona: Productos o Servicios',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _selectProviderType,
          ),
          const Divider(),
          ListTile(
            title: const Text('Segmento que atiendes'),
            subtitle: Text(
              _assetType != null
                  ? _segmentLabel(_assetType!)
                  : '¿A qué activos das servicio?',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _selectAssetType,
          ),
          const Divider(),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            child: _assetType == 'vehiculos'
                ? Column(
                    children: [
                      ListTile(
                        title: const Text('Tipo de vehículo'),
                        subtitle: Text(
                          _assetSegment != null
                              ? _vehicleTypeLabel(_assetSegment!)
                              : '¿En qué vehículos te especializas?',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_down),
                        onTap: _selectAssetSegment,
                      ),
                      const Divider(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          ListTile(
            title: const Text('Categoría'),
            subtitle: Text(
              _businessCategory ?? '¿Qué tipo de negocio eres?',
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
}
