import 'package:avanzza/data/simit/models/simit_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Asegúrate de importar la ruta correcta de tus modelos y controlador
import '../../controllers/simit/simit_controller.dart';

/// Pantalla de consulta SIMIT para multas de tránsito.
///
/// Permite consultar multas por documento:
/// - Resumen ejecutivo (total, comparendos, multas)
/// - Lista detallada de multas
/// - Detalle expandible de cada multa (si está disponible)
class SimitConsultPage extends StatelessWidget {
  SimitConsultPage({super.key});

  final _controller = Get.find<SimitController>();
  final _formKey = GlobalKey<FormState>();
  final _documentController = TextEditingController();
  final _numberFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta SIMIT Multas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.resetData(),
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
              if (_controller.isLoading) {
                return _buildLoadingState();
              }

              if (_controller.errorMessage != null) {
                return _buildErrorState();
              }

              // Asumimos que el controlador expone: SimitData? multasData
              if (_controller.multasData != null) {
                return _buildResultsSection(_controller.multasData!);
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

              // Número de documento
              TextFormField(
                controller: _documentController,
                decoration: const InputDecoration(
                  labelText: 'Número de documento (cédula)',
                  hintText: 'Ej: 1234567890',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
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
                label: const Text('Consultar Multas'),
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
      _controller.consultarMultas(_documentController.text.trim());
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
            Text('Consultando SIMIT...'),
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
            Icon(Icons.traffic, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Ingresa un documento para consultar multas',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== RESULTADOS ====================

  Widget _buildResultsSection(SimitData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Banner de datos parciales (si aplica)
        Obx(() {
          if (_controller.isPartialData) {
            return _buildPartialDataBanner();
          }
          return const SizedBox.shrink();
        }),

        // Resumen
        _buildSummaryCard(data),
        const SizedBox(height: 16),

        // Lista de multas
        if (data.fines.isNotEmpty) _buildFinesSection(data),
      ],
    );
  }

  Widget _buildPartialDataBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Algunos detalles de multas no están disponibles',
              style: TextStyle(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(SimitData data) {
    final hasFines = data.hasFines;
    final total = data.total;

    return Card(
      color: hasFines ? Colors.red.shade50 : Colors.green.shade50,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              hasFines ? Icons.warning_amber : Icons.check_circle,
              size: 64,
              color: hasFines ? Colors.red.shade700 : Colors.green.shade700,
            ),
            const SizedBox(height: 12),
            Text(
              hasFines ? '¡Tiene multas pendientes!' : '✅ Sin multas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: hasFines ? Colors.red.shade900 : Colors.green.shade900,
              ),
            ),
            const SizedBox(height: 16),

            // Total
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total a pagar',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _numberFormat.format(total),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: hasFines ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contadores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCounterItem(
                  'Comparendos',
                  data.summary.comparendos.toString(),
                  Icons.description,
                ),
                _buildCounterItem(
                  'Multas',
                  data.summary.multas.toString(),
                  Icons.monetization_on,
                ),
                _buildCounterItem(
                  'Acuerdos',
                  data.summary.paymentAgreementsCount.toString(),
                  Icons.handshake,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFinesSection(SimitData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Detalle de Multas (${data.fines.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...data.fines.map((fine) => _buildFineCard(fine)),
      ],
    );
  }

  Widget _buildFineCard(SimitFine fine) {
    final hasDetail = fine.detalle != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          Icons.receipt_long,
          color: _getFineStateColor(fine.estado),
        ),
        title: Text(
          'ID: ${fine.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fine.fecha != null) Text('Fecha: ${fine.fecha}'),
            Text(
              'A pagar: ${_numberFormat.format(fine.amountToPay)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: _buildStatusChip(fine.estado),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información básica
                _buildInfoRow('Estado', fine.estado),
                if (fine.ciudad != null)
                  _buildInfoRow('Ciudad', fine.ciudad!),
                _buildInfoRow('Placa', fine.placa),
                if (fine.valor != null)
                  _buildInfoRow('Valor original', _numberFormat.format(fine.valor)),
                _buildInfoRow('Valor a pagar', _numberFormat.format(fine.amountToPay)),
                if (fine.infractionCodeShort != null)
                  _buildInfoRow('Código infracción', fine.infractionCodeShort!),

                // Detalle (si existe)
                if (hasDetail) ...[
                  const Divider(height: 24),
                  _buildFineDetail(fine.detalle!),
                ] else ...[
                  const Divider(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Detalle adicional no disponible',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFineDetail(SimitFineDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalle Completo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Información del comparendo
        if (detail.ticketInfo != null) ...[
          _buildDetailSection('Comparendo', [
            if (detail.ticketInfo!.ticketNumber != null)
              _buildInfoRow('Número', detail.ticketInfo!.ticketNumber!),
            if (detail.ticketInfo!.date != null)
              _buildInfoRow('Fecha', detail.ticketInfo!.date!),
            if (detail.ticketInfo!.time != null)
              _buildInfoRow('Hora', detail.ticketInfo!.time!),
            if (detail.ticketInfo!.address != null)
              _buildInfoRow('Dirección', detail.ticketInfo!.address!),
            if (detail.ticketInfo!.secretary != null)
              _buildInfoRow('Secretaría', detail.ticketInfo!.secretary!),
          ]),
        ],

        // Infracción
        if (detail.infraction != null) ...[
          _buildDetailSection('Infracción', [
            if (detail.infraction!.code != null)
              _buildInfoRow('Código', detail.infraction!.code!),
            if (detail.infraction!.description != null)
              _buildInfoRow('Descripción', detail.infraction!.description!),
          ]),
        ],

        // Conductor
        if (detail.driver != null) ...[
          _buildDetailSection('Conductor', [
            if (detail.driver!.documentType != null)
              _buildInfoRow('Tipo doc', detail.driver!.documentType!),
            if (detail.driver!.documentNumber != null)
              _buildInfoRow('Documento', detail.driver!.documentNumber!),
            // NOTA: El modelo no tiene 'name', tiene 'firstNames' y 'lastNames'
            if (detail.driver!.firstNames != null || detail.driver!.lastNames != null)
               _buildInfoRow(
                  'Nombre', 
                  '${detail.driver!.firstNames ?? ''} ${detail.driver!.lastNames ?? ''}'.trim()
               ),
          ]),
        ],

        // Vehículo
        if (detail.vehicle != null) ...[
          _buildDetailSection('Vehículo', [
            if (detail.vehicle!.plate != null)
              _buildInfoRow('Placa', detail.vehicle!.plate!),
            // NOTA: El modelo SimitVehicleInfo NO tiene brand ni color. 
            // Se reemplaza por Type y Service que sí existen en el modelo.
            if (detail.vehicle!.type != null)
              _buildInfoRow('Tipo', detail.vehicle!.type!),
            if (detail.vehicle!.service != null)
              _buildInfoRow('Servicio', detail.vehicle!.service!),
            if (detail.vehicle!.vehicleLicenseNumber != null)
               _buildInfoRow('Licencia V.', detail.vehicle!.vehicleLicenseNumber!),
          ]),
        ],
      ],
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }

  // ==================== WIDGETS DE UTILIDAD ====================

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String estado) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getFineStateColor(estado),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getFineStateColor(String estado) {
    final estadoLower = estado.toLowerCase();

    if (estadoLower.contains('pagad') || estadoLower.contains('cancelad')) {
      return Colors.green;
    }
    if (estadoLower.contains('pendiente')) {
      return Colors.orange;
    }
    if (estadoLower.contains('coactivo') || estadoLower.contains('mora')) {
      return Colors.red;
    }
    return Colors.grey;
  }
}