// ============================================================================
// lib/presentation/pages/asset/driver_license_detail_page.dart
// DRIVER LICENSE DETAIL PAGE — Detalle de licencia de conducción del propietario
//
// QUÉ HACE:
// - Muestra el detalle de la licencia de conducción del propietario del vehículo,
//   extraída del bloque VRC Individual (owner.runt.licenses).
// - Selecciona la licencia "principal" con criterios explícitos (vigente con fecha
//   conocida > con fecha > primera de la lista). NO usa licenses[0] directamente.
// - Calcula días a vencimiento desde expiryDate con fecha calendario local.
// - Muestra banner de degradación si owner.runt.error != null (RUNT Persona falló).
// - Presenta historial de licencias adicionales si el propietario tiene más de una.
// - Incluye CTA de renovación al pie.
//
// QUÉ NO HACE:
// - No hace HTTP. No accede a repositorio.
// - No tiene controller propio — todos los datos vienen de Get.arguments.
// - No navega a SimitConsultPage ni a páginas placeholder.
//
// PRINCIPIOS:
// - StatelessWidget: datos read-only desde Get.arguments Map.
// - Null-safety estricta: ningún campo del modelo VRC es garantizado.
// - expiryDate puede ser null (backend no siempre lo envía) → "No disponible".
// - AppTheme para todos los colores; ningún color hardcodeado salvo semánticos.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase SIMIT-1 — Visualización mejorada + páginas dedicadas.
// CONTRACT: Get.toNamed(Routes.driverLicenseDetail,
//   arguments: {'data': VrcDataModel, 'checkedAt': DateTime?})
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../core/platform/owner_refresh_service.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/vrc/models/vrc_models.dart';

// Parsea "DD/MM/YYYY" a DateTime. Necesario porque el backend RUNT envía
// fechas en ese formato (no ISO 8601).
DateTime? _parseDdMmYyyy(String? s) {
  if (s == null || s.isEmpty) return null;
  final parts = s.split('/');
  if (parts.length != 3) return null;
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return null;
  return DateTime(year, month, day);
}

class DriverLicenseDetailPage extends StatefulWidget {
  const DriverLicenseDetailPage({super.key});

  @override
  State<DriverLicenseDetailPage> createState() =>
      _DriverLicenseDetailPageState();
}

class _DriverLicenseDetailPageState extends State<DriverLicenseDetailPage> {
  VrcDataModel? _data;
  DateTime _checkedAt = DateTime.now();
  String? _portfolioId;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _data = args?['data'] as VrcDataModel?;
    _checkedAt = args?['checkedAt'] as DateTime? ?? DateTime.now();
    _portfolioId = args?['portfolioId'] as String?;
  }

  /// Refresh manual: invalida cache → consulta RUNT Persona → persiste → rebuild.
  Future<void> _handleRefresh() async {
    final owner = _data?.owner;
    final document = owner?.document;
    final documentType = owner?.documentType;
    if (document == null ||
        document.isEmpty ||
        documentType == null ||
        documentType.isEmpty ||
        _portfolioId == null) return;

    setState(() => _isRefreshing = true);

    final result = await DIContainer().ownerRefreshService.refreshLicense(
          portfolioId: _portfolioId!,
          document: document,
          documentType: documentType,
        );

    if (!mounted) return;

    setState(() {
      _isRefreshing = false;
      if (result is RefreshSuccess<VrcOwnerRuntModel>) {
        _checkedAt = result.refreshedAt;
        final currentOwner = _data?.owner;
        _data = VrcDataModel(
          owner: VrcOwnerModel(
            name: currentOwner?.name,
            document: currentOwner?.document,
            documentType: currentOwner?.documentType,
            runt: result.data,
            simit: currentOwner?.simit,
          ),
        );
      }
    });

    if (result is RefreshError) {
      final err = result as RefreshError;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.isExternal
                  ? 'No se pudo conectar con RUNT. Intenta más tarde.'
                  : 'Error al actualizar datos de licencia.',
            ),
          ),
        );
      }
    } else if (result is RefreshSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos de licencia actualizados')),
        );
      }
    }
  }

  /// Formato amigable 12h: "16/04/2026, 12:52 p. m."
  String _formatTimestamp(DateTime dt) {
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final h = d.hour == 0
        ? 12
        : d.hour > 12
            ? d.hour - 12
            : d.hour;
    final min = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour < 12 ? 'a. m.' : 'p. m.';
    return '$dd/$mm/$yyyy, $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;

    if (data == null) {
      return const _ErrorScaffold(
        message: 'No se pudo obtener los datos del propietario.',
      );
    }

    final owner = data.owner;
    final licenses = owner?.runt?.licenses ?? [];
    final runtError = owner?.runt?.error;
    final mainLicense = _selectMainLicense(licenses);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
          tooltip: 'Volver',
        ),
        title: Text(
          'Licencia de conducción',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (owner?.document != null && owner?.documentType != null)
            IconButton(
              onPressed: _isRefreshing ? null : _handleRefresh,
              icon: _isRefreshing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
              tooltip: 'Actualizar datos de licencia',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        children: [
          // Header: nombre y documento del propietario
          _OwnerBlock(owner: owner, theme: theme, cs: cs),

          // Timestamp de última actualización
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: AppSpacing.md),
            child: Text(
              'Última actualización: ${_formatTimestamp(_checkedAt)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Banner de degradación — RUNT Persona falló
          if (runtError != null) ...[
            _DegradationBanner(error: runtError, theme: theme, cs: cs),
            const SizedBox(height: AppSpacing.md),
          ],

          // Estado vacío — sin licencias
          if (licenses.isEmpty) ...[
            _EmptyLicenses(
              hasRuntError: runtError != null,
              theme: theme,
              cs: cs,
            ),
          ] else ...[
            // Tarjeta principal
            _SectionLabel(label: 'Licencia principal', theme: theme, cs: cs),
            const SizedBox(height: AppSpacing.sm),
            _LicenseCard(license: mainLicense!, isMain: true, theme: theme, cs: cs),

            // Historial de licencias adicionales
            if (licenses.length > 1) ...[
              const SizedBox(height: AppSpacing.lg),
              _SectionLabel(
                label: 'Otras licencias (${licenses.length - 1})',
                theme: theme,
                cs: cs,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final lic in licenses.where((l) => l != mainLicense)) ...[
                _LicenseCard(license: lic, isMain: false, theme: theme, cs: cs),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ],

          const SizedBox(height: AppSpacing.xl),

          // CTA — renovación
          _LicenseCta(theme: theme, cs: cs),
        ],
      ),
    );
  }

  VrcLicenseModel? _selectMainLicense(List<VrcLicenseModel> licenses) {
    if (licenses.isEmpty) return null;

    bool isActive(VrcLicenseModel l) {
      final s = l.status?.toLowerCase() ?? '';
      return s.contains('vig') || s.contains('activ');
    }

    final vigentes = licenses
        .where((l) => l.expiryDate != null && isActive(l))
        .toList();
    if (vigentes.isNotEmpty) return vigentes.first;

    final conFecha = licenses.where((l) => l.expiryDate != null).toList();
    if (conFecha.isNotEmpty) return conFecha.first;

    return licenses.first;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OWNER BLOCK
// ─────────────────────────────────────────────────────────────────────────────

class _OwnerBlock extends StatelessWidget {
  final VrcOwnerModel? owner;
  final ThemeData theme;
  final ColorScheme cs;

  const _OwnerBlock({required this.owner, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final name = owner?.name ?? 'Propietario';
    final doc = _formatDoc(owner);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (doc != null)
          Text(
            doc,
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
      ],
    );
  }

  String? _formatDoc(VrcOwnerModel? owner) {
    final type = owner?.documentType?.trim().toUpperCase();
    final number = owner?.document?.trim();
    if (type == null || type.isEmpty || number == null || number.isEmpty) {
      return null;
    }
    return '$type $number';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DEGRADATION BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _DegradationBanner extends StatelessWidget {
  final String error;
  final ThemeData theme;
  final ColorScheme cs;

  const _DegradationBanner({
    required this.error,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: cs.secondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Información de RUNT Persona no disponible en este momento. '
              'Los datos de licencia pueden estar incompletos.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE — SIN LICENCIAS
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyLicenses extends StatelessWidget {
  final bool hasRuntError;
  final ThemeData theme;
  final ColorScheme cs;

  const _EmptyLicenses({
    required this.hasRuntError,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.credit_card_off_outlined,
            size: 48,
            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Sin licencias registradas',
            style: theme.textTheme.titleSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hasRuntError
                ? 'No fue posible consultar el RUNT Persona. Intenta más tarde.'
                : 'El propietario no tiene licencias de conducción '
                    'registradas en el RUNT.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final ThemeData theme;
  final ColorScheme cs;

  const _SectionLabel({
    required this.label,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LICENSE CARD — Tarjeta individual de licencia
// ─────────────────────────────────────────────────────────────────────────────

class _LicenseCard extends StatelessWidget {
  final VrcLicenseModel license;
  final bool isMain;
  final ThemeData theme;
  final ColorScheme cs;

  const _LicenseCard({
    required this.license,
    required this.isMain,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final expiry = _parseDate(license.expiryDate);
    final daysLeft = expiry
        ?.toLocal()
        .difference(DateTime.now().toLocal())
        .inDays;
    final statusColor = _statusColor(license.status);

    return Card(
      elevation: isMain ? 1 : 0,
      color: isMain ? cs.surfaceContainerLow : cs.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Categoría + badge de estado
          Row(
            children: [
              Expanded(
                child: Text(
                  license.category ?? 'Sin categoría',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (license.status != null)
                _StatusBadge(
                  status: license.status!,
                  color: statusColor,
                  theme: theme,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Días a vencimiento (destacado si es licencia principal)
          if (isMain && daysLeft != null)
            _VigenciaRow(daysLeft: daysLeft, theme: theme, cs: cs),

          // Campos de fecha
          _DataRow(
            label: 'Expedición',
            value: license.issueDate ?? 'No disponible',
            theme: theme,
            cs: cs,
          ),
          _DataRow(
            label: 'Vencimiento',
            value: license.expiryDate ?? 'No disponible',
            theme: theme,
            cs: cs,
          ),

          // Categorías habilitadas con vigencia individual
          if (license.categories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Categorías habilitadas',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            for (final cat in license.categories)
              _CategoryRow(cat: cat, theme: theme, cs: cs),
          ],
        ],
        ),
      ),
    );
  }

  DateTime? _parseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    // ISO format (YYYY-MM-DD)
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    // DD/MM/YYYY (formato RUNT/VRC — fecha_vencimiento de categories[])
    return _parseDdMmYyyy(s);
  }

  Color _statusColor(String? status) {
    if (status == null) return cs.onSurfaceVariant;
    final norm = status.toLowerCase();
    if (norm.contains('vig') || norm.contains('activ')) return Colors.green.shade600;
    if (norm.contains('venc') || norm.contains('suspend')) return cs.error;
    return cs.onSurfaceVariant;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  final ThemeData theme;

  const _StatusBadge({
    required this.status,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIGENCIA ROW — días a vencimiento destacado
// ─────────────────────────────────────────────────────────────────────────────

class _VigenciaRow extends StatelessWidget {
  final int daysLeft;
  final ThemeData theme;
  final ColorScheme cs;

  const _VigenciaRow({
    required this.daysLeft,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final (text, color) = _resolve();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (String, Color) _resolve() {
    if (daysLeft < 0) {
      return (
        'Vencida hace ${daysLeft.abs()} día${daysLeft.abs() == 1 ? '' : 's'}',
        cs.error,
      );
    }
    if (daysLeft == 0) return ('Vence hoy', cs.secondary);
    if (daysLeft <= 30) {
      return (
        'Vence en $daysLeft día${daysLeft == 1 ? '' : 's'}',
        cs.secondary,
      );
    }
    return (
      'Vence en $daysLeft días',
      Colors.green.shade600,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA ROW — fila etiqueta/valor
// ─────────────────────────────────────────────────────────────────────────────

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme cs;

  const _DataRow({
    required this.label,
    required this.value,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY ROW — fila de categoría habilitada con estado de vigencia
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  final VrcLicenseCategoryModel cat;
  final ThemeData theme;
  final ColorScheme cs;

  const _CategoryRow({
    required this.cat,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final expiry = _parseDdMmYyyy(cat.fechaVencimiento);
    final isVigente = expiry != null && expiry.isAfter(DateTime.now());

    final badgeColor = isVigente ? Colors.green.shade600 : cs.error;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              cat.categoria ?? '—',
              style: theme.textTheme.labelSmall?.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              cat.fechaVencimiento != null
                  ? 'Vence: ${cat.fechaVencimiento}'
                  : 'Sin fecha',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          if (!isVigente && expiry != null)
            Text(
              'VENCIDA',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.error,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA CARD — renovación de licencia
// ─────────────────────────────────────────────────────────────────────────────

class _LicenseCta extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;

  const _LicenseCta({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cs.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined,
                  size: 20, color: cs.onPrimaryContainer),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Mantén tu licencia al día',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Evita sanciones y contratiempos. Si tu licencia está próxima a vencer '
            'o vencida, puedes renovarla con apoyo de nuestros aliados.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onPrimaryContainer.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.snackbar(
                    'Renovar licencia',
                    'Un asesor te contactará para orientarte en el proceso.',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                  child: const Text('Renovar licencia'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.snackbar(
                    'Solicitar información',
                    'Pronto estaremos conectando este servicio.',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                  child: const Text('Solicitar información'),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR SCAFFOLD — navegación inválida (sin argumentos)
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorScaffold extends StatelessWidget {
  final String message;

  const _ErrorScaffold({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: const Text('Licencia de conducción'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.link_off_rounded, size: 48, color: cs.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
