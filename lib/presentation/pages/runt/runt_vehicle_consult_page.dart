import 'package:avanzza/core/utils/input_formatters/upper_case_formatter.dart';
import 'package:avanzza/data/runt/models/runt_vehicle_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/runt/runt_controller.dart';

/// Pantalla de consulta RUNT para vehículos.
///
/// Permite consultar información de un vehículo por placa:
/// - Información básica y general
/// - Historial SOAT
/// - Seguros RC (Responsabilidad Civil)
/// - Historial RTM (Revisión Técnico-Mecánica)
/// - Limitaciones de propiedad
/// - Garantías
class RuntVehicleConsultPage extends StatelessWidget {
  RuntVehicleConsultPage({super.key});

  final _controller = Get.find<RuntController>();
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _ownerDocumentController = TextEditingController();
  final _portalType = 'GOV'.obs; // GOV por defecto
  final _ownerDocumentType = 'C'.obs; // C.C. por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta RUNT Vehículo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.resetVehicleData(),
            tooltip: 'Limpiar consulta',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formulario de consulta
            _buildFormSection(),
            const SizedBox(height: 24),

            // Resultados
            Obx(() {
              if (_controller.isLoadingVehicle) {
                return _buildLoadingState();
              }

              if (_controller.errorMessage != null) {
                return _buildErrorState();
              }

              if (_controller.vehicleData != null) {
                return _buildResultsSection();
              }

              return _buildEmptyState();
            }),
          ],
        ),
      ),
    );
  }

  // ==================== FORMULARIO ====================

  Widget _buildFormSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Datos de consulta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Tipo de portal
              // Obx(() => DropdownButtonFormField<String>(
              //       value: _portalType.value,
              //       decoration: const InputDecoration(
              //         labelText: 'Tipo de portal',
              //         border: OutlineInputBorder(),
              //       ),
              //       items: const [
              //         DropdownMenuItem(
              //             value: 'GOV', child: Text('Portal Gubernamental')),
              //         DropdownMenuItem(
              //             value: 'COM', child: Text('Portal Ciudadano')),
              //       ],
              //       onChanged: (value) {
              //         if (value != null) _portalType.value = value;
              //       },
              //     )),
              const SizedBox(height: 16),

              // Placa
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(
                  labelText: 'Placa del vehículo',
                  hintText: 'Ej: ABC123',
                  border: OutlineInputBorder(),
                ),
                maxLength: 6,
                inputFormatters: [UpperCaseTextFormatter()],
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La placa es requerida';
                  }
                  // if (!RegExp(r'^[A-Z]{3}\d{3}$')
                  //     .hasMatch(value.toUpperCase())) {
                  //   return 'Formato inválido. Ej: ABC123';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tipo de documento propietario
              Obx(() => DropdownButtonFormField<String>(
                    value: _ownerDocumentType.value,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de documento propietario',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'C', child: Text('Cédula de Ciudadanía')),
                      DropdownMenuItem(
                          value: 'E', child: Text('Cédula de Extranjería')),
                      DropdownMenuItem(value: 'P', child: Text('Pasaporte')),
                    ],
                    onChanged: (value) {
                      if (value != null) _ownerDocumentType.value = value;
                    },
                  )),
              const SizedBox(height: 16),

              // Documento propietario
              TextFormField(
                controller: _ownerDocumentController,
                decoration: const InputDecoration(
                  labelText: 'Documento del propietario',
                  hintText: 'Ej: 1234567890',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El documento es requerido';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Solo se permiten números';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botón consultar
              ElevatedButton.icon(
                onPressed: _onConsultarPressed,
                icon: const Icon(Icons.search),
                label: const Text('Consultar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConsultarPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _controller.consultarVehiculo(
        portalType: _portalType.value,
        plate: _plateController.text.trim().toUpperCase(),
        ownerDocument: _ownerDocumentController.text.trim(),
        ownerDocumentType: _ownerDocumentType.value,
      );
    }
  }

  // ==================== ESTADOS ====================

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Consultando RUNT...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
            const SizedBox(height: 8),
            Text(
              _controller.errorMessage ?? 'Error desconocido',
              style: TextStyle(color: Colors.red.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _controller.resetError(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.directions_car, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Ingresa una placa para consultar',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== RESULTADOS ====================
  Future<void> _onNext() async {}

  Widget _buildResultsSection() {
    final vehicle = _controller.vehicleData!;

    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.info), text: 'Info Básica'),
              Tab(icon: Icon(Icons.shield), text: 'SOAT'),
              Tab(icon: Icon(Icons.security), text: 'Seguros RC'),
              Tab(icon: Icon(Icons.build), text: 'RTM'),
              Tab(icon: Icon(Icons.warning), text: 'Limitaciones'),
              Tab(icon: Icon(Icons.account_balance), text: 'Garantías'),
            ],
          ),
          SizedBox(
            height: 600,
            child: TabBarView(
              children: [
                _buildInfoTab(vehicle),
                _buildSoatTab(vehicle),
                _buildRcInsuranceTab(vehicle),
                _buildRtmTab(vehicle),
                _buildLimitationsTab(vehicle),
                _buildWarrantiesTab(vehicle),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _onNext,
            // icon: const Icon(Icons.search),
            label: const Text('Continuar'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TAB: INFORMACIÓN BÁSICA ====================

  Widget _buildInfoTab(RuntVehicleData vehicle) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard('Información Básica', [
            _buildInfoRow('Placa', vehicle.basicInfo.plate),
            // CORRECCIÓN: 'status' -> 'vehicleStatus'
            if (vehicle.basicInfo.vehicleStatus.isNotEmpty)
              _buildInfoRow('Estado', vehicle.basicInfo.vehicleStatus),
            // CORRECCIÓN: 'service' -> 'serviceType'
            if (vehicle.basicInfo.serviceType.isNotEmpty)
              _buildInfoRow('Servicio', vehicle.basicInfo.serviceType),
            if (vehicle.basicInfo.vehicleClass.isNotEmpty)
              _buildInfoRow('Clase', vehicle.basicInfo.vehicleClass),
          ]),
          const SizedBox(height: 16),
          if (vehicle.generalInfo != null)
            _buildInfoCard('Información General', [
              // CORRECCIÓN: 'brand' -> 'marca'
              if (vehicle.generalInfo!.marca != null)
                _buildInfoRow('Marca', vehicle.generalInfo!.marca!),
              if (vehicle.generalInfo!.line != null)
                _buildInfoRow('Línea', vehicle.generalInfo!.line!),
              if (vehicle.generalInfo!.modelo != null)
                _buildInfoRow(
                    'Modelo', vehicle.generalInfo!.modelo!.toString()),
              if (vehicle.generalInfo!.color != null)
                _buildInfoRow('Color', vehicle.generalInfo!.color!),
              if (vehicle.generalInfo!.vin != null)
                _buildInfoRow('VIN/Chasis', vehicle.generalInfo!.vin!),
              if (vehicle.generalInfo!.engineNumber != null)
                _buildInfoRow('N° Motor', vehicle.generalInfo!.engineNumber!),
              // CORRECCIÓN: 'displacement' -> 'cilindraje' (y toString porque es int)
              if (vehicle.generalInfo!.cilindraje != null)
                _buildInfoRow(
                    'Cilindraje', vehicle.generalInfo!.cilindraje!.toString()),
              if (vehicle.generalInfo!.fuelType != null)
                _buildInfoRow('Combustible', vehicle.generalInfo!.fuelType!),
              // CORRECCIÓN: 'bodywork' -> 'bodyType'
              if (vehicle.generalInfo!.bodyType != null)
                _buildInfoRow('Carrocería', vehicle.generalInfo!.bodyType!),
            ]),
        ],
      ),
    );
  }

  // ==================== TAB: SOAT ====================

  Widget _buildSoatTab(RuntVehicleData vehicle) {
    if (vehicle.soat.isEmpty) {
      return _buildEmptyTabState('SOAT: Sin registros disponibles');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicle.soat.length,
      itemBuilder: (context, index) {
        final soat = vehicle.soat[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        soat.policyNumber ?? 'Sin número',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // CORRECCIÓN: 'status' -> 'estado'
                    if (soat.estado != null) _buildStatusChip(soat.estado!),
                  ],
                ),
                const Divider(height: 16),
                if (soat.insurer != null)
                  _buildInfoRow('Aseguradora', soat.insurer!),
                // CORRECCIÓN: 'startDate' -> 'validityStart'
                if (soat.validityStart != null)
                  _buildInfoRow('Inicio', soat.validityStart!),
                // CORRECCIÓN: 'endDate' -> 'validityEnd'
                if (soat.validityEnd != null)
                  _buildInfoRow('Vencimiento', soat.validityEnd!),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== TAB: SEGUROS RC ====================

  Widget _buildRcInsuranceTab(RuntVehicleData vehicle) {
    if (vehicle.rcInsurances.isEmpty) {
      return _buildEmptyTabState('Seguros RC: Sin registros disponibles');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicle.rcInsurances.length,
      itemBuilder: (context, index) {
        final rc = vehicle.rcInsurances[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rc.policyNumber ?? 'Sin número',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (rc.estado != null) _buildStatusChip(rc.estado!),
                  ],
                ),
                const Divider(height: 16),
                if (rc.insurer != null)
                  _buildInfoRow('Aseguradora', rc.insurer!),
                if (rc.policyType != null)
                  _buildInfoRow('Tipo de Póliza', rc.policyType!),
                if (rc.issueDate != null)
                  _buildInfoRow('Fecha Expedición', rc.issueDate!),
                if (rc.validityStart != null)
                  _buildInfoRow('Inicio Vigencia', rc.validityStart!),
                if (rc.validityEnd != null)
                  _buildInfoRow('Fin Vigencia', rc.validityEnd!),
                if (rc.detail != null) _buildInfoRow('Detalle', rc.detail!),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== TAB: RTM ====================

  Widget _buildRtmTab(RuntVehicleData vehicle) {
    if (vehicle.rtmHistory.isEmpty) {
      return _buildEmptyTabState('RTM: Sin registros disponibles');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicle.rtmHistory.length,
      itemBuilder: (context, index) {
        final rtm = vehicle.rtmHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.build, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rtm.certificateNumber?.toString() ?? 'Sin certificado',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // CORRECCIÓN: 'status' -> 'vigente'
                    if (rtm.vigente != null) _buildStatusChip(rtm.vigente!),
                  ],
                ),
                const Divider(height: 16),
                if (rtm.cda != null) _buildInfoRow('CDA', rtm.cda!),
                // CORRECCIÓN: 'inspectionDate' -> 'issueDate'
                if (rtm.issueDate != null)
                  _buildInfoRow('Fecha revisión', rtm.issueDate!),
                // CORRECCIÓN: 'expirationDate' -> 'validityDate'
                if (rtm.validityDate != null)
                  _buildInfoRow('Vencimiento', rtm.validityDate!),
                // CORRECCIÓN: 'result' no existe. Usamos 'informationConsistent' o 'vigente' como resultado
                if (rtm.informationConsistent != null)
                  _buildInfoRow('Resultado', rtm.informationConsistent!),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== TAB: LIMITACIONES ====================

  Widget _buildLimitationsTab(RuntVehicleData vehicle) {
    if (vehicle.ownershipLimitations.isEmpty) {
      return _buildEmptyTabState('Limitaciones: Sin registros disponibles',
          isPositive: true);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicle.ownershipLimitations.length,
      itemBuilder: (context, index) {
        final l = vehicle.ownershipLimitations[index];

        // Normalización mínima (evita null/strings vacíos)
        final tipo = (l.limitationType ?? '').trim();
        final entidad = (l.legalEntity ?? '').trim();
        final depto = (l.department ?? '').trim();
        final muni = (l.municipality ?? '').trim();
        final fechaOficio = (l.officeIssueDate ?? '').trim();
        final fechaRegistro = (l.systemRegistrationDate ?? '').trim();
        final oficio = l.officeNumber;

        return Card(
          color: Colors.orange.shade50,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tipo.isNotEmpty ? tipo : 'Limitación a la propiedad',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.orange.shade900,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Campos requeridos (según data RUNT)

                if (entidad.isNotEmpty)
                  _buildInfoRow('Entidad jurídica', entidad),
                if (depto.isNotEmpty) _buildInfoRow('Departamento', depto),
                if (muni.isNotEmpty) _buildInfoRow('Municipio', muni),
                if (oficio != null)
                  _buildInfoRow('Número de oficio', '$oficio'),
                if (fechaOficio.isNotEmpty)
                  _buildInfoRow('Fecha expedición oficio', fechaOficio),
                if (fechaRegistro.isNotEmpty)
                  _buildInfoRow('Fecha registro en el sistema', fechaRegistro),

                // Fallback ultra simple si por alguna razón TODO viene vacío
                if (oficio == null &&
                    entidad.isEmpty &&
                    depto.isEmpty &&
                    muni.isEmpty &&
                    fechaOficio.isEmpty &&
                    fechaRegistro.isEmpty)
                  _buildInfoRow(
                      'Detalle', 'Sin información adicional disponible'),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== TAB: GARANTÍAS ====================

  Widget _buildWarrantiesTab(RuntVehicleData vehicle) {
    if (vehicle.warranties.isEmpty) {
      return _buildEmptyTabState('Garantías: Sin registros disponibles');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicle.warranties.length,
      itemBuilder: (context, index) {
        final warranty = vehicle.warranties[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        // CORRECCIÓN: 'creditor' -> 'creditorName'
                        warranty.creditorName ?? 'Acreedor',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                // NOTA: 'warrantyType' no existe en el modelo, omitido.

                // CORRECCIÓN: 'constitutionDate' -> 'registrationDate' (es lo más cercano)
                if (warranty.registrationDate != null)
                  _buildInfoRow(
                      'Fecha inscripción', warranty.registrationDate!),

                // CORRECCIÓN: 'status' -> 'confecamaras' (lo más cercano a estado en este modelo)
                if (warranty.confecamaras != null)
                  _buildInfoRow('Confecámaras', warranty.confecamaras!),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== WIDGETS DE UTILIDAD ====================

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          SelectableText(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isActive = status.toLowerCase().contains('vigente') ||
        status.toLowerCase().contains('activ') ||
        status.toLowerCase() == 'si'; // Agregado por si viene SI/NO

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyTabState(String message, {bool isPositive = false}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPositive ? Icons.check_circle : Icons.info_outline,
              size: 64,
              color: isPositive ? Colors.green.shade400 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color:
                    isPositive ? Colors.green.shade700 : Colors.grey.shade600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
