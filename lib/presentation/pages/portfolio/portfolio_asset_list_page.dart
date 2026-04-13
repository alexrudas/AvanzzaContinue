// ============================================================================
// lib/presentation/pages/portfolio/portfolio_asset_list_page.dart
// PORTFOLIO ASSET LIST PAGE — Vista operativa de activos del portafolio
//
// QUÉ HACE:
// - Muestra los activos de un portafolio específico con reactividad total.
// - Sincroniza el conteo del header con el stream de datos en tiempo real.
// - Optimiza el renderizado mediante mapeo perezoso (Lazy Mapping).
// - Permite renombrar el portafolio desde el AppBar mediante bottom sheet.
//
// QUÉ NO HACE:
// - No mantiene suscripciones activas después de destruir el widget (Dispose).
// - No bloquea el hilo principal; el procesamiento de UI es asíncrono.
// - No persiste todavía el rename en un repositorio real, porque ese contrato
//   no está disponible en este archivo.
//
// PRINCIPIOS:
// - Real-time Consistency: El header y la lista siempre dicen la verdad.
// - Tactical UX: Haptics, scroll dismiss y jerarquía visual de alto impacto.
// - Clean Navigation: Contextos de registro inmutables con IDs de sesión únicos.
// - Single Primary Action: crear activo vive en FAB, no duplicado en AppBar.
//
// ENTERPRISE NOTES:
// ACTUALIZADO (2026-03): Sincronización de conteo dinámico en _PortfolioContextBand.
// MEJORADO (2026-03): Implementación de ScrollViewKeyboardDismissBehavior.
// REFINADO (2026-03): Rename flow con bottom sheet y CTA único de creación.
// ACTUALIZADO (2026-04): _OwnerContextBand — muestra snapshot del propietario VRC
//   persistido en PortfolioEntity al completar un batch (Problema B — Fase SIMIT-1).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/container.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../data/vrc/models/vrc_models.dart';
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
  String? _portfolioName;
  late final Stream<List<AssetEntity>>? _assetsStream;

  String get _displayPortfolioName {
    final value = _portfolioName?.trim();
    if (value != null && value.isNotEmpty) return value;
    return _portfolio?.portfolioName ?? '';
  }

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    final arg = Get.arguments;
    if (arg is PortfolioEntity) {
      _portfolio = arg;
      _portfolioName = arg.portfolioName;
      _assetsStream =
          DIContainer().assetRepository.watchAssetsByPortfolio(arg.id);
    } else {
      _assetsStream = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_portfolio == null || _assetsStream == null) {
      return _ErrorState(onBack: Get.back);
    }

    final portfolio = _portfolio!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) AppNavigator.goToHome();
      },
      child: StreamBuilder<List<AssetEntity>>(
        stream: _assetsStream,
        builder: (context, snapshot) {
          final assets = snapshot.data ?? [];
          final hasAssets = assets.isNotEmpty;

          return Scaffold(
            backgroundColor: cs.surface,
            appBar: AppBar(
              backgroundColor: cs.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon:
                    Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface),
                onPressed: AppNavigator.goToHome,
              ),
              title: Text(
                _displayPortfolioName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  onPressed: () => _openRenamePortfolioSheet(context),
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Editar portafolio',
                ),
              ],
            ),
            body: _buildBody(
              context: context,
              portfolio: portfolio,
              snapshot: snapshot,
            ),
            floatingActionButton: hasAssets
                ? FloatingActionButton.extended(
                    onPressed: () => _goToRegisterAsset(portfolio),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Registrar activo'),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required PortfolioEntity portfolio,
    required AsyncSnapshot<List<AssetEntity>> snapshot,
  }) {
    final cs = Theme.of(context).colorScheme;
    final assets = snapshot.data ?? [];

    if (snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const _InlineErrorState(
        message: 'Error de conexión con la base de datos.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PortfolioContextBand(
          portfolio: portfolio,
          currentCount: assets.length,
        ),
        // Snapshot del propietario — visible solo si fue persistido en un batch VRC previo.
        if (portfolio.ownerName != null)
          _OwnerContextBand(portfolio: portfolio),
        Divider(
          height: 1,
          thickness: 1,
          color: cs.outline.withValues(alpha: 0.12),
        ),
        Expanded(
          child: assets.isEmpty
              ? _EmptyState(
                  portfolioName: _displayPortfolioName,
                  onRegister: () => _goToRegisterAsset(portfolio),
                )
              : ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: assets.length,
                  itemBuilder: (context, i) {
                    final summary = assets[i].toSummaryVM();
                    return PortfolioAssetOperationalTile(
                      summary: summary,
                      onTap: () => AppNavigator.openAssetDetail(
                        assetId: summary.assetId,
                        portfolio: portfolio,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _openRenamePortfolioSheet(BuildContext context) async {
    final portfolio = _portfolio;
    if (portfolio == null) return;

    HapticFeedback.lightImpact();

    final newName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _RenamePortfolioSheet(
        initialName: _displayPortfolioName,
      ),
    );

    if (!mounted || newName == null) return;
    await _applyPortfolioRename(newName);
  }

  Future<void> _applyPortfolioRename(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed == _displayPortfolioName.trim()) return;

    try {
      final current = await DIContainer()
          .portfolioRepository
          .getPortfolioById(_portfolio!.id);

      if (current == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró el portafolio'),
          ),
        );
        return;
      }

      final updated = current.copyWith(
        portfolioName: trimmed,
      );

      await DIContainer().portfolioRepository.updatePortfolio(updated);

      if (!mounted) return;

      setState(() {
        _portfolio = updated;
        _portfolioName = trimmed;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Portafolio actualizado'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo actualizar el nombre del portafolio'),
        ),
      );
    }
  }

  void _goToRegisterAsset(PortfolioEntity portfolio) {
    HapticFeedback.lightImpact();
    final ctx = AssetRegistrationContext(
      portfolioId: portfolio.id,
      portfolioName: _displayPortfolioName,
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
  final int currentCount;

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

  const _EmptyState({
    required this.portfolioName,
    required this.onRegister,
  });

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
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: cs.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin activos registrados',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'El portafolio "$portfolioName" está listo para recibir su primer registro.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
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

class _RenamePortfolioSheet extends StatefulWidget {
  final String initialName;

  const _RenamePortfolioSheet({
    required this.initialName,
  });

  @override
  State<_RenamePortfolioSheet> createState() => _RenamePortfolioSheetState();
}

class _RenamePortfolioSheetState extends State<_RenamePortfolioSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  String get _initialTrimmed => widget.initialName.trim();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName)
      ..selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.initialName.length,
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Editar nombre del portafolio',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Actualiza el nombre visible de este portafolio.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del portafolio',
                      hintText: 'Ej. Flota Barranquilla',
                    ),
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) return 'Ingresa un nombre';
                      if (trimmed == _initialTrimmed) {
                        return 'El nombre no cambió';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _submit,
                          child: const Text('Guardar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineErrorState extends StatelessWidget {
  final String message;

  const _InlineErrorState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            const TextButton(
              onPressed: AppNavigator.goToHome,
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OwnerContextBand — Snapshot del propietario VRC persistido
//
// Visible solo cuando portfolio.ownerName != null (batch VRC completado
// en sesión anterior). Muestra 2 tiles/cards compactos read-only:
// Licencia y SIMIT — coherentes visualmente con los cards de la live page.
// No tappable: la navegación al detalle solo está disponible desde la live page.
// ─────────────────────────────────────────────────────────────────────────────

class _OwnerContextBand extends StatelessWidget {
  final PortfolioEntity portfolio;

  const _OwnerContextBand({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final docDisplay = _formatOwnerDoc(portfolio);

    return Container(
      color: cs.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del propietario
          Text(
            portfolio.ownerName!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (docDisplay != null) ...[
            const SizedBox(height: 2),
            Text(
              docDisplay,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          // 2 tiles/cards compactos: Licencia y SIMIT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _OwnerInfoTile(
                  icon: Icons.credit_card_outlined,
                  label: 'Licencia',
                  value: portfolio.licenseStatus ?? 'Sin información',
                  valueColor:
                      _licenseColorFromStatus(cs, portfolio.licenseStatus),
                  subtitle: portfolio.licenseExpiryDate != null
                      ? 'Vence ${portfolio.licenseExpiryDate}'
                      : null,
                  onTap: () => Get.toNamed(
                    Routes.driverLicenseDetail,
                    arguments: {
                      'data': _buildSnapshotVrcData(),
                      'checkedAt': portfolio.simitCheckedAt,
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _OwnerInfoTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'SIMIT',
                  value: _simitValueText(portfolio),
                  valueColor: portfolio.simitHasFines == true ? cs.error : null,
                  subtitle: _simitSubtitleText(portfolio),
                  onTap: () => Get.toNamed(
                    Routes.simitPersonDetail,
                    arguments: {
                      'data': _buildSnapshotVrcData(),
                      'checkedAt': portfolio.simitCheckedAt,
                    },
                  ),
                ),
              ),
            ],
          ),
          // Nota de antigüedad del snapshot
          if (portfolio.simitCheckedAt != null) ...[
            const SizedBox(height: 6),
            Text(
              'Última consulta · ${_formatCheckedAt(portfolio.simitCheckedAt!)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? _formatOwnerDoc(PortfolioEntity p) {
    final type = p.ownerDocumentType?.trim().toUpperCase();
    final number = p.ownerDocument?.trim();
    if (type == null || type.isEmpty || number == null || number.isEmpty) {
      return null;
    }
    return '$type $number';
  }

  Color? _licenseColorFromStatus(ColorScheme cs, String? status) {
    if (status == null) return null;
    final norm = status.toLowerCase();
    if (norm.contains('vig') || norm.contains('activ')) {
      return Colors.green.shade600;
    }
    if (norm.contains('venc') || norm.contains('suspend')) return cs.error;
    return null;
  }

  String _simitValueText(PortfolioEntity p) {
    if (p.simitHasFines == false) return 'Sin multas';
    return p.simitFormattedTotal ?? 'Ver detalle';
  }

  /// Segunda línea del tile SIMIT: comparendos y multas si disponibles.
  String? _simitSubtitleText(PortfolioEntity p) {
    if (p.simitHasFines != true) return null;
    final comparendos = p.simitComparendosCount;
    final multas = p.simitMultasCount;
    if (comparendos == null && multas == null) return null;
    final parts = <String>[];
    if (comparendos != null) {
      parts.add('$comparendos comparendo${comparendos != 1 ? 's' : ''}');
    }
    if (multas != null) {
      parts.add('$multas multa${multas != 1 ? 's' : ''}');
    }
    return parts.join(' · ');
  }

  String _formatCheckedAt(DateTime dt) {
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString().substring(2);
    return '$dd/$mm/$yy';
  }

  /// Construye un [VrcDataModel] mínimo desde el snapshot de Isar.
  ///
  /// Solo incluye los campos persistidos en [PortfolioEntity]: nombre,
  /// documento, estado de licencia y resumen SIMIT. Arrays de detalle
  /// (categories, fines[]) quedan vacíos — las páginas de detalle los
  /// manejan defensivamente.
  ///
  /// Se llama DENTRO de los lambdas onTap (no en cada build) → costo cero
  /// en renders; el objeto se construye solo cuando el usuario toca.
  VrcDataModel _buildSnapshotVrcData() {
    return VrcDataModel(
      owner: VrcOwnerModel(
        name: portfolio.ownerName,
        document: portfolio.ownerDocument,
        documentType: portfolio.ownerDocumentType,
        runt: portfolio.licenseStatus != null
            ? VrcOwnerRuntModel(
                licenses: [
                  VrcLicenseModel(
                    status: portfolio.licenseStatus,
                    expiryDate: portfolio.licenseExpiryDate,
                  ),
                ],
              )
            : null,
        simit: portfolio.simitHasFines != null
            ? VrcOwnerSimitModel(summary: _buildSnapshotSimitSummary())
            : null,
      ),
    );
  }

  /// Construye solo el [VrcSimitSummaryModel] desde el snapshot.
  ///
  /// Usado tanto por [_buildSnapshotVrcData] como directamente por el tile
  /// SIMIT para el parámetro summary. Retorna null si no hay datos SIMIT.
  VrcSimitSummaryModel? _buildSnapshotSimitSummary() {
    if (portfolio.simitHasFines == null) return null;
    return VrcSimitSummaryModel(
      hasFines: portfolio.simitHasFines,
      finesCount: portfolio.simitFinesCount,
      comparendos: portfolio.simitComparendosCount,
      multas: portfolio.simitMultasCount,
      formattedTotal: portfolio.simitFormattedTotal,
    );
  }
}

// ── _OwnerInfoTile ─────────────────────────────────────────────────────────────
// Tile/card compacto para el snapshot del propietario.
// Misma caja visual que _LicenseCard/_SimitCard de portfolio_asset_live_page.
// onTap opcional — cuando se proporciona, muestra chevron y efecto ripple.

class _OwnerInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const _OwnerInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainer,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila de etiqueta con ícono y chevron opcional
              Row(
                children: [
                  Icon(icon, size: 13, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  if (onTap != null) ...[
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: cs.primary.withValues(alpha: 0.75),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              // Valor principal
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: valueColor ?? cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Segunda línea opcional (comparendos/multas)
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextButton(
              onPressed: onBack,
              child: const Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
