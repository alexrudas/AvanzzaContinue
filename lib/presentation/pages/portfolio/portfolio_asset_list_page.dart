// ============================================================================
// lib/presentation/pages/portfolio/portfolio_asset_list_page.dart
// PORTFOLIO ASSET LIST PAGE — Vista operativa de activos del portafolio
//
// QUÉ HACE:
// - Muestra los activos de un portafolio específico con reactividad total.
// - Sincroniza el conteo del header con el stream de datos en tiempo real.
// - Optimiza el renderizado mediante mapeo perezoso (Lazy Mapping).
//
// QUÉ NO HACE:
// - No mantiene suscripciones activas después de destruir el widget (Dispose).
// - No bloquea el hilo principal; el procesamiento de UI es asíncrono.
//
// PRINCIPIOS:
// - Real-time Consistency: El header y la lista siempre dicen la verdad.
// - Tactical UX: Haptics, scroll dismiss y jerarquía visual de alto impacto.
// - Clean Navigation: Contextos de registro inmutables con IDs de sesión únicos.
//
// ENTERPRISE NOTES:
// ACTUALIZADO (2026-03): Sincronización de conteo dinámico en _PortfolioContextBand.
// MEJORADO (2026-03): Implementación de ScrollViewKeyboardDismissBehavior.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/asset/asset_entity.dart';
import '../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../domain/shared/enums/asset_type.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../routes/app_pages.dart';
import '../../mappers/asset_summary_mapper.dart';
import '../../widgets/asset/portfolio_asset_operational_tile.dart';

class PortfolioAssetListPage extends StatefulWidget {
  const PortfolioAssetListPage({super.key});

  @override
  State<PortfolioAssetListPage> createState() => _PortfolioAssetListPageState();
}

class _PortfolioAssetListPageState extends State<PortfolioAssetListPage> {
  PortfolioEntity? _portfolio;
  late final Stream<List<AssetEntity>>? _assetsStream;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    final arg = Get.arguments;
    if (arg is PortfolioEntity) {
      _portfolio = arg;
      _assetsStream =
          DIContainer().assetRepository.watchAssetsByPortfolio(arg.id);
    } else {
      _assetsStream = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Guard: Error de navegación o argumentos
    if (_portfolio == null || _assetsStream == null) {
      return _ErrorState(onBack: Get.back);
    }

    final portfolio = _portfolio!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface),
          onPressed: Get.back,
        ),
        title: Text(
          portfolio.portfolioName,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () => _goToRegisterAsset(portfolio),
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Agregar activo',
          ),
        ],
      ),
      body: StreamBuilder<List<AssetEntity>>(
        stream: _assetsStream,
        builder: (context, snapshot) {
          // 1. Estado: Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Estado: Error
          if (snapshot.hasError) {
            return _ErrorState(
                onBack: Get.back,
                message: 'Error de conexión con la base de datos.');
          }

          final assets = snapshot.data ?? [];

          // UI Principal: Columna con Header Reactivo + Lista
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con el conteo REAL del stream (sincronizado)
              _PortfolioContextBand(
                portfolio: portfolio,
                currentCount: assets.length,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: cs.outline.withValues(alpha: 0.12),
              ),
              Expanded(
                child: assets.isEmpty
                    ? _EmptyState(
                        portfolioName: portfolio.portfolioName,
                        onRegister: () => _goToRegisterAsset(portfolio),
                      )
                    : ListView.builder(
                        // UX: Esconde teclado al hacer scroll
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                        itemCount: assets.length,
                        itemBuilder: (context, i) {
                          // Lazy mapping: solo procesa lo que está en pantalla
                          final summary = assets[i].toSummaryVM();
                          return PortfolioAssetOperationalTile(
                            summary: summary,
                            onTap: () => Get.toNamed(
                              Routes.assetDetail,
                              arguments: summary.assetId,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToRegisterAsset(portfolio),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Registrar activo'),
      ),
    );
  }

  void _goToRegisterAsset(PortfolioEntity portfolio) {
    HapticFeedback.lightImpact();
    final ctx = AssetRegistrationContext(
      portfolioId: portfolio.id,
      portfolioName: portfolio.portfolioName,
      countryId: portfolio.countryId,
      cityId: portfolio.cityId,
      assetType: AssetRegistrationType.vehiculo,
      registrationSessionId: const Uuid().v4(),
    );
    Get.toNamed(Routes.assetRegister, arguments: ctx);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPONENTES DE APOYO (REFACTOREADOS)
// ─────────────────────────────────────────────────────────────────────────────

class _PortfolioContextBand extends StatelessWidget {
  final PortfolioEntity portfolio;
  final int currentCount; // Inyectado desde el Stream

  const _PortfolioContextBand({
    required this.portfolio,
    required this.currentCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final typeIcon = switch (portfolio.portfolioType) {
      PortfolioType.vehiculos => Icons.directions_car_outlined,
      PortfolioType.inmuebles => Icons.home_outlined,
      PortfolioType.operacionGeneral => Icons.work_outline,
    };

    final typeLabel = switch (portfolio.portfolioType) {
      PortfolioType.vehiculos => 'Flota vehicular',
      PortfolioType.inmuebles => 'Bienes inmuebles',
      PortfolioType.operacionGeneral => 'Operación general',
    };

    return Container(
      color: cs.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: cs.primaryContainer,
            child: Icon(typeIcon, color: cs.primary, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              typeLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Badge reactivo: cambia instantáneamente con el Stream
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$currentCount ${currentCount == 1 ? 'activo' : 'activos'}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String portfolioName;
  final VoidCallback onRegister;

  const _EmptyState({required this.portfolioName, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 80, color: cs.primary.withValues(alpha: 0.2)),
            const SizedBox(height: 24),
            Text(
              'Sin activos registrados',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'El portafolio "$portfolioName" está listo para recibir su primer registro.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onRegister,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Comenzar registro'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onBack;
  final String message;

  const _ErrorState({
    required this.onBack,
    this.message = 'No se pudo cargar la información del portafolio.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextButton(onPressed: onBack, child: const Text('Regresar')),
          ],
        ),
      ),
    );
  }
}
