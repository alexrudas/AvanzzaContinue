import 'package:avanzza/data/runt/models/runt_vehicle_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/vehicle/vehicle_document_status.dart';
import '../../../../domain/entities/vehicle/vehicle_documents_snapshot.dart';
import '../../../../domain/shared/enums/asset_type.dart';
import '../../../controllers/runt/runt_controller.dart';
import '../controllers/create_portfolio_controller.dart';
import 'recurring_expenses_setup_page.dart';

/// Wizard Paso 2: Agregar activo al portafolio
///
/// Este paso se adapta según el tipo de activo seleccionado en Step1:
/// - Vehículo: Muestra formulario RUNT para consultar y registrar
/// - Otros tipos: Muestra placeholder "Próximamente"
///
/// IMPORTANTE: El assetType se lee del CreatePortfolioController compartido.
/// Si selectedAssetType es null, se muestra un fallback seguro.
class CreatePortfolioStep2Page extends StatefulWidget {
  const CreatePortfolioStep2Page({super.key});

  @override
  State<CreatePortfolioStep2Page> createState() =>
      _CreatePortfolioStep2PageState();
}

class _CreatePortfolioStep2PageState extends State<CreatePortfolioStep2Page> {
  final _formKey = GlobalKey<FormState>();

  // Controller compartido del wizard (creado en Step1)
  late final CreatePortfolioController _portfolioController;

  // Controller RUNT (solo para vehículos, inyectado via binding)
  RuntController? _runtController;

  // Estado local del formulario
  final _plateController = TextEditingController();
  String? _selectedDocType;
  final _docNumberController = TextEditingController();

  // Tipo de activo (leído del controller compartido)
  AssetType? _assetType;

  @override
  void initState() {
    super.initState();

    debugPrint('[Step2][INIT] initState START');

    // Obtener controller compartido del wizard
    _portfolioController = Get.find<CreatePortfolioController>();
    debugPrint('[Step2][INIT] CreatePortfolioController FOUND');

    // Leer assetType del controller (persistido en Step1)
    _assetType = _portfolioController.selectedAssetType.value;
    debugPrint('[Step2][INIT] assetType leído: $_assetType');

    // Si es vehículo, obtener RuntController (debe estar registrado via binding)
    if (_assetType == AssetType.vehiculo) {
      debugPrint(
          '[Step2][INIT] assetType=vehiculo → verificando RuntController');
      final isReg = Get.isRegistered<RuntController>();
      debugPrint('[Step2][INIT] Get.isRegistered<RuntController>() = $isReg');

      if (isReg) {
        _runtController = Get.find<RuntController>();
        debugPrint('[Step2][INIT] RuntController FOUND: $_runtController');
      } else {
        debugPrint(
          '[Step2][INIT][WARNING] RuntController NO registrado. La consulta RUNT no funcionará.',
        );
      }
    }

    // Log de debugging
    debugPrint('[Step2] assetType: $_assetType');
    debugPrint('[Step2] portfolioId: ${_portfolioController.portfolioId}');
    debugPrint('[Step2][INIT] initState END');
  }

  @override
  void dispose() {
    debugPrint('[Step2][DISPOSE] dispose START');
    _plateController.dispose();
    _docNumberController.dispose();
    debugPrint('[Step2][DISPOSE] dispose END');
    super.dispose();
  }

  void _handleEdit() {
    // Limpia solo el resultado de la consulta
    _runtController?.clearVehicleData();

    // Fuerza rebuild para volver al formulario
    setState(() {});
  }

  bool get _canConsult =>
      _plateController.text.isNotEmpty &&
      _selectedDocType != null &&
      _docNumberController.text.isNotEmpty;

  /// Mapea tipo de documento UI a código RUNT
  String _mapDocTypeToRunt(String uiDocType) {
    debugPrint('[Step2][MAP] uiDocType=$uiDocType');
    switch (uiDocType) {
      case 'CC':
        return 'C';
      case 'CE':
        return 'E';
      case 'NIT':
        return 'C'; // NIT usa código C en RUNT
      default:
        return 'C';
    }
  }

  /// Consultar RUNT usando el RuntController existente
  Future<void> _handleConsultRunt() async {
    debugPrint('[RUNT][UI] Tap Consultar RUNT');
    debugPrint(
      '[RUNT][UI] _canConsult=$_canConsult plate="${_plateController.text}" docType="$_selectedDocType" doc="${_docNumberController.text}"',
    );

    if (!_formKey.currentState!.validate()) {
      debugPrint('[RUNT][UI] Form INVALID → cancelando consulta');
      return;
    }

    if (_runtController == null) {
      debugPrint('[RUNT][UI] ERROR: _runtController == null');
      Get.snackbar(
        'Error de configuración',
        'El servicio RUNT no está disponible.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    HapticFeedback.lightImpact();

    // Preparar datos
    final plate = _plateController.text.trim().toUpperCase();
    final ownerDocument = _docNumberController.text.trim();
    final ownerDocumentType = _mapDocTypeToRunt(_selectedDocType!);

    debugPrint(
      '[RUNT][UI] Params → portal=GOV plate=$plate ownerDocument=$ownerDocument ownerDocumentType=$ownerDocumentType',
    );

    // Ejecutar consulta real via RuntController
    try {
      debugPrint('[RUNT][UI] llamando _runtController.consultarVehiculo...');
      await _runtController!.consultarVehiculo(
        portalType: 'GOV', // Portal gubernamental
        plate: plate,
        ownerDocument: ownerDocument,
        ownerDocumentType: ownerDocumentType,
      );
      debugPrint('[RUNT][UI] _runtController.consultarVehiculo FINALIZÓ OK');
    } catch (e) {
      // Nota: el controller ya maneja errores, esto es solo para detectar crashes no controlados.
      debugPrint('[RUNT][UI] EXCEPTION no controlada en consultarVehiculo: $e');
    }

    // Forzar rebuild para mostrar datos
    if (mounted) {
      debugPrint('[RUNT][UI] mounted=true → setState() para refrescar UI');
      setState(() {});
    } else {
      debugPrint('[RUNT][UI] mounted=false → NO setState()');
    }
  }

  /// Confirmar y crear vehículo vinculado al portfolio
  Future<void> _handleConfirm() async {
    debugPrint('[Step2][CONFIRM] Tap Confirmar');
    final vehicleData = _runtController?.vehicleData;

    debugPrint('[Step2][CONFIRM] vehicleData is null? ${vehicleData == null}');

    if (vehicleData == null) return;

    HapticFeedback.lightImpact();

    // Validar que exista portfolioId del Paso 1
    if (_portfolioController.portfolioId == null) {
      debugPrint('[Step2][CONFIRM] ERROR: portfolioId == null');
      if (mounted) {
        Get.snackbar(
          'Error de flujo',
          'No hay portafolio creado. Vuelve al Paso 1.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    try {
      // Vincular vehículo al portfolio usando datos del RUNT
      final basicInfo = vehicleData.basicInfo;
      final generalInfo = vehicleData.generalInfo;

      debugPrint(
        '[Step2][CONFIRM] linkFirstAssetToPortfolio → plate=${basicInfo.plate} marca=${generalInfo?.marca} line=${generalInfo?.line} modelo=${generalInfo?.modelo}',
      );

      await _portfolioController.linkFirstAssetToPortfolio(
        plate: basicInfo.plate,
        marca: generalInfo?.marca ?? 'Sin marca',
        modelo: generalInfo?.line ?? basicInfo.vehicleClass,
        anio: generalInfo?.modelo ?? DateTime.now().year,
        countryId: 'CO', // Colombia (RUNT solo aplica a Colombia)
        cityId: 'BOG', // TODO: Obtener del portfolio
      );

      // Hook: Mostrar pantalla sugerida de gastos recurrentes
      if (mounted) {
        debugPrint('[Step2][CONFIRM] Navegando a RecurringExpensesSetupPage');
        Get.off(() => RecurringExpensesSetupPage(
              portfolioId: _portfolioController.portfolioId!,
            ));
      }
    } on UnimplementedError {
      debugPrint(
          '[Step2][CONFIRM] UnimplementedError: linkFirstAssetToPortfolio');
      // PENDIENTE: linkFirstAssetToPortfolio aún no implementado
      if (mounted) {
        Get.snackbar(
          'Registro pendiente',
          'El vínculo del vehículo al portafolio está en construcción.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('[Step2][CONFIRM] ERROR creando vehículo: $e');
      if (mounted) {
        Get.snackbar(
          'Error',
          'No se pudo crear el vehículo: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // ==================== UI HELPERS – SECCIONES RUNT (PRIVATE) ====================

  Widget _buildSectionCard({
    required ThemeData theme,
    required ColorScheme cs,
    required String title,
    required Widget child,
    IconData icon = Icons.list_alt_outlined,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          // ✅ Compatibilidad: usa withOpacity en lugar de withValues
          color: cs.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String text, ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: cs.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _dividerSoft(ColorScheme cs) => Divider(
        height: 24,
        thickness: 1,
        color: cs.outlineVariant.withOpacity(0.5),
      );

  /// Construye TODA la UI de secciones en el orden visual requerido.
  /// Se llama desde el Obx cuando vehicleData != null.
  Widget _buildRuntVehicleSections({
    required ThemeData theme,
    required ColorScheme cs,
    required RuntVehicleData vehicleData,
  }) {
    final basicInfo = vehicleData.basicInfo;
    final generalInfo = vehicleData.generalInfo;

    // Crear snapshot UNA sola vez para secciones documentales
    final snapshot = VehicleDocumentsSnapshot.fromRuntData(runtData: vehicleData);

    return Column(
      children: [
        const SizedBox(height: 28),
        _dividerSoft(cs),
        const SizedBox(height: 12),
        Text(
          'Ficha RUNT del vehículo',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // 1) Información Básica
        _buildSectionCard(
          theme: theme,
          cs: cs,
          title: 'Información Básica',
          icon: Icons.verified_outlined,
          child: Column(
            children: [
              _InfoTile(label: 'Placa', value: basicInfo.plate),
              _InfoTile(label: 'Estado', value: basicInfo.vehicleStatus),
              _InfoTile(label: 'Servicio', value: basicInfo.serviceType),
              _InfoTile(label: 'Clase', value: basicInfo.vehicleClass),
              _InfoTile(
                label: 'Licencia tránsito',
                value: basicInfo.transitLicenseNumber?.toString() ?? 'N/A',
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 2) Información General
        _buildSectionCard(
          theme: theme,
          cs: cs,
          title: 'Información General',
          icon: Icons.directions_car_filled_outlined,
          child: (generalInfo == null)
              ? _emptyState('No hay información general disponible.', theme, cs)
              : Column(
                  children: [
                    _InfoTile(
                        label: 'Marca', value: generalInfo.marca ?? 'N/A'),
                    _InfoTile(label: 'Línea', value: generalInfo.line ?? 'N/A'),
                    _InfoTile(
                      label: 'Modelo (año)',
                      value: generalInfo.modelo?.toString() ?? 'N/A',
                    ),
                    _InfoTile(
                        label: 'Color', value: generalInfo.color ?? 'N/A'),
                    _InfoTile(
                        label: 'Motor',
                        value: generalInfo.engineNumber ?? 'N/A'),
                    _InfoTile(
                        label: 'Chasis',
                        value: generalInfo.chassisNumber ?? 'N/A'),
                    _InfoTile(label: 'VIN', value: generalInfo.vin ?? 'N/A'),
                    _InfoTile(
                      label: 'Cilindraje',
                      value: generalInfo.cilindraje?.toString() ?? 'N/A',
                    ),
                    _InfoTile(
                        label: 'Carrocería',
                        value: generalInfo.bodyType ?? 'N/A'),
                    _InfoTile(
                        label: 'Combustible',
                        value: generalInfo.fuelType ?? 'N/A'),
                    _InfoTile(
                      label: 'Matrícula inicial',
                      value: generalInfo.initialRegistrationDate ?? 'N/A',
                    ),
                    _InfoTile(
                      label: 'Autoridad tránsito',
                      value: generalInfo.transitAuthority ?? 'N/A',
                    ),
                    _InfoTile(
                      label: 'Gravámenes',
                      value: generalInfo.propertyLiens ?? 'N/A',
                    ),
                    _InfoTile(
                      label: 'Clásico/Antiguo',
                      value: generalInfo.isClassicOrAntique ?? 'N/A',
                    ),
                    _InfoTile(
                        label: 'Repotenciado',
                        value: generalInfo.repotenciado ?? 'N/A'),
                    _InfoTile(
                        label: 'Puertas',
                        value: generalInfo.puertas?.toString() ?? 'N/A'),
                  ],
                ),
        ),

        const SizedBox(height: 12),

        // 3) Datos técnicos
        _buildSectionCard(
          theme: theme,
          cs: cs,
          title: 'Datos técnicos',
          icon: Icons.settings_outlined,
          child: (vehicleData.technicalData == null)
              ? _emptyState('No hay datos técnicos disponibles.', theme, cs)
              : Column(
                  children: [
                    _InfoTile(
                      label: 'Carga (kg)',
                      value: vehicleData.technicalData?.loadCapacityKg
                              ?.toString() ??
                          'N/A',
                    ),
                    _InfoTile(
                      label: 'Peso bruto (kg)',
                      value: vehicleData.technicalData?.grossWeightKg
                              ?.toString() ??
                          'N/A',
                    ),
                    _InfoTile(
                      label: 'Pasajeros',
                      value: vehicleData.technicalData?.passengersCapacityRaw ??
                          'N/A',
                    ),
                    _InfoTile(
                      label: 'Sentados',
                      value: vehicleData.technicalData?.seatedPassengers
                              ?.toString() ??
                          'N/A',
                    ),
                    _InfoTile(
                      label: 'Ejes',
                      value:
                          vehicleData.technicalData?.axles?.toString() ?? 'N/A',
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 12),

        // ============================================================
        // SECCIONES DOCUMENTALES (usando VehicleDocumentsSnapshot)
        // ============================================================

        // 4) SOAT
        _DocumentStatusCard(
          title: 'SOAT',
          status: snapshot.soat,
          icon: Icons.shield_outlined,
        ),

        const SizedBox(height: 12),

        // 5) RTM
        _DocumentStatusCard(
          title: 'Revisión Técnico Mecánica',
          status: snapshot.rtm,
          icon: Icons.fact_check_outlined,
        ),

        const SizedBox(height: 12),

        // 6) RC - Responsabilidad Civil
        _buildSectionCard(
          theme: theme,
          cs: cs,
          title: 'Responsabilidad Civil',
          icon: Icons.policy_outlined,
          child: (snapshot.rcContractual == null &&
                  snapshot.rcExtraContractual == null)
              ? _emptyState(
                  'Sin pólizas de Responsabilidad Civil registradas.',
                  theme,
                  cs,
                )
              : Column(
                  children: [
                    if (snapshot.rcContractual != null)
                      _DocumentStatusCard(
                        title: 'RC Contractual',
                        status: snapshot.rcContractual,
                        compact: true,
                      ),
                    if (snapshot.rcContractual != null &&
                        snapshot.rcExtraContractual != null)
                      const SizedBox(height: 8),
                    if (snapshot.rcExtraContractual != null)
                      _DocumentStatusCard(
                        title: 'RC Extracontractual',
                        status: snapshot.rcExtraContractual,
                        compact: true,
                      ),
                  ],
                ),
        ),

        const SizedBox(height: 12),

        // 7) Limitaciones
        _buildSectionCard(
          theme: theme,
          cs: cs,
          title: 'Limitaciones',
          icon: Icons.gavel_outlined,
          child: (vehicleData.ownershipLimitations.isEmpty)
              ? _emptyState('No hay limitaciones registradas.', theme, cs)
              : Column(
                  children: vehicleData.ownershipLimitations.map((r) {
                    final title = r.limitationType ?? 'Limitación';
                    final subtitle =
                        'Oficio: ${r.officeNumber?.toString() ?? 'N/A'} | ${r.municipality ?? 'N/A'}, ${r.department ?? 'N/A'}';
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '$subtitle\nEntidad: ${r.legalEntity ?? 'N/A'}\nExpedición: ${r.officeIssueDate ?? 'N/A'} | Registro: ${r.systemRegistrationDate ?? 'N/A'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),

        const SizedBox(height: 12),

        // 8) Garantías
        _buildSectionCard(
          theme: theme,
          cs: cs,
          title: 'Garantías',
          icon: Icons.account_balance_outlined,
          child: (vehicleData.warranties.isEmpty)
              ? _emptyState('No hay garantías registradas.', theme, cs)
              : Column(
                  children: vehicleData.warranties.map((r) {
                    final title = r.creditorName ?? 'Acreedor';
                    final subtitle =
                        'ID: ${r.creditorId ?? 'N/A'} | Inscripción: ${r.registrationDate ?? 'N/A'}';
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '$subtitle\nPatrimonio autónomo: ${r.autonomousPatrimony ?? 'N/A'} | Confecámaras: ${r.confecamaras ?? 'N/A'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),

        const SizedBox(height: 24),

        // Botón Confirmar (único)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: _handleEdit,
              child: const Text('Volver'),
            ),
            FilledButton(
              onPressed: _handleConfirm,
              child: const Text('Registrar vehículo'),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Fallback si assetType no está disponible
    if (_assetType == null) {
      debugPrint('[Step2][BUILD] assetType == null → fallback');
      return _buildErrorFallback(theme, cs);
    }

    // Decidir qué UI mostrar según el tipo de activo
    if (_assetType == AssetType.vehiculo) {
      debugPrint('[Step2][BUILD] assetType=vehiculo → form RUNT');
      return _buildVehicleRuntForm(theme, cs);
    } else {
      debugPrint('[Step2][BUILD] assetType=$_assetType → placeholder');
      return _buildOtherAssetPlaceholder(theme, cs);
    }
  }

  /// UI de error cuando assetType es null
  Widget _buildErrorFallback(ThemeData theme, ColorScheme cs) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: cs.error),
              const SizedBox(height: 16),
              Text(
                'Error de flujo',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No se pudo determinar el tipo de activo.\nVuelve al paso anterior.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Get.back(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// UI para vehículos: Formulario RUNT completo
  Widget _buildVehicleRuntForm(ThemeData theme, ColorScheme cs) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agregar Vehículo'),
            Text(
              'Paso 2 de 2',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Título
            Text(
              'Consulta RUNT',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingresa la placa y los datos del propietario para consultar el vehículo en RUNT.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Placa
            TextFormField(
              controller: _plateController,
              decoration: const InputDecoration(
                labelText: 'Placa *',
                hintText: 'ABC123',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La placa es obligatoria';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Tipo de Documento
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipo de documento del propietario *',
                border: OutlineInputBorder(),
              ),
              value: _selectedDocType,
              items: const [
                DropdownMenuItem(
                    value: 'CC', child: Text('Cédula de Ciudadanía')),
                DropdownMenuItem(
                    value: 'CE', child: Text('Cédula de Extranjería')),
                DropdownMenuItem(value: 'NIT', child: Text('NIT')),
              ],
              onChanged: (value) => setState(() => _selectedDocType = value),
              validator: (value) {
                if (value == null) return 'Selecciona un tipo de documento';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Número de Documento
            TextFormField(
              controller: _docNumberController,
              decoration: const InputDecoration(
                labelText: 'Número de documento *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El número de documento es obligatorio';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Botón Consultar RUNT
            Obx(() {
              final isLoading = _runtController?.isLoadingVehicle ?? false;
              debugPrint('[RUNT][UI][OBX] isLoadingVehicle=$isLoading');
              return FilledButton(
                onPressed:
                    _canConsult && !isLoading ? _handleConsultRunt : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Consultar RUNT'),
              );
            }),
            const SizedBox(height: 8),

            // Mensaje de error (solo error, NO sections)
            Obx(() {
              final msg = _runtController?.errorMessageRx.value; // ✅ Rx público
              debugPrint('[RUNT][UI][OBX] errorMessageRx="${msg ?? ""}"');
              if (msg == null || msg.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  msg,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            }),

            // Secciones completas (solo si hay vehicleData)
            Obx(() {
              final vehicleData = _runtController?.vehicleData;
              debugPrint(
                  '[RUNT][UI][OBX] vehicleData is null? ${vehicleData == null}');
              if (vehicleData == null) return const SizedBox.shrink();

              return _buildRuntVehicleSections(
                theme: theme,
                cs: cs,
                vehicleData: vehicleData,
              );
            }),
          ],
        ),
      ),
    );
  }

  /// UI placeholder para otros tipos de activo (no vehículo)
  Widget _buildOtherAssetPlaceholder(ThemeData theme, ColorScheme cs) {
    final assetTypeName = _assetType?.displayName ?? 'activo';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agregar $assetTypeName'),
            Text(
              'Paso 2 de 2',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _assetType?.icon ?? Icons.widgets_outlined,
                size: 80,
                // ✅ Compatibilidad: withOpacity
                color: cs.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Próximamente',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'El registro de $assetTypeName estará disponible en una próxima actualización.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget auxiliar para mostrar info del vehículo
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WIDGET: _DocumentStatusCard
// Renderiza UNA tarjeta de documento basada en VehicleDocumentStatus.
// ============================================================================

class _DocumentStatusCard extends StatelessWidget {
  final String title;
  final VehicleDocumentStatus? status;
  final IconData? icon;
  final bool compact;

  const _DocumentStatusCard({
    required this.title,
    required this.status,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Si status es null → estado vacío
    if (status == null) {
      return _buildEmptyCard(theme, cs);
    }

    // Determinar visuales según status
    final statusConfig = _getStatusConfig(status!.status, cs);

    if (compact) {
      return _buildCompactCard(theme, cs, statusConfig);
    }

    return _buildFullCard(theme, cs, statusConfig);
  }

  Widget _buildEmptyCard(ThemeData theme, ColorScheme cs) {
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon ?? Icons.help_outline,
              size: 24,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No registrado',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullCard(
    ThemeData theme,
    ColorScheme cs,
    _StatusConfig config,
  ) {
    return Card(
      elevation: 0,
      color: config.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: config.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon ?? config.icon,
              size: 28,
              color: config.iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _buildStatusChip(theme, config),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDateInfo(theme, cs),
                  if (status!.provider != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      status!.provider!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(
    ThemeData theme,
    ColorScheme cs,
    _StatusConfig config,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.borderColor),
      ),
      child: Row(
        children: [
          Icon(config.icon, size: 20, color: config.iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                _buildDateInfo(theme, cs, small: true),
              ],
            ),
          ),
          _buildStatusChip(theme, config, small: true),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, _StatusConfig config,
      {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: config.chipColor,
        borderRadius: BorderRadius.circular(small ? 4 : 6),
      ),
      child: Text(
        config.chipText,
        style: (small ? theme.textTheme.labelSmall : theme.textTheme.labelSmall)
            ?.copyWith(
          color: config.chipTextColor,
          fontWeight: FontWeight.w600,
          fontSize: small ? 10 : 11,
        ),
      ),
    );
  }

  Widget _buildDateInfo(ThemeData theme, ColorScheme cs, {bool small = false}) {
    final dateStr = _formatDate(status!.endDate);
    final isExpired = status!.isExpired;

    final prefix = isExpired ? 'Venció:' : 'Vence:';
    final textStyle = small
        ? theme.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant)
        : theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant);

    return Text('$prefix $dateStr', style: textStyle);
  }

  _StatusConfig _getStatusConfig(DocumentValidityStatus docStatus, ColorScheme cs) {
    switch (docStatus) {
      case DocumentValidityStatus.vigente:
        final daysText = status!.daysToExpire != null
            ? ' (${status!.daysToExpire} días)'
            : '';
        return _StatusConfig(
          backgroundColor: Colors.green.shade50,
          borderColor: Colors.green.shade200,
          iconColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
          chipColor: Colors.green.shade100,
          chipTextColor: Colors.green.shade800,
          chipText: 'VIGENTE$daysText',
        );

      case DocumentValidityStatus.porVencer:
        final daysText = status!.daysToExpire != null
            ? ' (${status!.daysToExpire} días)'
            : '';
        return _StatusConfig(
          backgroundColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade200,
          iconColor: Colors.orange.shade700,
          icon: Icons.warning_amber_outlined,
          chipColor: Colors.orange.shade100,
          chipTextColor: Colors.orange.shade800,
          chipText: 'POR VENCER$daysText',
        );

      case DocumentValidityStatus.vencido:
        final daysText = status!.daysToExpire != null
            ? ' (${status!.daysToExpire!.abs()} días)'
            : '';
        return _StatusConfig(
          backgroundColor: Colors.red.shade50,
          borderColor: Colors.red.shade200,
          iconColor: Colors.red.shade700,
          icon: Icons.error_outline,
          chipColor: Colors.red.shade100,
          chipTextColor: Colors.red.shade800,
          chipText: 'VENCIDO$daysText',
        );

      case DocumentValidityStatus.desconocido:
        return _StatusConfig(
          backgroundColor: cs.surfaceContainerHighest.withOpacity(0.5),
          borderColor: cs.outlineVariant,
          iconColor: cs.onSurfaceVariant,
          icon: Icons.help_outline,
          chipColor: cs.surfaceContainerHighest,
          chipTextColor: cs.onSurfaceVariant,
          chipText: 'SIN DATOS',
        );
    }
  }
}

/// Configuración visual para cada estado de documento.
class _StatusConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;
  final Color chipColor;
  final Color chipTextColor;
  final String chipText;

  const _StatusConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.icon,
    required this.chipColor,
    required this.chipTextColor,
    required this.chipText,
  });
}

/// Helper para formatear fechas. Formato: dd/MM/yyyy
/// Retorna "N/A" si la fecha es null.
String _formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}
