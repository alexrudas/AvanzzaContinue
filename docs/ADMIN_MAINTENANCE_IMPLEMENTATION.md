# Implementación AdminMaintenancePage - Guía Completa

**Fecha**: 2025-10-16
**Objetivo**: Vista móvil "Mantenimientos – Rol Administrador" con Material 3 + GetX

---

## 📁 Estructura de Archivos

```
lib/presentation/
├── controllers/admin/maintenance/
│   ├── admin_maintenance_controller.dart (actualizado)
│   ├── maintenance_stats_controller.dart (nuevo)
│   ├── alert_recommender_controller.dart (nuevo)
│   ├── review_events_controller.dart (nuevo)
│   └── types/
│       ├── kpi_filter.dart (✅ creado)
│       └── maintenance_stats.dart (nuevo)
│
├── pages/admin/maintenance/
│   └── admin_maintenance_page.dart (reescrito completo)
│
└── widgets/maintenance/
    ├── smart_banner_widget.dart (nuevo)
    ├── maintenance_kpi_row.dart (nuevo)
    ├── review_events_strip.dart (nuevo)
    ├── maintenance_operational_panel.dart (nuevo)
    ├── fab_actions_sheet.dart (nuevo)
    └── maintenance_card.dart (nuevo - item de lista)
```

---

## 📦 1. Modelo de Datos - MaintenanceStats

**Archivo**: `lib/presentation/controllers/admin/maintenance/types/maintenance_stats.dart`

```dart
import 'package:flutter/foundation.dart';

/// Modelo inmutable para estadísticas de mantenimientos
@immutable
class MaintenanceStats {
  final int totalIncidencias;
  final int totalEnProceso;
  final int totalFinalizados;
  final int totalActivos; // Total de activos gestionados
  final DateTime lastUpdate;

  const MaintenanceStats({
    required this.totalIncidencias,
    required this.totalEnProceso,
    required this.totalFinalizados,
    required this.totalActivos,
    required this.lastUpdate,
  });

  /// Constructor para estado vacío/inicial
  factory MaintenanceStats.empty() {
    return MaintenanceStats(
      totalIncidencias: 0,
      totalEnProceso: 0,
      totalFinalizados: 0,
      totalActivos: 0,
      lastUpdate: DateTime.now(),
    );
  }

  /// Crea copia con campos actualizados
  MaintenanceStats copyWith({
    int? totalIncidencias,
    int? totalEnProceso,
    int? totalFinalizados,
    int? totalActivos,
    DateTime? lastUpdate,
  }) {
    return MaintenanceStats(
      totalIncidencias: totalIncidencias ?? this.totalIncidencias,
      totalEnProceso: totalEnProceso ?? this.totalEnProceso,
      totalFinalizados: totalFinalizados ?? this.totalFinalizados,
      totalActivos: totalActivos ?? this.totalActivos,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  /// Formatea la hora de última actualización
  String get formattedUpdateTime {
    final hour = lastUpdate.hour % 12 == 0 ? 12 : lastUpdate.hour % 12;
    final minute = lastUpdate.minute.toString().padLeft(2, '0');
    final period = lastUpdate.hour < 12 ? 'a.m.' : 'p.m.';
    return '$hour:$minute $period';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaintenanceStats &&
          runtimeType == other.runtimeType &&
          totalIncidencias == other.totalIncidencias &&
          totalEnProceso == other.totalEnProceso &&
          totalFinalizados == other.totalFinalizados &&
          totalActivos == other.totalActivos;

  @override
  int get hashCode => Object.hash(
        totalIncidencias,
        totalEnProceso,
        totalFinalizados,
        totalActivos,
      );
}
```

---

## 🔧 2. Interface de Repositorio

**Archivo**: `lib/presentation/controllers/admin/maintenance/types/i_maintenance_stats_repo.dart`

```dart
import 'maintenance_stats.dart';

/// Interface para repositorio de estadísticas de mantenimientos
///
/// Define el contrato para obtener métricas agregadas.
/// Permite testing con mocks y desacopla UI de lógica de datos.
abstract class IMaintenanceStatsRepo {
  /// Obtiene estadísticas actualizadas para una organización
  ///
  /// [orgId] ID de la organización
  /// Retorna [MaintenanceStats] con datos actuales
  Future<MaintenanceStats> getStats(String orgId);

  /// Obtiene estadísticas filtradas por tipo de activo
  ///
  /// [orgId] ID de la organización
  /// [assetType] Tipo de activo (vehiculos, inmuebles, etc.)
  Future<MaintenanceStats> getStatsByAssetType(
    String orgId,
    String assetType,
  );

  /// Refresca cache de estadísticas
  Future<void> refreshCache(String orgId);
}
```

---

## 🎮 3. MaintenanceStatsController (Mejorado)

**Archivo**: `lib/presentation/controllers/admin/maintenance/maintenance_stats_controller.dart`

```dart
import 'package:get/get.dart';
import 'types/kpi_filter.dart';
import 'types/maintenance_stats.dart';
import 'types/i_maintenance_stats_repo.dart';

/// Controlador para estadísticas y KPIs de mantenimientos
///
/// Gestiona:
/// - Carga de métricas desde repositorio
/// - Estados de loading/error
/// - Filtros activos en KPIs
/// - Refresh manual
class MaintenanceStatsController extends GetxController {
  final IMaintenanceStatsRepo _repo;
  final String orgId;

  MaintenanceStatsController({
    required IMaintenanceStatsRepo repo,
    required this.orgId,
  }) : _repo = repo;

  // Estados observables
  final Rx<MaintenanceStats> stats = MaintenanceStats.empty().obs;
  final isLoading = false.obs;
  final RxnString error = RxnString();

  // Filtro activo
  final Rxn<KpiFilter> activeFilter = Rxn<KpiFilter>();

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  /// Carga estadísticas desde el repositorio
  Future<void> loadStats() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await _repo.getStats(orgId);
      stats.value = data;
    } catch (e) {
      error.value = 'Error cargando estadísticas: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresca estadísticas manualmente
  Future<void> refresh() async {
    await _repo.refreshCache(orgId);
    await loadStats();
  }

  /// Alterna filtro activo al tocar un KPI card
  void toggleFilter(KpiFilter filter) {
    if (activeFilter.value == filter) {
      activeFilter.value = null; // Desactiva si ya estaba activo
    } else {
      activeFilter.value = filter;
    }
  }

  /// Obtiene el count para un tipo de KPI
  int getCountFor(KpiFilter filter) {
    switch (filter) {
      case KpiFilter.incidencias:
        return stats.value.totalIncidencias;
      case KpiFilter.enProceso:
        return stats.value.totalEnProceso;
      case KpiFilter.finalizados:
        return stats.value.totalFinalizados;
    }
  }
}

/// Mock implementation para testing
class MockMaintenanceStatsRepo implements IMaintenanceStatsRepo {
  @override
  Future<MaintenanceStats> getStats(String orgId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return MaintenanceStats(
      totalIncidencias: 8,
      totalEnProceso: 12,
      totalFinalizados: 45,
      totalActivos: 156,
      lastUpdate: DateTime.now(),
    );
  }

  @override
  Future<MaintenanceStats> getStatsByAssetType(
    String orgId,
    String assetType,
  ) async {
    return getStats(orgId);
  }

  @override
  Future<void> refreshCache(String orgId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
```

---

## 🔔 4. AlertRecommenderController

**Archivo**: `lib/presentation/controllers/admin/maintenance/alert_recommender_controller.dart`

```dart
import 'package:get/get.dart';

/// Modelo para una alerta/recomendación contextual
class SmartAlert {
  final String id;
  final String title;
  final String description;
  final String? providerName;
  final String? providerLogo; // URL o asset path
  final String ctaText;
  final VoidCallback? onTap;
  final AlertType type;

  const SmartAlert({
    required this.id,
    required this.title,
    required this.description,
    this.providerName,
    this.providerLogo,
    this.ctaText = 'Ver más',
    this.onTap,
    this.type = AlertType.info,
  });
}

enum AlertType {
  critical, // Rojo - Requiere acción inmediata
  warning,  // Naranja - Atención requerida
  info,     // Azul - Informativo
  success,  // Verde - Positivo
}

/// Controlador para banner inteligente contextual
///
/// Gestiona alertas dinámicas basadas en:
/// - Kilometraje próximo a mantenimiento
/// - Vencimientos de documentos
/// - Recomendaciones de proveedores
class AlertRecommenderController extends GetxController {
  final Rxn<SmartAlert> currentAlert = Rxn<SmartAlert>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentAlert();
  }

  Future<void> _loadCurrentAlert() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock: Simula una alerta de proveedor aliado
    currentAlert.value = SmartAlert(
      id: 'alert_001',
      title: 'Mantenimiento preventivo próximo',
      description: 'Te faltan 1.200 km para cambio de llantas 185/65 R15',
      providerName: 'Goodyear',
      providerLogo: null, // En producción: URL del logo
      ctaText: 'Cotizar ahora',
      type: AlertType.warning,
      onTap: () {
        Get.snackbar(
          'Cotización',
          'Abriendo cotización con Goodyear...',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );

    isLoading.value = false;
  }

  /// Descarta alerta actual (el usuario la cerró)
  void dismissAlert() {
    currentAlert.value = null;
  }

  /// Refresca alertas
  Future<void> refresh() async {
    await _loadCurrentAlert();
  }
}
```

---

## 📋 5. ReviewEventsController

**Archivo**: `lib/presentation/controllers/admin/maintenance/review_events_controller.dart`

```dart
import 'package:get/get.dart';

/// Modelo para un evento pendiente de revisión
class ReviewEvent {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final DateTime timestamp;
  final ReviewEventType type;
  final bool isUrgent;

  const ReviewEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.timestamp,
    required this.type,
    this.isUrgent = false,
  });
}

enum ReviewEventType {
  documentExpiry,     // Documento por vencer
  maintenanceOverdue, // Mantenimiento atrasado
  incidentPending,    // Incidencia sin asignar
  approvalRequired,   // Requiere aprobación
}

/// Controlador para eventos/alertas que requieren revisión
///
/// Muestra notificaciones y acciones pendientes del administrador
class ReviewEventsController extends GetxController {
  final events = <ReviewEvent>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock: Simula 3 eventos
    events.value = [
      ReviewEvent(
        id: 'evt_001',
        title: 'SOAT próximo a vencer',
        description: 'Vehículo ABC-123 - Vence en 5 días',
        icon: Icons.description_outlined,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: ReviewEventType.documentExpiry,
        isUrgent: true,
      ),
      ReviewEvent(
        id: 'evt_002',
        title: 'Incidencia sin asignar',
        description: 'Cambio de aceite - Sin proveedor asignado',
        icon: Icons.assignment_late_outlined,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: ReviewEventType.incidentPending,
      ),
      ReviewEvent(
        id: 'evt_003',
        title: 'Aprobación de cotización',
        description: 'Mantenimiento correctivo \$2,500,000',
        icon: Icons.check_circle_outline,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: ReviewEventType.approvalRequired,
      ),
    ];

    isLoading.value = false;
  }

  /// Marca evento como revisado
  void markAsReviewed(String eventId) {
    events.removeWhere((e) => e.id == eventId);
  }

  /// Abre vista detallada de un evento
  void openEventDetail(ReviewEvent event) {
    Get.snackbar(
      'Evento',
      event.title,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
```

---

## 🎨 6. SmartBannerWidget

**Archivo**: `lib/presentation/widgets/maintenance/smart_banner_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin/maintenance/alert_recommender_controller.dart';

/// Banner inteligente contextual
///
/// Muestra alertas y recomendaciones personalizadas según el estado
/// de los activos y mantenimientos del usuario.
class SmartBannerWidget extends GetView<AlertRecommenderController> {
  const SmartBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final alert = controller.currentAlert.value;

      if (controller.isLoading.value) {
        return _buildLoadingSkeleton();
      }

      if (alert == null) {
        return const SizedBox.shrink(); // No mostrar nada
      }

      return _buildAlertCard(context, alert);
    });
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, SmartAlert alert) {
    final theme = Theme.of(context);
    final bgColor = _getBackgroundColor(alert.type);
    final textColor = _getTextColor(alert.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo del proveedor (si existe)
          if (alert.providerName != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  alert.providerName![0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: bgColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (alert.providerName != null)
                  Text(
                    alert.providerName!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // CTA Button
          const SizedBox(width: 8),
          TextButton(
            onPressed: alert.onTap,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              alert.ctaText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Botón cerrar
          IconButton(
            icon: Icon(Icons.close, color: textColor, size: 18),
            onPressed: controller.dismissAlert,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(AlertType type) {
    switch (type) {
      case AlertType.critical:
        return const Color(0xFFEF4444);
      case AlertType.warning:
        return const Color(0xFFF97316);
      case AlertType.info:
        return const Color(0xFF2563EB);
      case AlertType.success:
        return const Color(0xFF10B981);
    }
  }

  Color _getTextColor(AlertType type) {
    return Colors.white;
  }
}
```

---

## 📊 7. MaintenanceKpiRow

**Archivo**: `lib/presentation/widgets/maintenance/maintenance_kpi_row.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin/maintenance/maintenance_stats_controller.dart';
import '../../../controllers/admin/maintenance/types/kpi_filter.dart';

/// Fila de KPI cards para mantenimientos
///
/// Muestra 3 tarjetas con métricas principales:
/// - Incidencias (rojo)
/// - En proceso (azul)
/// - Finalizados (verde)
class MaintenanceKpiRow extends GetView<MaintenanceStatsController> {
  const MaintenanceKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingSkeleton();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: KpiFilter.valuesUi.map((filter) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildKpiCard(context, filter),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildKpiCard(BuildContext context, KpiFilter filter) {
    final theme = Theme.of(context);
    final isActive = controller.activeFilter.value == filter;
    final count = controller.getCountFor(filter);

    return GestureDetector(
      onTap: () => controller.toggleFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? filter.color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? filter.color : Colors.grey.shade300,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: filter.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono
            Icon(
              filter.icon,
              color: isActive ? Colors.white : filter.color,
              size: 28,
            ),
            const SizedBox(height: 8),

            // Count
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),

            // Label
            Text(
              filter.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white.withOpacity(0.9)
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

Debido al límite de tokens, necesito dividir la respuesta. ¿Quieres que continúe con los widgets restantes (ReviewEventsStrip, MaintenanceOperationalPanel, FabActionsSheet) y la integración final en AdminMaintenancePage?