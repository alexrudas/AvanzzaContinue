// ============================================================================
// lib/presentation/tenant/controllers/tenant_home_controller.dart
// ============================================================================

import 'package:avanzza/presentation/widgets/ai_banner/ai_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller para el Home del Arrendatario.
class TenantHomeController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  // Datos reactivos mock
  final RxList<Map<String, dynamic>> _vehiclesData =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> _realEstateData =
      <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> _equipmentData = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> _aiAlertsData =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> _myDayTasks = <Map<String, dynamic>>[].obs;

  // Mensajes IA tipados para banner (solo vehículos por ahora)
  final RxList<AIBannerMessage> _aiMessagesTenantVehicle =
      <AIBannerMessage>[].obs;

  // Getters
  List<Map<String, dynamic>> get vehiclesData => _vehiclesData;
  List<Map<String, dynamic>> get realEstateData => _realEstateData;
  Map<String, dynamic> get equipmentData => _equipmentData;
  List<Map<String, dynamic>> get aiAlertsData => _aiAlertsData;
  List<Map<String, dynamic>> get myDayTasks => _myDayTasks;
  List<AIBannerMessage> get aiMessagesTenantVehicle => _aiMessagesTenantVehicle;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
    loading.value = false;
  }

  Future<void> refreshAllData() async {
    try {
      loading.value = true;
      error.value = null;
      await Future.delayed(const Duration(milliseconds: 800));
      _loadMockData();
    } catch (e) {
      error.value = 'Error actualizando datos: $e';
    } finally {
      loading.value = false;
    }
  }

  void _loadMockData() {
    // Vehículos
    _vehiclesData.value = [
      {
        'id': 'v1',
        'placa': 'WPB584',
        'marca': 'Toyota',
        'modelo': 'Corolla',
        'anio': 2022,
        'pagoPendiente': 450000, // num para poder formatear
        'multasActivas': 2,
        'proximoDocumento': 'SOAT vence en 12 días',
        'proximoMantenimiento': '15 feb 2025',
        'ciudad': 'Barranquilla',
        'tienePicoYPlacaHoy': true,
        'descansoDia': 'martes',
        // Simulados:
        'fechaSOAT': 'en 12 días',
        'fechaLicencia': null,
        'fechaContractual': null,
        'fechaExtra': null,
        'fechaRTM': null,
        'fechaContrato': null,
      },
      {
        'id': 'v2',
        'placa': 'ABC123',
        'marca': 'Chevrolet',
        'modelo': 'Spark',
        'anio': 2021,
        'pagoPendiente': null,
        'multasActivas': 0,
        'proximoDocumento': 'Al día',
        'proximoMantenimiento': 'No programado',
        'ciudad': 'Barranquilla',
        'tienePicoYPlacaHoy': false,
        'descansoDia': 'jueves',
        'fechaSOAT': null,
        'fechaLicencia': null,
        'fechaContractual': null,
        'fechaExtra': null,
        'fechaRTM': null,
        'fechaContrato': null,
      },
    ];

    // Inmuebles
    _realEstateData.value = [
      {
        'id': 'i1',
        'direccion': 'Calle 45 #23-67, Chapinero',
        'tipo': 'Apartamento',
        'valorArriendo': 1200000,
        'vencimientoContrato': 'Vence en 45 días',
      },
    ];

    // Equipos
    _equipmentData.value = {
      'totalAsignados': 8,
      'valorPagado': 2500000,
      'diasVencimiento': '23 días (28 mar 2025)',
      'pendientesDevolver': 1,
      'danosReportados': 2,
    };

    // Alertas IA heterogéneas (legacy, no usadas por el banner nuevo)
    _aiAlertsData.value = [
      {
        'id': 'alert1',
        'type': 'licencia_conduccion',
        'title': 'Licencia de conducción por vencer',
        'subtitle': 'Tu licencia de conducción vence pronto',
        'daysToExpire': 12,
        'priority': 'high',
        'ctaLabel': 'Renovar',
      },
      {
        'id': 'alert2',
        'type': 'revision_bateria',
        'title': 'Revisión de batería recomendada',
        'subtitle': 'El vehículo WPB584 requiere revisión de batería',
        'daysToExpire': null,
        'priority': 'medium',
        'ctaLabel': 'Agendar',
      },
      {
        'id': 'alert3',
        'type': 'taller_sugerido',
        'title': 'Taller recomendado cercano',
        'subtitle': 'Taller AutoExpress - Cra 15 #45-23, Tel: 3001234567',
        'daysToExpire': null,
        'priority': 'low',
        'ctaLabel': 'Ver mapa',
      },
    ];

    // Tareas “Mi día”
    _myDayTasks.value = [
      {
        'id': 'task1',
        'title': 'Pagar arriendo del vehículo WPB584',
        'completed': false,
        'priority': 'high'
      },
      {
        'id': 'task2',
        'title': 'Revisar estado de equipos de construcción',
        'completed': false,
        'priority': 'medium'
      },
      {
        'id': 'task3',
        'title': 'Firmar renovación de contrato',
        'completed': false,
        'priority': 'high'
      },
    ];

    // Mensajes IA para vehículos (tipados y clasificados)
    _aiMessagesTenantVehicle.value = _buildVehicleAIMessages(_vehiclesData);
  }

  // Genera mensajes IA tipados por vehículo, priorizados por criticidad.
  List<AIBannerMessage> _buildVehicleAIMessages(
      List<Map<String, dynamic>> vehicles) {
    final out = <AIBannerMessage>[];

    for (final v in vehicles) {
      final placa = (v['placa'] ?? '').toString();
      final ciudad = (v['ciudad'] ?? 'tu ciudad').toString();
      final multas = (v['multasActivas'] ?? 0) as int;
      final soat = v['fechaSOAT'] as String?;
      final licencia = v['fechaLicencia'] as String?;
      final contractual = v['fechaContractual'] as String?;
      final extra = v['fechaExtra'] as String?;
      final rtm = v['fechaRTM'] as String?;
      final contrato = v['fechaContrato'] as String?;
      final picoHoy = (v['tienePicoYPlacaHoy'] ?? false) as bool;
      final descansoDia = (v['descansoDia'] ?? '').toString();

      // Multas
      if (multas > 0) {
        out.add(AIBannerMessage(
            type: AIMessageType.warning,
            icon: Icons.gavel_rounded,
            title: 'Tienes multas activas por pagar.',
            subtitle: 'Evita intereses.'));
      } else {
        out.add(AIBannerMessage(
          type: AIMessageType.info,
          icon: Icons.verified_rounded,
          title: 'Sin multas registradas. Excelente historial de conducción.',
        ));
      }

      // Pico y Placa / circulación
      if (picoHoy) {
        out.add(AIBannerMessage(
          type: AIMessageType.info,
          icon: Icons.rule_rounded,
          title:
              'Hoy tu placa $placa tiene restricción de circulación en $ciudad.',
        ));
      } else {
        out.add(AIBannerMessage(
          type: AIMessageType.success,
          icon: Icons.directions_car_filled_rounded,
          title: 'Hoy puedes circular sin restricción en $ciudad.',
        ));
      }

      // Descanso operativo
      if (descansoDia.isNotEmpty) {
        out.add(AIBannerMessage(
          type: AIMessageType.info,
          icon: Icons.event_busy_rounded,
          title:
              'Día de descanso asignado: $descansoDia. Ideal para mantenimiento preventivo.',
        ));
      }

      // Licencia
      if (licencia != null && licencia.isNotEmpty) {
        out.add(AIBannerMessage(
          type: AIMessageType.warning,
          icon: Icons.badge_rounded,
          title: 'Licencia próxima a vencer ($licencia). Renueva a tiempo.',
        ));
      }

      // SOAT
      if (soat != null && soat.isNotEmpty) {
        out.add(AIBannerMessage(
          type: AIMessageType.warning,
          icon: Icons.receipt_long_rounded,
          title: 'SOAT de $placa vence $soat.',
          subtitle: 'Dic. 01/2025',
        ));
      }

      // Seguro Contractual
      if (contractual != null && contractual.isNotEmpty) {
        out.add(AIBannerMessage(
          type: AIMessageType.warning,
          icon: Icons.policy_rounded,
          title: 'Seguro contractual próximo a vencer.',
          subtitle: 'Dic. 01/2025',
        ));
      }

      // Seguro Extracontractual
      if (extra != null && extra.isNotEmpty) {
        out.add(AIBannerMessage(
          type: AIMessageType.warning,
          icon: Icons.health_and_safety_rounded,
          title: 'Seguro extracontractual próximo a vencer ($extra).',
          subtitle: 'Dic. 01/2025',
        ));
      }

      // RTM
      if (rtm != null && rtm.isNotEmpty) {
        out.add(AIBannerMessage(
          type: AIMessageType.warning,
          icon: Icons.build_circle_rounded,
          title: 'RTM próxima a vencer ($rtm).',
          subtitle: 'Agenda tu inspección.',
        ));
      }

      // Contrato de arriendo
      if (contrato != null && contrato.isNotEmpty) {
        out.add(AIBannerMessage(
          type: AIMessageType.warning,
          icon: Icons.description_rounded,
          title: 'Contrato de arriendo próximo a vencer.',
          subtitle: '($contrato).',
        ));
      }
    }

    // Priorización: critical > warning > info > success
    int rank(AIMessageType t) {
      switch (t) {
        case AIMessageType.critical:
          return 0;
        case AIMessageType.warning:
          return 1;
        case AIMessageType.info:
          return 2;
        case AIMessageType.success:
          return 3;
      }
    }

    out.sort((a, b) => rank(a.type).compareTo(rank(b.type)));
    return out;
  }
}
