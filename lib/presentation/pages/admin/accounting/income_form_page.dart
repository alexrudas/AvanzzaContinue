// lib/presentation/accounting/income_form_page.dart
// ============================================================================
// NUEVO INGRESO — Avanzza 2.0 (UI PRO 2025 + lógica optimizada para ingresos)
// REEMPLAZADO: 'revenue' por 'income' en todo el archivo.
// ============================================================================

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para TextInputFormatter
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ------------------------- Utilidades formato --------------------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

// ------------------------------- MODELOS -------------------------------------

// Actualizado: Tipos de Ingreso (Income Type)
enum IncomeType {
  arriendoTiempo,
  arriendoTrayecto,
  ventaServicio, // Puede ser un servicio relacionado al arriendo (ej. entrega)
  otrosIngresos
}

// Nuevo: Modalidad de Arriendo por Tiempo
enum RentalTimeType { dia, semana, mes, anio, rango }

// Nuevo: Modalidad de Pago Recibido (similar a PaymentMethod pero para Income)
enum CollectionMethod { efectivo, transferencia, debito, credito, cheque, otro }

// Actualizado: Item de Ingreso (Income Item)
class IncomeItem {
  IncomeItem({
    this.concepto = '',
    this.vrUnit = 0,
    this.cantidad = 1,
    this.gravaIVA = true, // Nuevo: Si el ingreso aplica IVA
  });
  String concepto;
  double vrUnit;
  int cantidad;
  bool gravaIVA;
  double get total => (vrUnit * cantidad).toDouble();
}

// Nuevo: Desglose de Recaudo (Collection Split)
class CollectionSplit {
  CollectionSplit({
    this.method = CollectionMethod.transferencia,
    this.monto = 0,
    this.banco,
    this.accountLast4,
    this.referencia,
    this.nota,
  });
  CollectionMethod method;
  double monto;
  String? banco;
  String? accountLast4;
  String? referencia;
  String? nota;
}

// Nuevo: Detalles Específicos del Arriendo
class RentalDetails {
  RentalDetails({
    this.rentalTimeType = RentalTimeType.dia,
    this.timeStart,
    this.timeEnd,
    this.origin,
    this.destination,
  });
  // Para arriendos por tiempo
  RentalTimeType rentalTimeType;
  DateTime? timeStart; // Para "Rango" o el inicio de Día/Semana/Mes/Año
  DateTime? timeEnd; // Para "Rango"

  // Para arriendos por trayecto
  String? origin;
  String? destination;
}

// ------------------------------ CONTROLLER -----------------------------------
// Actualizado: Nombre del Controller
class IncomeFormController extends GetxController {
  // Identificación
  final fecha = DateTime.now().obs;
  final consecutivo = 'ING-${DateTime.now().year}-00001'.obs;
  final assetType = AssetType.vehiculo.obs; // Tipo de activo arrendado
  final centroCosto = ''.obs; // Centro de Ingreso
  final incomeType = IncomeType.arriendoTiempo.obs; // Actualizado: revenueType -> incomeType

  // Cliente
  final cliente = ''.obs;
  final nit = ''.obs;
  final direccion = ''.obs;
  final contacto = ''.obs; // Nuevo: Persona de contacto del cliente

  // Detalles de Arriendo (Aplica solo para arriendoTiempo/Trayecto)
  final rentalDetails = RentalDetails().obs;

  // Ítems de Ingreso
  // Actualizado: RevenueItem -> IncomeItem
  final items = <IncomeItem>[IncomeItem()].obs;
  void addItem() {
    items.add(IncomeItem());
    update();
  }

  void removeItem(int index) {
    if (items.length > 1) items.removeAt(index);
    update();
  }

  double get totalItems =>
      items.fold<double>(0, (s, e) => s + (e.total.isFinite ? e.total : 0));

  double get totalIVA => items.fold<double>(
      0, (s, e) => s + (e.gravaIVA ? e.total * 0.19 : 0)); // Suponemos 19%
  
  // Actualizado: totalRevenue -> totalIncome
  double get totalIncome => totalItems + totalIVA;

  // Recaudos
  final recaudos = <CollectionSplit>[CollectionSplit()].obs;
  void addRecaudo() {
    recaudos.add(CollectionSplit());
    update();
  }

  void removeRecaudo(int index) {
    if (recaudos.length > 1) recaudos.removeAt(index);
    update();
  }

  double get totalRecaudos => recaudos.fold<double>(
      0, (s, p) => s + (p.monto.isFinite ? p.monto : 0));

  // Actualizado: totalRevenue -> totalIncome
  double get diferencia => (totalIncome - totalRecaudos);
  final marcarComoCxC = false.obs; // Nuevo: Cuenta por Cobrar (CxC)

  String? validate() {
    if (cliente.value.trim().isEmpty) return 'Falta el nombre del cliente.';
    if (centroCosto.value.trim().isEmpty) return 'Falta el centro de ingreso.';
    if (items.any((e) => e.concepto.trim().isEmpty))
      return 'Hay ítems sin concepto.';
    if (items.any((e) => e.vrUnit <= 0 || e.cantidad <= 0))
      return 'Ítems con valores/cantidades inválidos.';
    // Actualizado: totalRevenue -> totalIncome
    if (totalIncome <= 0)
      return 'El total del ingreso (incl. IVA) debe ser mayor a 0.';
    if (diferencia != 0 && !marcarComoCxC.value) {
      return 'El total de recaudos no coincide. Marca diferencia como CxC o ajusta montos.';
    }
    for (final p in recaudos) {
      if ((p.method == CollectionMethod.transferencia ||
              p.method == CollectionMethod.debito ||
              p.method == CollectionMethod.credito) &&
          (p.banco == null || p.banco!.trim().isEmpty)) {
        return 'Falta banco en un recaudo no en efectivo.';
      }
    }
    // Validación específica para arriendos por rango
    // Actualizado: revenueType -> incomeType
    if (incomeType.value == IncomeType.arriendoTiempo &&
        rentalDetails.value.rentalTimeType == RentalTimeType.rango &&
        (rentalDetails.value.timeStart == null ||
            rentalDetails.value.timeEnd == null ||
            rentalDetails.value.timeStart!
                .isAfter(rentalDetails.value.timeEnd!))) {
      return 'Rango de tiempo de arriendo inválido.';
    }
    // Validación específica para arriendos por trayecto
    // Actualizado: revenueType -> incomeType
    if (incomeType.value == IncomeType.arriendoTrayecto &&
        (rentalDetails.value.origin == null ||
            rentalDetails.value.origin!.trim().isEmpty ||
            rentalDetails.value.destination == null ||
            rentalDetails.value.destination!.trim().isEmpty)) {
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
        backgroundColor: const Color(0xFFEF4444), // Rojo
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    Get.snackbar(
      '✓ Éxito',
      'Ingreso guardado correctamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981), // Verde
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}

// --------------------------------- PAGE --------------------------------------
// Actualizado: Nombre de la Clase
class IncomeFormPage extends StatelessWidget {
  const IncomeFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Actualizado: RevenueFormController -> IncomeFormController
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
                color: Colors.black.withOpacity(0.05),
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
          // Fondo gradiente
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF10B981).withOpacity(0.1), // Verde tenue
                  const Color(0xFF059669).withOpacity(0.1), // Verde más oscuro
                ],
              ),
            ),
          ),
          // Contenido
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
                      // 1. Identificación y Tipo de Ingreso
                      _ModernSection(
                        title: '📋 Consecutivo & Tipo',
                        headerExtra: Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF10B981), // Verde
                                    Color(0xFF059669)
                                  ], // Verde oscuro
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.3),
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
                            )),
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
                            // Actualizado: _ModernSelectRevenueType -> _ModernSelectIncomeType
                            _ModernSelectIncomeType(c: c),
                            const SizedBox(height: 16),
                            _ModernCentroCostoField(c: c),
                            // Actualizado: revenueType -> incomeType y RevenueType -> IncomeType
                            Obx(() => (c.incomeType.value ==
                                        IncomeType.arriendoTiempo ||
                                    c.incomeType.value ==
                                        IncomeType.arriendoTrayecto)
                                ? Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      _RentalSpecificFields(c: c),
                                    ],
                                  )
                                : const SizedBox.shrink()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Detalle de Ingreso y Totales
                      // Actualizado: Título
                      _ModernSection(
                        title: '💰 Valor Recibido', 
                        trailing: Obx(() {
                          final touch = c.items.length;
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)], // Verde
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981)
                                      .withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            // Actualizado: c.totalRevenue -> c.totalIncome
                            child: Text(
                              _money.format(c.totalIncome),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          );
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Detalle del Ingreso'),
                            const SizedBox(height: 16),
                            Obx(() {
                              final touch = c.items.length;
                              return Column(
                                children: [
                                  // Actualizado: _ModernRevenueItemCard -> _ModernIncomeItemCard
                                  for (int i = 0; i < c.items.length; i++)
                                    _ModernIncomeItemCard(index: i, c: c),
                                ],
                              );
                            }),
                            const SizedBox(height: 12),
                            _ModernAddButton(
                              label: 'Agregar Ítem de Ingreso',
                              icon: Icons.add_circle_outline,
                              onPressed: c.addItem,
                            ),
                            const SizedBox(height: 16),
                            // Actualizado: _RevenueSummary -> _IncomeSummary
                            _IncomeSummary(c: c),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Cliente (Receptor del servicio/bien)
                      _ModernSection(
                        title: '👤 Cliente',
                        child: Column(
                          children: [
                            _ModernTextField(
                              label: 'Persona / Organización (Cliente)',
                              hint: 'Ej. Constructora XZY',
                              value: c.cliente,
                              icon: Icons.business_outlined,
                            ),
                            const SizedBox(height: 16),
                            _ModernTextField(
                              label: 'NIT / CC',
                              hint: '123456789-0',
                              value: c.nit,
                              icon: Icons.badge_outlined,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            _ModernTextField(
                              label: 'Dirección',
                              hint: 'Calle 123 #45-67',
                              value: c.direccion,
                              icon: Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 16),
                            _ModernTextField(
                              label: 'Contacto',
                              hint: 'Ej. Juan Pérez (Gerente)',
                              value: c.contacto,
                              icon: Icons.person_outline,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 4. Recaudo (Métodos de Pago Recibidos)
                      _ModernSection(
                        title: '💳 Métodos de Recaudo',
                        trailing: Obx(() {
                          final touch = c.recaudos.length;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF059669)
                                ], // Verde
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
                          );
                        }),
                        child: Column(
                          children: [
                            Obx(() {
                              final touch = c.recaudos.length;
                              return Column(
                                children: [
                                  for (int i = 0; i < c.recaudos.length; i++)
                                    _ModernRecaudoCard(index: i, c: c),
                                ],
                              );
                            }),
                            const SizedBox(height: 12),
                            _ModernAddButton(
                              label: 'Agregar Recaudo',
                              icon: Icons.account_balance_wallet_outlined,
                              onPressed: c.addRecaudo,
                            ),
                            const SizedBox(height: 16),
                            Obx(() {
                              final diff = c.diferencia;
                              if (diff.abs() < 0.01) {
                                return const _BalanceCard(
                                  label: '✓ Balanceado',
                                  amount: 0,
                                  isBalanced: true,
                                );
                              }
                              return Column(
                                children: [
                                  _BalanceCard(
                                    label:
                                        diff > 0 ? 'Por Cobrar (CxC)' : 'Excedente (Error)',
                                    amount: diff.abs(),
                                    isBalanced: false,
                                    isRevenue: true, // Color para Ingreso (Azul)
                                  ),
                                  const SizedBox(height: 12),
                                  _ModernCheckbox(
                                    label: 'Marcar diferencia como CxC',
                                    value: c.marcarComoCxC,
                                    // Cambiamos el color para ser más acorde al ingreso
                                    activeColor: const Color(0xFF10B981),
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
          // Botón de Guardar
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _ModernSubmitButton(
              onPressed: c.save,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}

// ========================= MODERN WIDGETS ADAPTADOS ====================================

// Adaptación de _ModernSection
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
    // Código de _ModernSection del formulario de gastos (se mantiene igual)
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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

// Reutilizamos _ModernTextField
class _ModernTextField extends StatelessWidget {
  const _ModernTextField({
    required this.label,
    required this.hint,
    required this.value,
    required this.icon,
    this.keyboardType,
    this.initialValue,
  });

  final String label;
  final String hint;
  final RxString value;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    // Código de _ModernTextField del formulario de gastos (se mantiene igual)
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
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: initialValue ?? value.value,
                  keyboardType: keyboardType,
                  onChanged: (v) => value.value = v,
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Reutilizamos _ModernFechaField
// Actualizado: RevenueFormController -> IncomeFormController
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
        Obx(() => GestureDetector(
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
                          primary: Color(0xFF10B981), // Color de Ingreso
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
            )),
      ],
    );
  }
}

// Reutilizamos _ModernSelectAssetType
// Actualizado: RevenueFormController -> IncomeFormController
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
        Obx(() => Container(
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
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color(0xFF9CA3AF)),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                  items: AssetType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(_assetTypeLabel(t)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) c.assetType.value = v;
                  },
                ),
              ),
            )),
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

// Actualizado: Selector de Tipo de Ingreso
class _ModernSelectIncomeType extends StatelessWidget {
  const _ModernSelectIncomeType({required this.c});
  final IncomeFormController c; // Actualizado: RevenueFormController -> IncomeFormController

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
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonHideUnderline(
                // Actualizado: RevenueType -> IncomeType
                child: DropdownButton2<IncomeType>(
                  value: c.incomeType.value, // Actualizado: revenueType -> incomeType
                  isExpanded: true,
                  iconStyleData: const IconStyleData(
                    icon:
                        Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                  // Actualizado: RevenueType -> IncomeType
                  items: IncomeType.values
                      .map((t) => DropdownMenuItem<IncomeType>(
                            value: t,
                            child: Text(_incomeTypeLabel(t)), // Actualizado: _revenueTypeLabel -> _incomeTypeLabel
                          ))
                      .toList(),
                  onChanged: (v) {
                    // Actualizado: incomeType -> incomeType
                    if (v != null) c.incomeType.value = v; 
                  },
                ),
              ),
            )),
      ],
    );
  }
  
  // Actualizado: _revenueTypeLabel -> _incomeTypeLabel
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

// Reutilizamos _ModernCentroCostoField
// Actualizado: RevenueFormController -> IncomeFormController
class _ModernCentroCostoField extends StatelessWidget {
  const _ModernCentroCostoField({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    return _ModernTextField(
      label: 'Centro de Ingreso/Costo',
      hint: 'Ej. Proyecto Norte / Obra 5',
      value: c.centroCosto,
      icon: Icons.account_tree_outlined,
    );
  }
}

// Reutilizamos _ModernAddButton
class _ModernAddButton extends StatelessWidget {
  const _ModernAddButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF10B981),
        side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Nuevo: Campos Específicos para Arriendo
// Actualizado: RevenueFormController -> IncomeFormController
class _RentalSpecificFields extends StatelessWidget {
  const _RentalSpecificFields({required this.c});
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    // Actualizado: revenueType -> incomeType, RevenueType -> IncomeType
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
          // Selector de modalidad
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<RentalTimeType>(
                    value: c.rentalDetails.value.rentalTimeType,
                    isExpanded: true,
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down,
                          color: Color(0xFF9CA3AF)),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                    items: RentalTimeType.values
                        .map((t) => DropdownMenuItem<RentalTimeType>(
                              value: t,
                              child: Text(_rentalTimeLabel(t)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        c.rentalDetails.update((val) {
                          val!.rentalTimeType = v;
                          // Reseteamos las fechas si cambiamos de 'rango'
                          if (v != RentalTimeType.rango) {
                            val.timeStart = null;
                            val.timeEnd = null;
                          }
                        });
                      }
                    },
                  ),
                ),
              )),
          // Campos de fecha si es "Rango"
          Obx(() => c.rentalDetails.value.rentalTimeType == RentalTimeType.rango
              ? Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: _ModernDateField(
                          label: 'Fecha Inicio',
                          initialDate: c.rentalDetails.value.timeStart,
                          onDateSelected: (date) {
                            c.rentalDetails.update((val) {
                              val!.timeStart = date;
                            });
                          },
                          color: const Color(0xFF10B981),
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _ModernDateField(
                          label: 'Fecha Fin',
                          initialDate: c.rentalDetails.value.timeEnd,
                          onDateSelected: (date) {
                            c.rentalDetails.update((val) {
                              val!.timeEnd = date;
                            });
                          },
                          color: const Color(0xFF10B981),
                        )),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink()),
        ],
      );
    // Actualizado: RevenueType -> IncomeType
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
          _ModernTextField(
            label: 'Origen',
            hint: 'Ej. Bodega Central',
            value: c.rentalDetails.value.origin != null
                ? c.rentalDetails.value.origin!.obs
                : ''.obs,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          _ModernTextField(
            label: 'Destino',
            hint: 'Ej. Obra El Nogal',
            value: c.rentalDetails.value.destination != null
                ? c.rentalDetails.value.destination!.obs
                : ''.obs,
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

// Widget de fecha genérico (reutilizado)
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
    // Implementación del DateField (se mantiene igual, solo usa la función de callback)
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
                    colorScheme: ColorScheme.light(
                      primary: color,
                    ),
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

// Actualizado: Card para cada ítem de Ingreso
class _ModernIncomeItemCard extends StatelessWidget {
  const _ModernIncomeItemCard({required this.index, required this.c});
  final int index;
  final IncomeFormController c; // Actualizado: RevenueFormController -> IncomeFormController

  @override
  Widget build(BuildContext context) {
    // Reemplazamos c.items.elementAt(index) para evitar la copia y permitir la modificación
    final item = c.items[index]; 

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ítem ${index + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (c.items.length > 1)
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFEF4444), size: 20),
                  onPressed: () => c.removeItem(index),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Campo Concepto
          TextFormField(
            initialValue: item.concepto,
            onChanged: (v) {
              item.concepto = v;
              c.update(); // Notificar cambio para forzar la actualización del total
            },
            decoration: InputDecoration(
              labelText: 'Concepto (Ej. Arriendo Retroexcavadora)',
              labelStyle: const TextStyle(fontSize: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Campo Valor Unitario
              Expanded(
                child: TextFormField(
                  initialValue: item.vrUnit > 0 ? item.vrUnit.toString() : '',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onChanged: (v) {
                    item.vrUnit = double.tryParse(v) ?? 0;
                    c.update();
                  },
                  decoration: InputDecoration(
                    labelText: 'Valor Unitario (\$)',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Campo Cantidad
              Expanded(
                child: TextFormField(
                  initialValue: item.cantidad.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (v) {
                    item.cantidad = int.tryParse(v) ?? 1;
                    c.update();
                  },
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Checkbox y Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: c.items[index].gravaIVA,
                        onChanged: (v) {
                          c.items[index].gravaIVA = v ?? false;
                          c.update();
                        },
                        activeColor: const Color(0xFF10B981),
                      )),
                  const Text('Aplica IVA (19%)',
                      style: TextStyle(fontSize: 14, color: Color(0xFF374151))),
                ],
              ),
              Text(
                _money.format(item.total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF059669),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// Actualizado: Resumen de Ingreso
class _IncomeSummary extends StatelessWidget {
  const _IncomeSummary({required this.c});
  final IncomeFormController c; // Actualizado: RevenueFormController -> IncomeFormController

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
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
              // Actualizado: Total Ingreso -> Valor Total
              label: 'Valor Total', 
              amount: c.totalIncome, // Actualizado: totalRevenue -> totalIncome
              isTotal: true,
            ),
          ],
        ));
  }
}

// Widget de fila de resumen
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

// Reutilizamos _ModernRecaudoCard
// Actualizado: RevenueFormController -> IncomeFormController
class _ModernRecaudoCard extends StatelessWidget {
  const _ModernRecaudoCard({required this.index, required this.c});
  final int index;
  final IncomeFormController c;

  @override
  Widget build(BuildContext context) {
    // ... Código de _ModernRecaudoCard (se mantiene igual, solo usa el nuevo controlador)
    final recaudo = c.recaudos[index];
    
    // El resto del widget de recaudo se mantiene igual usando el objeto `recaudo`
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recaudo ${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
              if (c.recaudos.length > 1)
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFEF4444), size: 20),
                  onPressed: () => c.removeRecaudo(index),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Selector de Método de Pago
          DropdownButtonHideUnderline(
            child: DropdownButton2<CollectionMethod>(
              value: recaudo.method,
              isExpanded: true,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
              items: CollectionMethod.values
                  .map((m) => DropdownMenuItem<CollectionMethod>(
                        value: m,
                        child: Text(_collectionMethodLabel(m)),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  recaudo.method = v;
                  c.update();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          // Campo Monto
          TextFormField(
            initialValue: recaudo.monto > 0 ? recaudo.monto.toString() : '',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (v) {
              recaudo.monto = double.tryParse(v) ?? 0;
              c.update(); // Notificar cambio para actualizar el totalRecaudos y la diferencia
            },
            decoration: InputDecoration(
              labelText: 'Monto Recibido (\$)',
              prefixText: '\$',
              labelStyle: const TextStyle(fontSize: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
          ),
          // Campos Condicionales
          if (recaudo.method != CollectionMethod.efectivo &&
              recaudo.method != CollectionMethod.otro)
            Column(
              children: [
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: recaudo.banco,
                  onChanged: (v) => recaudo.banco = v,
                  decoration: InputDecoration(
                    labelText: 'Banco',
                    hintText: 'Ej. Bancolombia',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: recaudo.referencia,
                  onChanged: (v) => recaudo.referencia = v,
                  decoration: InputDecoration(
                    labelText: 'Referencia / No. Transacción',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                  ),
                ),
              ],
            ),
          if (recaudo.method == CollectionMethod.otro)
            Column(
              children: [
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: recaudo.nota,
                  onChanged: (v) => recaudo.nota = v,
                  decoration: InputDecoration(
                    labelText: 'Nota del Otro Recaudo',
                    hintText: 'Ej. Criptomoneda, Activo canjeado',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                  ),
                ),
              ],
            ),
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

// Reutilizamos _BalanceCard
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.label,
    required this.amount,
    required this.isBalanced,
    this.isRevenue = false, // Ahora usado como color de Ingreso (Verde)
  });

  final String label;
  final double amount;
  final bool isBalanced;
  final bool isRevenue; // Indica que es Ingreso (Verde)

  @override
  Widget build(BuildContext context) {
    // Código de _BalanceCard (se mantiene igual, adaptando el color al Ingreso)
    final color = isBalanced
        ? const Color(0xFF10B981) // Verde para Balanceado
        : (isRevenue
            ? const Color(0xFF3B82F6) // Azul para CxC (Ingreso)
            : const Color(0xFFEF4444)); // Rojo para Diferencia (Excedente)

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            _money.format(amount),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Reutilizamos _ModernCheckbox
class _ModernCheckbox extends StatelessWidget {
  const _ModernCheckbox({
    required this.label,
    required this.value,
    this.activeColor,
  });

  final String label;
  final RxBool value;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => value.toggle(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: value.value,
                  onChanged: (v) => value.value = v ?? false,
                  activeColor: activeColor,
                  checkColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                )),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Reutilizamos _ModernSubmitButton
// Actualizado: RevenueFormController -> IncomeFormController
class _ModernSubmitButton extends StatelessWidget {
  const _ModernSubmitButton({
    required this.onPressed,
    required this.color,
  });

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 10,
        shadowColor: color.withOpacity(0.3),
      ),
      child: const Text(
        'GUARDAR INGRESO',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }
}