// ============================================================================
// lib/presentation/pages/vrc/vrc_consult_page.dart
// VRC CONSULT PAGE — Presentation Layer / UI
//
// QUÉ HACE:
// - Provee el formulario de entrada para la consulta VRC Individual.
// - Campos: placa del vehículo, tipo de documento, número de documento.
// - Modo standalone: navegado sin arguments → flujo VRC directo.
// - Modo registro: recibe arguments {plate, documentType, documentNumber,
//   fromRegistration:true} desde AssetRegistrationPage → pre-rellena el
//   formulario y navega a VrcResultPage(onRegister:...) al completar.
// - Muestra estado de carga mientras espera la respuesta del servidor.
// - Muestra error inline para estados failed/timeout sin salir de la página.
//
// QUÉ NO HACE:
// - No interpreta businessDecision ni señales operativas (eso es VrcResultPage).
// - No persiste el formulario entre sesiones.
// - No usa meta.sources.
//
// PRINCIPIOS:
// - StatelessWidget — el estado vive en VrcController (GetX).
// - La navegación a resultado ocurre solo cuando viewState ∈ {success, degraded}.
// - _fromRegistration siempre inicializado en el constructor (late final).
//
// ENTERPRISE NOTES:
// MODIFICADO (2026-04): Fase 2 VRC Gate — soporte modo registro desde
// AssetRegistrationPage. Pre-rellena formulario y usa Get.to(VrcResultPage)
// con onRegister callback en lugar de Get.toNamed(Routes.vrcResult).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../controllers/asset/asset_registration_controller.dart';
import '../../controllers/vrc/vrc_controller.dart';
import 'vrc_result_page.dart';

/// Página de formulario para la consulta VRC Individual.
///
/// Modos de uso:
/// - **Standalone**: navegado sin arguments → flujo VRC directo.
/// - **Registro**: navegado desde AssetRegistrationPage con arguments
///   `{plate, documentType, documentNumber, fromRegistration: true}` →
///   pre-rellena el formulario y, al completar, navega a
///   `VrcResultPage(onRegister: ...)` con el callback de registro.
class VrcConsultPage extends StatelessWidget {
  VrcConsultPage({super.key}) {
    // Siempre resetear el controller al crear la página — evita mostrar
    // estado stale (failed/success) de consultas previas al llegar aquí.
    _controller.reset();

    // Pre-rellenar desde argumentos de navegación (modo registro).
    final args = Get.arguments as Map<String, dynamic>?;
    // _fromRegistration siempre inicializado — false en modo standalone.
    _fromRegistration = args?['fromRegistration'] as bool? ?? false;

    debugPrint('[VRC_PAGE_ARGS] fromRegistration=$_fromRegistration');
    debugPrint('[VRC_PAGE_ARGS] args=$args');

    if (args != null) {
      final plate = args['plate'] as String?;
      final docType = args['documentType'] as String?;
      final docNumber = args['documentNumber'] as String?;

      if (plate != null) _plateCtrl.text = plate.toUpperCase();
      if (docNumber != null) _docNumberCtrl.text = docNumber;
      if (docType != null && _docTypes.contains(docType)) {
        _selectedDocType.value = docType;
      } else if (docType != null) {
        // docType llegó pero no está en _docTypes — fuerza el valor de todas formas.
        debugPrint('[VRC_PAGE_ARGS] WARNING: docType "$docType" no está en _docTypes $_docTypes — usando igual');
        _selectedDocType.value = docType;
      }

      debugPrint('[VRC_PAGE_ARGS] plate=${_plateCtrl.text}');
      debugPrint('[VRC_PAGE_ARGS] docType=${_selectedDocType.value}');
      debugPrint('[VRC_PAGE_ARGS] docNumber=${_docNumberCtrl.text}');
    }
  }

  final _controller = Get.find<VrcController>();
  final _formKey = GlobalKey<FormState>();

  final _plateCtrl = TextEditingController();
  final _docNumberCtrl = TextEditingController();

  // Tipos de documento soportados por el backend VRC.
  // Incluye 'C' además de 'CC' para compatibilidad con APIs que usan código corto.
  static const _docTypes = ['CC', 'C', 'CE', 'NIT', 'PAS', 'TI'];

  final _selectedDocType = 'CC'.obs;

  /// true cuando se navega desde AssetRegistrationPage (modo registro).
  late final bool _fromRegistration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta VRC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Nueva consulta',
            onPressed: () {
              _controller.reset();
              _plateCtrl.clear();
              _docNumberCtrl.clear();
              _selectedDocType.value = 'CC';
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormCard(context),
            const SizedBox(height: 24),
            Obx(() => _buildStateSection()),
          ],
        ),
      ),
    );
  }

  // ── Formulario ─────────────────────────────────────────────────────────────

  Widget _buildFormCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Datos del vehículo y propietario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Verificación de Registro y Condición (VRC)',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              // ── Placa ──────────────────────────────────────────────────────
              TextFormField(
                controller: _plateCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Placa del vehículo',
                  hintText: 'Ej: ABC123',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'La placa es requerida';
                  }
                  if (v.trim().length < 5) {
                    return 'Placa inválida (mínimo 5 caracteres)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Tipo de documento ──────────────────────────────────────────
              // InputDecorator + DropdownButton evita el `value` deprecated
              // de DropdownButtonFormField (Flutter >=3.33).
              Obx(
                () => InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de documento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDocType.value,
                      isDense: true,
                      isExpanded: true,
                      items: _docTypes
                          .map((t) =>
                              DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) _selectedDocType.value = v;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Número de documento ────────────────────────────────────────
              TextFormField(
                controller: _docNumberCtrl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Número de documento',
                  hintText: 'Ej: 12345678',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El número de documento es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ── Botón consultar ────────────────────────────────────────────
              Obx(() {
                final isLoading =
                    _controller.viewState == VrcViewState.loading;
                return ElevatedButton.icon(
                  onPressed: isLoading ? null : _onConsultarPressed,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(isLoading ? 'Consultando...' : 'Consultar VRC'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _onConsultarPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final plate = _plateCtrl.text.trim();
    final docType = _selectedDocType.value;
    final docNumber = _docNumberCtrl.text.trim();

    debugPrint('[VRC_PAGE_SUBMIT] plate=$plate');
    debugPrint('[VRC_PAGE_SUBMIT] documentType=$docType');
    debugPrint('[VRC_PAGE_SUBMIT] documentNumber=$docNumber');

    _controller
        .consultVehicle(
          plate: plate,
          documentType: docType,
          documentNumber: docNumber,
        )
        .then((_) => _handleConsultaComplete());
  }

  void _handleConsultaComplete() {
    final state = _controller.viewState;
    // Navegar a resultado cuando la consulta terminó (éxito o degradado)
    if (state == VrcViewState.success || state == VrcViewState.degraded) {
      if (_fromRegistration) {
        // Modo registro: VrcResultPage con callback que dispara el registro del activo.
        // Los datos del vehículo se leen del resultado VRC ya disponible en el controller.
        final vehicle = _controller.result?.data?.vehicle;
        Get.to<void>(
          () => VrcResultPage(
            onRegister: () =>
                Get.find<AssetRegistrationController>().registerVehicle(
              plate: vehicle?.plate ?? _plateCtrl.text.trim(),
              marca: vehicle?.make ?? '',
              modelo: vehicle?.line ?? '',
              anio: vehicle?.modelYear,
            ),
          ),
        );
      } else {
        // Modo standalone: flujo VRC directo sin callback de registro.
        Get.toNamed(Routes.vrcResult);
      }
    }
    // failed / timeout se muestran inline en esta misma página
  }

  // ── Sección de estado inline ───────────────────────────────────────────────

  Widget _buildStateSection() {
    switch (_controller.viewState) {
      case VrcViewState.idle:
        return _buildIdleHint();
      case VrcViewState.loading:
        return _buildLoading();
      case VrcViewState.failed:
        return _buildError(Icons.error_outline, Colors.red,
            _controller.errorMessage ?? 'Error al consultar VRC.');
      case VrcViewState.timeout:
        return _buildError(
          Icons.hourglass_empty,
          Colors.orange,
          _controller.errorMessage ??
              'La consulta tardó demasiado. El servidor puede estar procesando — intenta de nuevo.',
        );
      case VrcViewState.success:
      case VrcViewState.degraded:
        // Navegó a VrcResultPage; no mostrar nada aquí.
        return const SizedBox.shrink();
    }
  }

  Widget _buildIdleHint() {
    // Si el formulario está pre-cargado (modo registro), mostrar mensaje
    // contextual en lugar del hint de "ingresa los datos".
    final isPreFilled = _plateCtrl.text.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              isPreFilled ? Icons.check_circle_outline : Icons.search,
              size: 56,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              isPreFilled
                  ? 'Datos pre-cargados. Toca "Consultar VRC" para verificar el vehículo.'
                  : 'Ingresa placa y documento para verificar el vehículo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Consultando VRC…\nEsto puede tomar hasta 2 minutos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(IconData icon, Color color, String message) {
    return Card(
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 14),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _controller.reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}
