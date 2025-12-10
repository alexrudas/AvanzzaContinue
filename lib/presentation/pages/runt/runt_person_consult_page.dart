import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/runt/models/runt_person_models.dart';
import '../../controllers/runt/runt_controller.dart';

/// Pantalla de consulta RUNT para personas (conductores).
///
/// Usa exclusivamente los modelos tipados:
/// - RuntPersonData
/// - RuntLicense
/// - RuntLicenseDetail
/// - RuntPersonInternalMetadata
class RuntPersonConsultPage extends GetView<RuntController> {
  RuntPersonConsultPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta RUNT Persona'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpiar consulta',
            onPressed: () {
              controller.resetPersonForm();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormSection(),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.isLoadingPerson) {
                return _buildLoadingState();
              }

              if (controller.errorMessage != null) {
                return _buildErrorState(controller.errorMessage!);
              }

              final RuntPersonData? person = controller.personData;
              if (person != null) {
                return _buildResultsSection(person);
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
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.documentType.value,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de documento',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'C',
                      child: Text('Cédula de ciudadanía'),
                    ),
                    DropdownMenuItem(
                      value: 'E',
                      child: Text('Cédula de extranjería'),
                    ),
                    DropdownMenuItem(
                      value: 'P',
                      child: Text('Pasaporte'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.documentType.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.documentController,
                decoration: const InputDecoration(
                  labelText: 'Número de documento',
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
      final document = controller.documentController.text.trim();
      final tipoDoc = controller.documentType.value;

      controller.consultarPersona(document, tipoDoc);
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

  Widget _buildErrorState(String message) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.red.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: controller.resetError,
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
            Icon(Icons.person_search, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Ingresa un documento para consultar',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== RESULTADOS ====================

  Widget _buildResultsSection(RuntPersonData person) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMainDataCard(person),
        const SizedBox(height: 16),
        _buildLicensesSection(person.licencias),
        const SizedBox(height: 16),
        if (person.internalMetadata != null)
          _buildMetadataCard(person.internalMetadata!),
      ],
    );
  }

  Widget _buildMainDataCard(RuntPersonData person) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person, size: 32),
                SizedBox(width: 8),
                Text(
                  'Datos principales',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Nombre', person.fullName),
            _buildInfoRow('Documento', person.documentNumber),
            if (person.documentType != null &&
                person.documentType!.trim().isNotEmpty)
              _buildInfoRow('Tipo documento', person.documentType!),
            if (person.personStatus != null &&
                person.personStatus!.trim().isNotEmpty)
              _buildInfoRow(
                'Estado persona',
                person.personStatus!,
                statusColor: _getStatusColor(person.personStatus),
              ),
            if (person.driverStatus != null &&
                person.driverStatus!.trim().isNotEmpty)
              _buildInfoRow(
                'Estado conductor',
                person.driverStatus!,
                statusColor: _getStatusColor(person.driverStatus),
              ),
            if (person.runtRegistrationNumber != null &&
                person.runtRegistrationNumber!.trim().isNotEmpty)
              _buildInfoRow(
                'N° inscripción RUNT',
                person.runtRegistrationNumber!,
              ),
            if (person.registrationDate != null &&
                person.registrationDate!.trim().isNotEmpty)
              _buildInfoRow(
                'Fecha inscripción',
                person.registrationDate!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicensesSection(List<RuntLicense> licenses) {
    if (licenses.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No se encontraron licencias',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Licencias de conducción (${licenses.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...licenses.map(_buildLicenseCard),
      ],
    );
  }

  Widget _buildLicenseCard(RuntLicense license) {
    final String titleNumber = license.licenseNumber != null &&
            license.licenseNumber!.trim().isNotEmpty
        ? license.licenseNumber!
        : 'N/A';

    final String subtitleStatus =
        license.estado != null && license.estado!.trim().isNotEmpty
            ? license.estado!
            : 'Sin estado';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: const Icon(Icons.badge),
        title: Text('Licencia $titleNumber'),
        subtitle: Text(subtitleStatus),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (license.issuingAuthority != null &&
                    license.issuingAuthority!.trim().isNotEmpty)
                  _buildInfoRow('Organismo', license.issuingAuthority!),
                if (license.issueDate != null &&
                    license.issueDate!.trim().isNotEmpty)
                  _buildInfoRow('Fecha expedición', license.issueDate!),
                if (license.estado != null && license.estado!.trim().isNotEmpty)
                  _buildInfoRow(
                    'Estado',
                    license.estado!,
                    statusColor: _getStatusColor(license.estado),
                  ),
                if (license.restricciones != null &&
                    license.restricciones!.trim().isNotEmpty)
                  _buildInfoRow('Restricciones', license.restricciones!),
                if (license.retention != null &&
                    license.retention!.trim().isNotEmpty)
                  _buildInfoRow('Retención', license.retention!),
                if (license.cancelingAuthority != null &&
                    license.cancelingAuthority!.trim().isNotEmpty)
                  _buildInfoRow(
                    'Organismo cancela/suspende',
                    license.cancelingAuthority!,
                  ),
                const Divider(height: 24),
                _buildLicenseDetailsSection(license.detalles),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseDetailsSection(List<RuntLicenseDetail> details) {
    if (details.isEmpty) {
      return const Text(
        'Sin categorías registradas',
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categorías:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...details.map(_buildLicenseDetailItem),
      ],
    );
  }

  Widget _buildLicenseDetailItem(RuntLicenseDetail detail) {
    final String categoryLabel =
        detail.category != null && detail.category!.trim().isNotEmpty
            ? detail.category!
            : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              categoryLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detail.issueDate != null &&
                    detail.issueDate!.trim().isNotEmpty)
                  Text(
                    'Expedición: ${detail.issueDate}',
                    style: const TextStyle(fontSize: 12),
                  ),
                if (detail.expiryDate != null &&
                    detail.expiryDate!.trim().isNotEmpty)
                  Text(
                    'Vence: ${detail.expiryDate}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                if (detail.previousCategory != null &&
                    detail.previousCategory!.trim().isNotEmpty)
                  Text(
                    'Cat. anterior: ${detail.previousCategory}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard(RuntPersonInternalMetadata metadata) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información de consulta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (metadata.totalLicenses != null)
                    Text('Total de licencias: ${metadata.totalLicenses}'),
                  if (metadata.queryDate != null)
                    Text('Fecha de consulta: ${metadata.queryDate}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== WIDGETS DE UTILIDAD ====================

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color? _getStatusColor(String? status) {
    if (status == null) return null;
    final statusLower = status.toLowerCase();

    if (statusLower.contains('activ') || statusLower.contains('vigente')) {
      return Colors.green.shade700;
    }
    if (statusLower.contains('suspend') || statusLower.contains('vencid')) {
      return Colors.red.shade700;
    }
    if (statusLower.contains('inactiv')) {
      return Colors.orange.shade700;
    }
    return null;
  }
}
