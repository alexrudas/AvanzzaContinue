// ============================================================================
// lib/core/campaign/resolver/campaign_resolver.dart
// CAMPAIGN RESOLVER — Motor de selección de campañas basado en datos reales
//
// QUÉ HACE:
// - Evalúa todos los activos vehiculares del org en busca de SOAT urgente.
// - Selecciona el activo con mayor prioridad (uno solo por sesión).
// - Aplica SoatFrequencyGuard para controlar cooldown entre sesiones.
// - Construye y retorna un Campaign dinámico con mensajes contextuales.
//
// QUÉ NO HACE:
// - No gestiona la regla 1/sesión (la maneja CampaignOrchestrator).
// - No persiste estado propio — usa CampaignFrequencyLocalDataSource via guard.
// - No muestra UI — solo retorna Campaign o null.
// - No lanza excepciones al caller — captura internamente y retorna null.
//
// PRINCIPIOS:
// - Función pura de resolución: mismas entradas → misma salida.
// - Fail-silent: cualquier error retorna null (el caller usa el fallback).
// - Single source of truth: usa evaluateSoat() / getSoatPriority() del evaluador.
// - Sin hardcode de colores ni strings de rutas en la lógica.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Primera versión del Campaign Engine basado en datos reales.
// Soporta activos vehiculares + SOAT. Extender en tickets posteriores para:
// - Seguros vehículo (todo_riesgo), inmuebles, mantenimientos vencidos, etc.
// ============================================================================

import '../../../domain/entities/asset/asset_entity.dart';
import '../../../domain/entities/insurance/insurance_policy_entity.dart';
import '../../../routes/app_pages.dart';
import '../../di/container.dart';
import '../models/campaign.dart';
import '../models/campaign_eligibility.dart';
import '../soat/soat_campaign_evaluator.dart';
import 'soat_frequency_guard.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CANDIDATE — Tipo interno para candidatos de campaña SOAT
// ─────────────────────────────────────────────────────────────────────────────

/// Candidato de campaña SOAT: activo + póliza evaluada + prioridad calculada.
///
/// Tipo Dart 3 record para minimizar boilerplate interno.
typedef _SoatCandidate = ({
  AssetEntity asset,
  InsurancePolicyEntity policy,
  SoatEvaluation evaluation,
  SoatPriority priority,
});

// ─────────────────────────────────────────────────────────────────────────────
// CAMPAIGN RESOLVER
// ─────────────────────────────────────────────────────────────────────────────

/// Motor de resolución de campañas basado en datos reales del dominio.
///
/// Evalúa los activos vehiculares del org, detecta SOAT próximos a vencer
/// o vencidos, selecciona el más urgente y construye un [Campaign] dinámico.
///
/// Si no encuentra nada accionable (o falla), retorna `null` → el caller
/// puede caer al fallback [DemoCampaigns.forScreen()].
///
/// Uso:
/// ```dart
/// final campaign = await CampaignResolver().resolve(orgId: orgId);
/// ```
class CampaignResolver {
  /// Resuelve la campaña más urgente para el org especificado.
  ///
  /// Pasos:
  /// 1. Obtener activos vehiculares del org (local Isar — offline-first).
  /// 2. Para cada activo, obtener pólizas SOAT activas.
  /// 3. Evaluar y priorizar por urgencia de vencimiento.
  /// 4. Verificar [SoatFrequencyGuard] para cooldown entre sesiones.
  /// 5. Construir [Campaign] con mensajes contextuales por urgencia.
  ///
  /// Retorna `null` si:
  /// - No hay activos vehiculares en el org.
  /// - Ningún activo tiene SOAT próximo (> 30 días).
  /// - El cooldown de frecuencia no ha expirado.
  /// - Ocurre cualquier error (fail-silent).
  Future<Campaign?> resolve({required String orgId}) async {
    try {
      // ── 1. Obtener activos vehiculares ────────────────────────────────────
      final allAssets =
          await DIContainer().assetRepository.fetchAssetsByOrg(orgId);

      // Filtrar solo vehículos — SOAT aplica únicamente a activos vehiculares.
      final vehicles = allAssets
          .where((a) => a.type == AssetType.vehicle)
          .toList();

      if (vehicles.isEmpty) return null;

      // ── 2. Evaluar SOAT de cada vehículo (paralelo — offline-first rápido) ─
      final candidates = <_SoatCandidate>[];

      await Future.wait(vehicles.map((asset) async {
        final policies = await DIContainer()
            .insuranceRepository
            .fetchPoliciesByAsset(asset.id);

        // Solo pólizas SOAT — usa policyType para evitar comparación string frágil.
        final soats = policies
            .where((p) => p.policyType == InsurancePolicyType.soat)
            .toList();

        if (soats.isEmpty) return;

        // Política SOAT más reciente — mayor fecha de fin.
        soats.sort((a, b) => b.fechaFin.compareTo(a.fechaFin));
        final latest = soats.first;

        final evaluation = evaluateSoat(latest.fechaFin);
        final priority = getSoatPriority(evaluation.diasRestantes);

        // Ignorar activos sin urgencia (> 30 días).
        if (priority == SoatPriority.none) return;

        candidates.add((
          asset: asset,
          policy: latest,
          evaluation: evaluation,
          priority: priority,
        ));
      }));

      if (candidates.isEmpty) return null;

      // ── 3. Priorizar: critical > high > medium > low ──────────────────────
      // SoatPriority.index: none=0, low=1, medium=2, high=3, critical=4
      candidates.sort(
        (a, b) => b.priority.index.compareTo(a.priority.index),
      );

      final best = candidates.first;
      final campaignId = 'soat_${best.asset.id}';

      // ── 4. Verificar cooldown de frecuencia SOAT (entre sesiones) ─────────
      final guard = SoatFrequencyGuard(DIContainer().isar);
      final canShow =
          await guard.canShow(campaignId, best.evaluation.diasRestantes);

      if (!canShow) return null;

      // ── 5. Construir Campaign dinámica ─────────────────────────────────────
      return _buildSoatCampaign(
        campaignId: campaignId,
        candidate: best,
      );
    } catch (_) {
      // Fail-silent: cualquier error (red, Isar, null) retorna null.
      // El caller (CampaignOrchestrator) usa DemoCampaigns como fallback.
      return null;
    }
  }

  // ── Construcción de Campaign dinámica ──────────────────────────────────────

  /// Construye un [Campaign] con mensajes contextuales según la urgencia SOAT.
  ///
  /// Mensajes adaptados por nivel de prioridad para maximizar conversión:
  /// - critical (vencido): urgencia máxima, consecuencias legales.
  /// - critical (≤2d): urgencia alta, inminencia.
  /// - high (3-7d): alerta, llamado a cotizar.
  /// - medium (8-15d): prevención, sin apuros.
  /// - low (16-30d): informativo, planificación.
  Campaign _buildSoatCampaign({
    required String campaignId,
    required _SoatCandidate candidate,
  }) {
    final placa      = candidate.asset.assetKey;
    final dias       = candidate.evaluation.diasRestantes;
    final priority   = candidate.priority;

    final String title;
    final String subtitle;
    final String ctaText;

    switch (priority) {
      case SoatPriority.critical:
        if (dias < 0) {
          // Vencido.
          title    = 'Tienes un SOAT vencido';
          subtitle = 'El vehículo $placa tiene el SOAT vencido. '
                     'Evita multas y retención del vehículo.';
          ctaText  = 'Renovar SOAT ahora';
        } else {
          // ≤ 2 días.
          final diasLabel = dias == 0 ? 'hoy' : 'en $dias día${dias > 1 ? 's' : ''}';
          title    = 'Tu SOAT vence $diasLabel';
          subtitle = 'El vehículo $placa necesita renovación urgente. '
                     'Actúa antes de quedar desprotegido.';
          ctaText  = 'Renovar SOAT ahora';
        }

      case SoatPriority.high:
        title    = 'SOAT próximo a vencer';
        subtitle = 'El vehículo $placa tiene el SOAT con $dias días restantes. '
                   'Renueva a tiempo y evita sanciones.';
        ctaText  = 'Cotizar renovación';

      case SoatPriority.medium:
        title    = 'Renueva tu SOAT este mes';
        subtitle = 'El vehículo $placa vence en $dias días. '
                   'Cotiza y renueva sin apuros.';
        ctaText  = 'Cotizar SOAT';

      case SoatPriority.low:
        title    = 'Tu SOAT vence pronto';
        subtitle = 'El vehículo $placa tiene el SOAT con $dias días restantes. '
                   'Empieza a cotizar con tiempo.';
        ctaText  = 'Ver opciones de seguro';

      case SoatPriority.none:
        // No debería llegar aquí — filtrado antes de llamar este método.
        title    = '¡Tu SOAT está próximo a vencer!';
        subtitle = 'Cotiza con las mejores aseguradoras y renueva en minutos.';
        ctaText  = 'Ver seguros disponibles';
    }

    return Campaign(
      id: campaignId,
      title: title,
      subtitle: subtitle,
      // Reutiliza imagen de la campaña demo de seguros.
      // TODO (Campaign Assets): Crear imagen diferenciada por urgencia (critical/warning/info).
      imageAsset: 'assets/campaign/campaign_insurance.png',
      ctaText: ctaText,
      // TODO (Routing): Crear Routes.assetInsurance con assetId como argumento
      // cuando el módulo Seguros del AssetDetail esté implementado.
      routeName: Routes.demoSoat,
      eligibilityFn: EligibilityFunctions.always,
      metadata: {
        'source':       'campaign_resolver',
        'asset_id':     candidate.asset.id,
        'asset_plate':  placa,
        'soat_dias':    dias,
        'priority':     priority.name,
      },
    );
  }
}
