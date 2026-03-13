// ============================================================================
// lib/presentation/pages/admin/accounting/income_form_page.dart
// NUEVO INGRESO — Enterprise Ultra Pro (Presentation / Pages)
//
// QUÉ HACE:
// - Formulario de registro de ingresos con items, recaudos y cliente.
// - Usa ReactiveTextField para campos de texto con binding GetX (RxString).
//
// QUÉ NO HACE:
// - NO persiste datos (solo UI de captura).
// - NO define su propio widget de texto (usa ReactiveTextField compartido).
//
// NOTAS (CONTRATO UI):
// - uuid.v4() para IDs estables en IncomeItem y CollectionSplit.
// - Cards dinámicas como StatefulWidget con FocusNode + TextEditingController lifecycle.
// - Sin update() — solo items.refresh() / recaudos.refresh().
// - Detalles de arriendo: campos planos en controller (sin RentalDetails).
// - initState() usa fallback seguro (sin operador !).
// - Recaudos: al cambiar método, se limpian campos no aplicables (evita “basura” oculta).
// - VALIDACIÓN: si el método exige últimos 4, se exige NO vacío + exactamente 4 dígitos.
// ============================================================================

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/presentation/widgets/forms/reactive_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// ------------------------- Utilidades formato --------------------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

double _parseMoney(String input) {
  final digits = input.replaceAll(RegExp(r'[^\d]'), '');
  return digits.isEmpty ? 0 : (double.tryParse(digits) ?? 0);
}

// Dropdown styling reutilizable
final _kDropdownStyle = DropdownStyleData(
  decoration: BoxDecoration(
    color: const Color(0xFFF3F4F6),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFE5E7EB)),
  ),
);
const _kButtonStyle = ButtonStyleData(padding: EdgeInsets.zero);

// ------------------------------- MODELOS -------------------------------------

enum IncomeType {
  arriendoTiempo,
  arriendoTrayecto,
  ventaServicio,
  otrosIngresos
}

enum RentalTimeType { dia, semana, mes, anio, rango }

enum CollectionMethod { efectivo, transferencia, debito, credito, cheque, otro }

class IncomeItem {
  IncomeItem({
    String? id,
    this.concepto = '',
    this.vrUnit = 0,
    this.cantidad = 1,
    this.gravaIVA = true,
  }) : id = id ?? _uuid.v4();

  final String id;
  String concepto;
  double vrUnit;
  int cantidad;
  bool gravaIVA;

  double get total => (vrUnit * cantidad).toDouble();
}

class CollectionSplit {
  CollectionSplit({
    String? id,
    this.method = CollectionMethod.transferencia,
    this.monto = 0,
    this.banco,
    this.accountLast4,
    this.referencia,
    this.nota,
  }) : id = id ?? _uuid.v4();

  final String id;
  CollectionMethod method;
  double monto;

  String? banco;
  String? accountLast4; // Últimos 4 dígitos tarjeta/cuenta
  String? referencia;
  String? nota;
}

// ------------------------------ CONTROLLER -----------------------------------

class IncomeFormController extends GetxController {
  // Identificación
  final fecha = DateTime.now().obs;
  final consecutivo = 'ING-${DateTime.now().year}-00001'.obs;
  final assetType = AssetType.vehiculo.obs;
  final centroCosto = ''.obs;
  final incomeType = IncomeType.arriendoTiempo.obs;

  // Cliente
  final cliente = ''.obs;
  final nit = ''.obs;
  final direccion = ''.obs;
  final contacto = ''.obs;

  // Detalles de Arriendo — campos planos (sin RentalDetails.obs)
  final rentalTimeType = RentalTimeType.dia.obs;
  final rentalTimeStart = Rxn<DateTime>();
  final rentalTimeEnd = Rxn<DateTime>();
  final rentalOrigin = ''.obs;
  final rentalDestination = ''.obs;

  // Ítems de Ingreso
  final items = <IncomeItem>[IncomeItem()].obs;

  void addItem() => items.add(IncomeItem());

  void removeItem(int index) {
    if (items.length > 1) items.removeAt(index);
  }

  double get totalItems =>
      items.fold<double>(0, (s, e) => s + (e.total.isFinite ? e.total : 0));

  double get totalIVA =>
      items.fold<double>(0, (s, e) => s + (e.gravaIVA ? e.total * 0.19 : 0));

  double get totalIncome => totalItems + totalIVA;

  // Recaudos
  final recaudos = <CollectionSplit>[CollectionSplit()].obs;

  void addRecaudo() => recaudos.add(CollectionSplit());

  void removeRecaudo(int index) {
    if (recaudos.length > 1) recaudos.removeAt(index);
  }

  double get totalRecaudos =>
      recaudos.fold<double>(0, (s, p) => s + (p.monto.isFinite ? p.monto : 0));

  double get diferencia => (totalIncome - totalRecaudos);
  final marcarComoCxC = false.obs;

  String? validate() {
    if (cliente.value.trim().isEmpty) return 'Falta el nombre del cliente.';
    if (centroCosto.value.trim().isEmpty) return 'Falta el centro de ingreso.';
    if (items.any((e) => e.concepto.trim().isEmpty)) {
      return 'Hay ítems sin concepto.';
    }
    if (items.any((e) => e.vrUnit <= 0 || e.cantidad <= 0)) {
      return 'Ítems con valores/cantidades inválidos.';
    }
    if (totalIncome <= 0) {
      return 'El total del ingreso (incl. IVA) debe ser mayor a 0.';
    }

    // comparación segura con tolerancia de float
    if (diferencia.abs() >= 0.01 && !marcarComoCxC.value) {
      return 'El total de recaudos no coincide. Marca diferencia como CxC o ajusta montos.';
    }

    for (final p in recaudos) {
      final needsBanco = p.method != CollectionMethod.efectivo &&
          p.method != CollectionMethod.otro;

      if (needsBanco && (p.banco == null || p.banco!.trim().isEmpty)) {
        return 'Falta banco en un recaudo no en efectivo.';
      }

      final needsLast4 = p.method == CollectionMethod.debito ||
          p.method == CollectionMethod.credito ||
          p.method == CollectionMethod.transferencia;

      // FIX: Si exige last4 -> NO vacío + exactamente 4 dígitos
      if (needsLast4) {
        final v = (p.accountLast4 ?? '').trim();
        if (v.isEmpty || v.length != 4) {
          return 'Faltan los últimos 4 dígitos en un recaudo (debe tener 4 números).';
        }
        if (!RegExp(r'^\d{4}$').hasMatch(v)) {
          return 'Los últimos 4 dígitos deben ser numéricos (4 números).';
        }
      }

      final needsRef = p.method != CollectionMethod.efectivo;
      if (needsRef && (p.referencia == null || p.referencia!.trim().isEmpty)) {
        return 'Falta referencia / No. transacción en un recaudo no en efectivo.';
      }

      final needsNota = p.method == CollectionMethod.otro;
      if (needsNota && (p.nota == null || p.nota!.trim().isEmpty)) {
        return 'Falta nota para el recaudo con método "Otro".';
      }
    }

    if (incomeType.value == IncomeType.arriendoTiempo &&
        rentalTimeType.value == RentalTimeType.rango &&
        (rentalTimeStart.value == null ||
            rentalTimeEnd.value == null ||
            rentalTimeStart.value!.isAfter(rentalTimeEnd.value!))) {
      return 'Rango de tiempo de arriendo inválido.';
    }

    if (incomeType.value == IncomeType.arriendoTrayecto &&
        (rentalOrigin.value.trim().isEmpty ||
            rentalDestination.value.trim().isEmpty)) {
      return 'Ruta (Origen/Destino) requerida para arriendo por trayecto.';
    }

    return null;
  }

  Future<void> save() async {
    final error = validate();
    if (error != null) {
      Get.snackbar(
        'Validación',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // SIMULACIÓN (UI only). Persistencia se hace en capa de aplicación.
    await Future.delayed(const Duration(milliseconds: 300));

    Get.snackbar(
      '✓ Éxito',
      'Ingreso guardado correctamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}

// --------------------------------- PAGE --------------------------------------

class IncomeFormPage extends StatelessWidget {
  const IncomeFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(IncomeFormController(), permanent: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Nuevo Ingreso',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1A1A1A),
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                  const Color(0xFF059669).withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const Column(
                  children: [
                    Text(
                      'Registra el ingreso por arriendo o venta',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                    children: [
                      // 1. Consecutivo & Tipo
                      _ModernSection(
                        title: '📋 Consecutivo & Tipo',
                        headerExtra: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF059669),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF10B981).withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              '#${c.consecutivo.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _ModernFechaField(c: c)),
                                const SizedBox(width: 12),
                                Expanded(child: _ModernSelectAssetType(c: c)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _ModernSelectIncomeType(c: c),
                            const SizedBox(height: 16),
                            _ModernCentroCostoField(c: c),
                            Obx(
                              () => (c.incomeType.value ==
                                          IncomeType.arriendoTiempo ||
                                      c.incomeType.value ==
                                          IncomeType.arriendoTrayecto)
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        _RentalSpecificFields(c: c),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Valor Recibido
                      _ModernSection(
                        title: '💰 Valor Recibido',
                        trailing: Obx(
                          () => Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF059669),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF10B981).withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              _money.format(c.totalIncome),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Detalle del Ingreso'),
                            const SizedBox(height: 16),
                            Obx(
                              () => Column(
                                children: [
                                  for (int i = 0; i < c.items.length; i++)
                                    _ModernIncomeItemCard(
                                      key: ValueKey(c.items[i].id),
                                      itemId: c.items[i].id,
                                      visualIndex: i,
                                      c: c,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _IncomeAddButton(
                              label: 'Agregar Ítem de Ingreso',
                              icon: Icons.add_circle_outline,
                              onPressed: c.addItem,
                            ),
                            const SizedBox(height: 16),
                            _IncomeSummary(c: c),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Cliente
                      _ModernSection(
                        title: '👤 Cliente',
                        child: Column(
                          children: [
                            ReactiveTextField(
                              label: 'Persona / Organización (Cliente)',
                              hint: 'Ej. Constructora XYZ',
                              value: c.cliente,
                              icon: Icons.business_outlined,
                            ),
                            const SizedBox(height: 16),
                            ReactiveTextField(
                              label: 'NIT / CC',
                              hint: '123456789-0',
                              value: c.nit,
                              icon: Icons.badge_outlined,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            ReactiveTextField(
                              label: 'Dirección',
                              hint: 'Calle 123 #45-67',
                              value: c.direccion,
                              icon: Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 16),
                            ReactiveTextField(
                              label: 'Contacto',
                              hint: 'Ej. Juan Pérez (Gerente)',
                              value: c.contacto,
                              icon: Icons.person_outline,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 4. Métodos de Recaudo
                      _ModernSection(
                        title: '💳 Métodos de Recaudo',
                        trailing: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF059669),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _money.format(c.totalRecaudos),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Obx(
                              () => Column(
                                children: [
                                  for (int i = 0; i < c.recaudos.length; i++)
                                    _ModernRecaudoCard(
                                      key: ValueKey(c.recaudos[i].id),
                                      recaudoId: c.recaudos[i].id,
                                      visualIndex: i,
                                      c: c,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _IncomeAddButton(
                              label: 'Agregar Recaudo',
                              icon: Icons.account_balance_wallet_outlined,
                              onPressed: c.addRecaudo,
                            ),
                            const SizedBox(height: 16),
                            Obx(() {
                              final diff = c.diferencia;
                              if (diff.abs() < 0.01) {
                                return const _IncomeBalanceCard(
                                  label: '✓ Balanceado',
                                  amount: 0,
                                  isBalanced: true,
                                );
                              }
                              return Column(
                                children: [
                                  _IncomeBalanceCard(
                                    label: diff > 0
                                        ? 'Por Cobrar (CxC)'
                                        : 'Excedente (Error)',
                                    amount: diff.abs(),
                                    isBalanced: false,
                                  ),
                                  const SizedBox(height: 12),
                                  _IncomeCheckbox(
                                    label: 'Marcar diferencia como CxC',
                                    value: c.marcarComoCxC,
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating Submit Button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _IncomeSubmitButton(onPressed: c.save),
          ),
        ],
      ),
    );
  }
}

// ========================= PRIVATE WIDGETS ====================================

class _ModernSection extends StatelessWidget {
  const _ModernSection({
    required this.title,
    required this.child,
    this.trailing,
    this.headerExtra,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final Widget? headerExtra;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    if (headerExtra != null) ...[
                      const SizedBox(width: 8),
                      headerExtra!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ModernFechaField extends StatelessWidget {
  const _ModernFechaField({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: c.fecha.value,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF10B981),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) c.fecha.value = picked;
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Color(0xFF9CA3AF), size: 18),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('dd/MM/yyyy').format(c.fecha.value),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModernSelectAssetType extends StatelessWidget {
  const _ModernSelectAssetType({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activo Arrendado',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AssetType>(
                value: c.assetType.value,
                isExpanded: true,
                icon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
                items: AssetType.values
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(_assetTypeLabel(t)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) c.assetType.value = v;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _assetTypeLabel(AssetType t) {
    switch (t) {
      case AssetType.vehiculo:
        return '🚗 Vehículo';
      case AssetType.inmueble:
        return '🏢 Inmueble';
      case AssetType.maquinaria:
        return '🏗️ Maquinaria';
      case AssetType.equipo:
        return '💼 Equipo';
      case AssetType.otro:
        return '✨ Otro';
    }
  }
}

class _ModernSelectIncomeType extends StatelessWidget {
  const _ModernSelectIncomeType({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Ingreso',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<IncomeType>(
                value: c.incomeType.value,
                isExpanded: true,
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
                dropdownStyleData: _kDropdownStyle,
                buttonStyleData: _kButtonStyle,
                items: IncomeType.values
                    .map(
                      (t) => DropdownMenuItem<IncomeType>(
                        value: t,
                        child: Text(_incomeTypeLabel(t)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) c.incomeType.value = v;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _incomeTypeLabel(IncomeType t) {
    switch (t) {
      case IncomeType.arriendoTiempo:
        return '📅 Arriendo por Tiempo';
      case IncomeType.arriendoTrayecto:
        return '🛣️ Arriendo por Trayecto/Ruta';
      case IncomeType.ventaServicio:
        return '🛠️ Venta de Servicio Adicional';
      case IncomeType.otrosIngresos:
        return '💸 Otros Ingresos';
    }
  }
}

class _ModernCentroCostoField extends StatelessWidget {
  const _ModernCentroCostoField({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      label: 'Centro de Ingreso/Costo',
      hint: 'Ej. Proyecto Norte / Obra 5',
      value: c.centroCosto,
      icon: Icons.account_tree_outlined,
    );
  }
}

// Campos específicos para arriendo — usa campos planos del controller.
class _RentalSpecificFields extends StatelessWidget {
  const _RentalSpecificFields({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    if (c.incomeType.value == IncomeType.arriendoTiempo) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles del Arriendo por Tiempo',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<RentalTimeType>(
                  value: c.rentalTimeType.value,
                  isExpanded: true,
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                  dropdownStyleData: _kDropdownStyle,
                  buttonStyleData: _kButtonStyle,
                  items: RentalTimeType.values
                      .map(
                        (t) => DropdownMenuItem<RentalTimeType>(
                          value: t,
                          child: Text(_rentalTimeLabel(t)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      c.rentalTimeType.value = v;
                      if (v != RentalTimeType.rango) {
                        c.rentalTimeStart.value = null;
                        c.rentalTimeEnd.value = null;
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => c.rentalTimeType.value == RentalTimeType.rango
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => _ModernDateField(
                                label: 'Fecha Inicio',
                                initialDate: c.rentalTimeStart.value,
                                onDateSelected: (date) =>
                                    c.rentalTimeStart.value = date,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(
                              () => _ModernDateField(
                                label: 'Fecha Fin',
                                initialDate: c.rentalTimeEnd.value,
                                onDateSelected: (date) =>
                                    c.rentalTimeEnd.value = date,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    } else if (c.incomeType.value == IncomeType.arriendoTrayecto) {
      return Column(
        children: [
          const Text(
            'Detalles del Arriendo por Trayecto',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          ReactiveTextField(
            label: 'Origen',
            hint: 'Ej. Bodega Central',
            value: c.rentalOrigin,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          ReactiveTextField(
            label: 'Destino',
            hint: 'Ej. Obra El Nogal',
            value: c.rentalDestination,
            icon: Icons.assistant_direction_outlined,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  static String _rentalTimeLabel(RentalTimeType t) {
    switch (t) {
      case RentalTimeType.dia:
        return 'Por Día';
      case RentalTimeType.semana:
        return 'Por Semana';
      case RentalTimeType.mes:
        return 'Por Mes';
      case RentalTimeType.anio:
        return 'Por Año';
      case RentalTimeType.rango:
        return 'Rango Específico';
    }
  }
}

class _ModernDateField extends StatelessWidget {
  const _ModernDateField({
    required this.label,
    required this.onDateSelected,
    required this.color,
    this.initialDate,
  });

  final String label;
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: color),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) onDateSelected(picked);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Color(0xFF9CA3AF), size: 18),
                const SizedBox(width: 12),
                Text(
                  initialDate == null
                      ? 'Seleccionar...'
                      : DateFormat('dd/MM/yyyy').format(initialDate!),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== _ModernIncomeItemCard ====================

class _ModernIncomeItemCard extends StatefulWidget {
  const _ModernIncomeItemCard({
    super.key,
    required this.itemId,
    required this.visualIndex,
    required this.c,
  });

  final String itemId;
  final int visualIndex;
  final IncomeFormController c;

  @override
  State<_ModernIncomeItemCard> createState() => _ModernIncomeItemCardState();
}

class _ModernIncomeItemCardState extends State<_ModernIncomeItemCard> {
  late TextEditingController conceptCtrl;
  late TextEditingController vrCtrl;
  late TextEditingController qtyCtrl;

  late final FocusNode conceptFocus;
  late final FocusNode vrFocus;
  late final FocusNode qtyFocus;

  IncomeItem? get _itemOrNull {
    final i = widget.c.items.indexWhere((e) => e.id == widget.itemId);
    return i >= 0 ? widget.c.items[i] : null;
  }

  @override
  void initState() {
    super.initState();
    final item = _itemOrNull;
    conceptCtrl = TextEditingController(text: item?.concepto ?? '');
    vrCtrl = TextEditingController(
        text: (item != null && item.vrUnit > 0)
            ? item.vrUnit.toStringAsFixed(0)
            : '');
    qtyCtrl = TextEditingController(text: (item?.cantidad ?? 1).toString());

    conceptFocus = FocusNode();
    vrFocus = FocusNode();
    qtyFocus = FocusNode();
  }

  @override
  void didUpdateWidget(_ModernIncomeItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final item = _itemOrNull;
    if (item == null) return;

    if (oldWidget.itemId != widget.itemId) {
      if (!conceptFocus.hasFocus) conceptCtrl.text = item.concepto;
      if (!vrFocus.hasFocus) {
        vrCtrl.text = item.vrUnit > 0 ? item.vrUnit.toStringAsFixed(0) : '';
      }
      if (!qtyFocus.hasFocus) qtyCtrl.text = item.cantidad.toString();
      return;
    }

    final newConcepto = item.concepto;
    if (!conceptFocus.hasFocus && conceptCtrl.text != newConcepto) {
      conceptCtrl.text = newConcepto;
    }

    final newVr = item.vrUnit > 0 ? item.vrUnit.toStringAsFixed(0) : '';
    if (!vrFocus.hasFocus && vrCtrl.text != newVr) vrCtrl.text = newVr;

    final newQty = item.cantidad.toString();
    if (!qtyFocus.hasFocus && qtyCtrl.text != newQty) qtyCtrl.text = newQty;
  }

  @override
  void dispose() {
    conceptCtrl.dispose();
    vrCtrl.dispose();
    qtyCtrl.dispose();

    conceptFocus.dispose();
    vrFocus.dispose();
    qtyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _itemOrNull;
    if (item == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.05),
            const Color(0xFF059669).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.visualIndex + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ítem ${widget.visualIndex + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (widget.c.items.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444)),
                  onPressed: () {
                    final idx =
                        widget.c.items.indexWhere((e) => e.id == widget.itemId);
                    if (idx >= 0) widget.c.removeItem(idx);
                  },
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Concepto
          TextFormField(
            controller: conceptCtrl,
            focusNode: conceptFocus,
            onChanged: (v) {
              item.concepto = v;
              widget.c.items.refresh();
            },
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Concepto',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Vr. Unitario | Cantidad | Sub-Total
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: vrCtrl,
                  focusNode: vrFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    item.vrUnit = _parseMoney(v);
                    widget.c.items.refresh();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Vr. Unitario',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: qtyCtrl,
                  focusNode: qtyFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    item.cantidad = int.tryParse(v) ?? 1;
                    widget.c.items.refresh();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Cant.',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Sub - Total',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _money.format(item.total),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _IVAPillToggle(
            value: item.gravaIVA,
            onToggle: () {
              item.gravaIVA = !item.gravaIVA;
              widget.c.items.refresh();
            },
          ),
        ],
      ),
    );
  }
}

// ==================== _IncomeSummary ====================

class _IncomeSummary extends StatelessWidget {
  const _IncomeSummary({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          _SummaryRow(
            label: 'Subtotal Items',
            amount: c.totalItems,
            isTotal: false,
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'IVA (19%)',
            amount: c.totalIVA,
            isTotal: false,
          ),
          const Divider(height: 20, thickness: 1, color: Color(0xFFE5E7EB)),
          _SummaryRow(
            label: 'Valor Total',
            amount: c.totalIncome,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    required this.isTotal,
  });

  final String label;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? const Color(0xFF059669) : const Color(0xFF6B7280),
          ),
        ),
        Text(
          _money.format(amount),
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? const Color(0xFF059669) : const Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}

// ==================== _ModernRecaudoCard ====================

class _ModernRecaudoCard extends StatefulWidget {
  const _ModernRecaudoCard({
    super.key,
    required this.recaudoId,
    required this.visualIndex,
    required this.c,
  });

  final String recaudoId;
  final int visualIndex;
  final IncomeFormController c;

  @override
  State<_ModernRecaudoCard> createState() => _ModernRecaudoCardState();
}

class _ModernRecaudoCardState extends State<_ModernRecaudoCard> {
  late TextEditingController montoCtrl;
  late TextEditingController bancoCtrl;
  late TextEditingController refCtrl;
  late TextEditingController notaCtrl;
  late TextEditingController last4Ctrl;

  late final FocusNode montoFocus;
  late final FocusNode bancoFocus;
  late final FocusNode refFocus;
  late final FocusNode notaFocus;
  late final FocusNode last4Focus;

  CollectionSplit? get _recaudoOrNull {
    final i = widget.c.recaudos.indexWhere((e) => e.id == widget.recaudoId);
    return i >= 0 ? widget.c.recaudos[i] : null;
  }

  @override
  void initState() {
    super.initState();
    final r = _recaudoOrNull;

    montoCtrl = TextEditingController(
        text: (r != null && r.monto > 0) ? r.monto.toStringAsFixed(0) : '');
    bancoCtrl = TextEditingController(text: r?.banco ?? '');
    refCtrl = TextEditingController(text: r?.referencia ?? '');
    notaCtrl = TextEditingController(text: r?.nota ?? '');
    last4Ctrl = TextEditingController(text: r?.accountLast4 ?? '');

    montoFocus = FocusNode();
    bancoFocus = FocusNode();
    refFocus = FocusNode();
    notaFocus = FocusNode();
    last4Focus = FocusNode();
  }

  @override
  void didUpdateWidget(_ModernRecaudoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final r = _recaudoOrNull;
    if (r == null) return;

    if (oldWidget.recaudoId != widget.recaudoId) {
      if (!montoFocus.hasFocus) {
        montoCtrl.text = r.monto > 0 ? r.monto.toStringAsFixed(0) : '';
      }
      if (!bancoFocus.hasFocus) bancoCtrl.text = r.banco ?? '';
      if (!refFocus.hasFocus) refCtrl.text = r.referencia ?? '';
      if (!notaFocus.hasFocus) notaCtrl.text = r.nota ?? '';
      if (!last4Focus.hasFocus) last4Ctrl.text = r.accountLast4 ?? '';
      return;
    }

    final newMonto = r.monto > 0 ? r.monto.toStringAsFixed(0) : '';
    if (!montoFocus.hasFocus && montoCtrl.text != newMonto) {
      montoCtrl.text = newMonto;
    }

    final newBanco = r.banco ?? '';
    if (!bancoFocus.hasFocus && bancoCtrl.text != newBanco) {
      bancoCtrl.text = newBanco;
    }

    final newRef = r.referencia ?? '';
    if (!refFocus.hasFocus && refCtrl.text != newRef) refCtrl.text = newRef;

    final newNota = r.nota ?? '';
    if (!notaFocus.hasFocus && notaCtrl.text != newNota) {
      notaCtrl.text = newNota;
    }

    final newLast4 = r.accountLast4 ?? '';
    if (!last4Focus.hasFocus && last4Ctrl.text != newLast4) {
      last4Ctrl.text = newLast4;
    }
  }

  @override
  void dispose() {
    montoCtrl.dispose();
    bancoCtrl.dispose();
    refCtrl.dispose();
    notaCtrl.dispose();
    last4Ctrl.dispose();

    montoFocus.dispose();
    bancoFocus.dispose();
    refFocus.dispose();
    notaFocus.dispose();
    last4Focus.dispose();
    super.dispose();
  }

  bool _needsBanco(CollectionMethod m) =>
      m != CollectionMethod.efectivo && m != CollectionMethod.otro;

  bool _needsLast4(CollectionMethod m) =>
      m == CollectionMethod.debito ||
      m == CollectionMethod.credito ||
      m == CollectionMethod.transferencia;

  bool _needsRef(CollectionMethod m) => m != CollectionMethod.efectivo;

  bool _needsNota(CollectionMethod m) => m == CollectionMethod.otro;

  @override
  Widget build(BuildContext context) {
    final r = _recaudoOrNull;
    if (r == null) return const SizedBox.shrink();

    final needsBanco = _needsBanco(r.method);
    final needsLast4 = _needsLast4(r.method);
    final needsRef = _needsRef(r.method);
    final needsNota = _needsNota(r.method);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.05),
            const Color(0xFF059669).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Recaudo ${widget.visualIndex + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (widget.c.recaudos.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444)),
                  onPressed: () {
                    final idx = widget.c.recaudos
                        .indexWhere((e) => e.id == widget.recaudoId);
                    if (idx >= 0) widget.c.removeRecaudo(idx);
                  },
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Método
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<CollectionMethod>(
                value: r.method,
                isExpanded: true,
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
                dropdownStyleData: _kDropdownStyle,
                buttonStyleData: _kButtonStyle,
                items: CollectionMethod.values
                    .map(
                      (m) => DropdownMenuItem<CollectionMethod>(
                        value: m,
                        child: Text(_collectionMethodLabel(m)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;

                  final old = r.method;
                  r.method = v;

                  if (!_needsBanco(v)) {
                    r.banco = null;
                    if (!bancoFocus.hasFocus) bancoCtrl.text = '';
                  }

                  if (!_needsLast4(v)) {
                    r.accountLast4 = null;
                    if (!last4Focus.hasFocus) last4Ctrl.text = '';
                  }

                  if (!_needsRef(v)) {
                    r.referencia = null;
                    if (!refFocus.hasFocus) refCtrl.text = '';
                  }

                  if (!_needsNota(v)) {
                    r.nota = null;
                    if (!notaFocus.hasFocus) notaCtrl.text = '';
                  }

                  if (old == CollectionMethod.cheque && _needsLast4(v)) {
                    r.accountLast4 = null;
                    if (!last4Focus.hasFocus) last4Ctrl.text = '';
                  }

                  widget.c.recaudos.refresh();
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Monto + Banco
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: montoCtrl,
                  focusNode: montoFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    r.monto = _parseMoney(v);
                    widget.c.recaudos.refresh();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Monto Recibido',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
              if (needsBanco) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: bancoCtrl,
                    focusNode: bancoFocus,
                    onChanged: (v) {
                      r.banco = v.trim().isEmpty ? null : v.trim();
                      widget.c.recaudos.refresh();
                    },
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: 'Banco',
                      hintText: 'Ej. Bancolombia',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Últimos 4 dígitos
          if (needsLast4) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: last4Ctrl,
                      focusNode: last4Focus,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        r.accountLast4 = v.isEmpty ? null : v;
                        widget.c.recaudos.refresh();
                      },
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: 'Últimos 4 dígitos',
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Referencia (si no es efectivo)
          if (needsRef) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: refCtrl,
              focusNode: refFocus,
              onChanged: (v) {
                r.referencia = v.trim().isEmpty ? null : v.trim();
                widget.c.recaudos.refresh();
              },
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: 'Referencia / No. Transacción',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
          ],

          // Nota (solo para "otro")
          if (needsNota) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: notaCtrl,
              focusNode: notaFocus,
              onChanged: (v) {
                r.nota = v.trim().isEmpty ? null : v.trim();
                widget.c.recaudos.refresh();
              },
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: 'Nota del Otro Recaudo',
                hintText: 'Ej. Criptomoneda, Activo canjeado',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _collectionMethodLabel(CollectionMethod m) {
    switch (m) {
      case CollectionMethod.efectivo:
        return '💵 Efectivo';
      case CollectionMethod.transferencia:
        return '📲 Transferencia Bancaria';
      case CollectionMethod.debito:
        return '💳 Tarjeta Débito';
      case CollectionMethod.credito:
        return '💳 Tarjeta Crédito';
      case CollectionMethod.cheque:
        return '📜 Cheque';
      case CollectionMethod.otro:
        return '✨ Otro Método';
    }
  }
}

// ==================== Enterprise Buttons, Toggles & Cards ====================

class _IVAPillToggle extends StatelessWidget {
  const _IVAPillToggle({
    required this.value,
    required this.onToggle,
  });

  final bool value;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color:
              value ? const Color(0xFF10B981).withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                gradient: value
                    ? const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      )
                    : null,
                color: value ? null : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? Colors.transparent : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              'Aplica IVA (19%)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    value ? const Color(0xFF10B981) : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeAddButton extends StatelessWidget {
  const _IncomeAddButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF10B981), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF10B981), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeCheckbox extends StatelessWidget {
  const _IncomeCheckbox({required this.label, required this.value});

  final String label;
  final RxBool value;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () => value.value = !value.value,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: value.value
                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value.value
                  ? const Color(0xFF10B981)
                  : const Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: value.value
                      ? const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        )
                      : null,
                  color: value.value ? null : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: value.value
                        ? Colors.transparent
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                ),
                child: value.value
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: value.value
                        ? const Color(0xFF10B981)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncomeBalanceCard extends StatelessWidget {
  const _IncomeBalanceCard({
    required this.label,
    required this.amount,
    required this.isBalanced,
  });

  final String label;
  final double amount;
  final bool isBalanced;

  @override
  Widget build(BuildContext context) {
    final gradientColors = isBalanced
        ? [const Color(0xFF10B981), const Color(0xFF059669)]
        : [const Color(0xFF3B82F6), const Color(0xFF2563EB)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isBalanced ? Icons.check_circle : Icons.info,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isBalanced)
                  Text(
                    _money.format(amount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeSubmitButton extends StatelessWidget {
  const _IncomeSubmitButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_rounded, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'Guardar Ingreso',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
