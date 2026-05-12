// ============================================================================
// lib/presentation/pages/admin/network/provider_detail_page.dart
// PROVIDER DETAIL PAGE — Ficha LECTORA por secciones
// ============================================================================
// QUÉ HACE:
//   - Muestra el proveedor por secciones (Datos básicos, Contacto, Ubicación,
//     Tipo y categorías, Cobertura, Observaciones). Se alimenta del stream
//     canónico `LocalContactRepository.watchById(providerId)`: cualquier
//     edición se refleja en vivo.
//   - Cada sección tiene botón "Editar" en la esquina superior derecha de la
//     tarjeta que abre el formulario ENFOCADO en esa sección (scroll +
//     highlight). La persistencia sigue trabajando con la entidad completa.
//   - El banner superior muestra "Completa su registro" con los campos
//     faltantes (si aplica). Si está completo, no hay ruido.
//   - "Eliminar" es acción SECUNDARIA vía PopupMenuButton del AppBar.
//     Deliberadamente NO hay icono Editar global: editar es por sección.
//
// QUÉ NO HACE:
//   - NO es un form: no muta campos. La edición va por la page de form.
//   - NO depende del probe ni de infraestructura pública.
//   - NO abre cross-workspace: scope estricto al workspace del repo.
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../domain/entities/core_common/provider_branch_entity.dart';
import '../../../../domain/entities/core_common/value_objects/supplier_type.dart';
import '../../../../domain/services/core_common/local_contact_completeness.dart';
import '../../../../routes/app_routes.dart';
import '../../../controllers/admin/network/provider_detail_controller.dart';
import '../../../controllers/admin/network/provider_form_section.dart';
import '../../../location/controllers/location_controller.dart';
import '../../../shared/widgets/phone/phone_field.dart';
import 'widgets/provider_branch_editor_sheet.dart';

class ProviderDetailPage extends StatefulWidget {
  const ProviderDetailPage({super.key});

  @override
  State<ProviderDetailPage> createState() => _ProviderDetailPageState();
}

class _ProviderDetailPageState extends State<ProviderDetailPage> {
  late final ProviderDetailController _controller;

  /// Snackbar activo del flujo "Eliminar / Deshacer". Mismo patrón que
  /// `providers_directory_page.dart`: tracker explícito + timer de
  /// auto-close para que el snackbar respete su duración incluso si el
  /// auto-close de Material falla por ediciones de overlay durante la
  /// navegación (causa raíz del bug "snackbar permanente" reportado).
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _activeSnack;
  Timer? _snackDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProviderDetailController>();
  }

  @override
  void dispose() {
    // SALVEDAD vs `providers_directory_page`: aquí NO cerramos
    // `_activeSnack` ni cancelamos `_snackDismissTimer` en dispose, porque
    // `_onDelete()` hace `Get.back()` justo después de mostrar el snackbar
    // → este State se desmonta de inmediato. Cerrar el snackbar aquí lo
    // haría invisible y romper el flujo de "Deshacer". Dejamos que el
    // Timer (que vive en el event loop, no en el State) dispare su
    // close() tras `duration` independientemente del lifecycle del page.
    // Las referencias capturadas por el closure del Timer (`_activeSnack`)
    // siguen siendo válidas tras dispose en Dart.
    //
    // Si en el futuro este page se mantiene viva tras delete (cambio de
    // contrato de navegación), revisar esta decisión.
    super.dispose();
  }

  // ── ACCIONES ────────────────────────────────────────────────────────────

  Future<void> _onEditSection(ProviderFormSection s) async {
    final p = _controller.provider.value;
    if (p == null) return;
    await Get.toNamed(
      Routes.providerForm,
      arguments: {
        'providerId': p.id,
        'section': s,
      },
    );
  }

  Future<void> _onDelete() async {
    final p = _controller.provider.value;
    if (p == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar proveedor'),
        content: Text(
          '¿Eliminar "${p.displayName}" del directorio? Podrás deshacer esta '
          'acción desde el aviso que aparecerá.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (!mounted || confirm != true) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    final err = await _controller.softDelete();
    if (!mounted) return;
    if (err != null) {
      messenger?.showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    // PATRÓN ROBUSTO (espejo de `providers_directory_page.dart`):
    //   1. Cancelar timer pendiente (si lo hay).
    //   2. `hideCurrentSnackBar()` antes de mostrar uno nuevo.
    //   3. Capturar el `ScaffoldFeatureController` retornado.
    //   4. Programar Timer EXPLÍCITO de close tras `duration` — esto
    //      garantiza el cierre incluso si el auto-close de Material
    //      falla por overlays/transitions (causa raíz del bug
    //      "snackbar permanente" reportado).
    //   5. Close defensivo (try/catch) en el botón "Deshacer".
    //
    // ORDEN: mostrar snackbar PRIMERO, `Get.back()` después. El State
    // sigue montado durante esta secuencia; el Timer queda programado
    // antes del unmount y sobrevive al dispose (closure-captured).
    if (messenger != null) {
      _snackDismissTimer?.cancel();
      messenger.hideCurrentSnackBar();
      const duration = Duration(seconds: 5);
      _activeSnack = messenger.showSnackBar(
        SnackBar(
          content: Text('"${p.displayName}" eliminado del directorio.'),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              _snackDismissTimer?.cancel();
              try {
                _activeSnack?.close();
              } catch (_) {}
              _activeSnack = null;
              final r = await _controller.restore();
              // El State puede estar disposed tras `Get.back()`; usamos el
              // messenger capturado al inicio (apunta al ScaffoldMessenger
              // raíz que sobrevive la navegación) en vez de re-resolverlo.
              if (r != null) {
                messenger.showSnackBar(SnackBar(content: Text(r)));
              }
            },
          ),
        ),
      );
      _snackDismissTimer = Timer(duration, () {
        try {
          _activeSnack?.close();
        } catch (_) {}
        _activeSnack = null;
      });
    }
    Get.back();
  }

  /// Abre el cliente de correo del usuario con el destinatario precargado.
  /// Usa esquema `mailto:` vía url_launcher. Si la plataforma no tiene
  /// app de correo capaz de manejar el esquema, muestra un snackbar.
  Future<void> _openEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email.trim());
    try {
      final ok = await launchUrl(uri);
      if (!ok && mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir la app de correo.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la app de correo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Abre el sitio web en el navegador externo. Si el valor no incluye
  /// esquema, se antepone `https://` — evita que URLs ingresadas como
  /// "miproveedor.com" caigan en un intento de ruta local.
  Future<void> _openWebsite(String url) async {
    final trimmed = url.trim();
    final normalized =
        trimmed.startsWith(RegExp(r'https?://')) ? trimmed : 'https://$trimmed';
    final uri = Uri.tryParse(normalized);
    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('La URL no es válida.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el sitio web.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el sitio web.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── BUILD ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Obx(() {
          final p = _controller.provider.value;
          return Text(p?.displayName ?? 'Proveedor');
        }),
        actions: [
          PopupMenuButton<_ProviderMenu>(
            key: const Key('provider_detail.menu'),
            tooltip: 'Más opciones',
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (m) {
              switch (m) {
                case _ProviderMenu.delete:
                  _onDelete();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _ProviderMenu.delete,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: cs.error),
                    const SizedBox(width: 8),
                    Text('Eliminar', style: TextStyle(color: cs.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.error.value != null) {
          return _ErrorState(message: _controller.error.value!);
        }
        final p = _controller.provider.value;
        if (p == null) {
          return const _ErrorState(message: 'Proveedor no disponible.');
        }
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _CompletenessBanner(
                missing: _controller.missingFields,
                onComplete: () => _onEditSection(
                    _firstMissingSection(_controller.missingFields)),
              ),
              const SizedBox(height: 16),
              _Section(
                title: ProviderFormSection.basics.humanLabel,
                onEdit: () => _onEditSection(ProviderFormSection.basics),
                rows: [
                  _DetailRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Nombre / razón comercial',
                    value: p.displayName,
                  ),
                  _DetailRow(
                    icon: Icons.badge_outlined,
                    label: 'NIT / Documento',
                    value: p.docId,
                  ),
                ],
              ),
              _Section(
                title: ProviderFormSection.contact.humanLabel,
                onEdit: () => _onEditSection(ProviderFormSection.contact),
                rows: [
                  _DetailRow(
                    icon: Icons.email_outlined,
                    label: 'Correo',
                    value: p.primaryEmail,
                    trailingIcon: Icons.email_outlined,
                    trailingTooltip: 'Enviar correo',
                    onTrailingTap: _openEmail,
                  ),
                  _DetailRow(
                    icon: Icons.language_outlined,
                    label: 'Sitio web',
                    value: p.website,
                    trailingIcon: Icons.language_outlined,
                    trailingTooltip: 'Abrir sitio web',
                    onTrailingTap: _openWebsite,
                  ),
                ],
                extraBelow: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PhoneField(
                      key: const Key('provider_detail.primaryPhone'),
                      initialValue: p.primaryPhoneE164,
                      labelText: 'Teléfono principal',
                      mode: PhoneFieldMode.readOnly,
                      showCopyAction: false,
                    ),
                    if ((p.secondaryPhoneE164 ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      PhoneField(
                        key: const Key('provider_detail.secondaryPhone'),
                        initialValue: p.secondaryPhoneE164,
                        labelText: 'Teléfono alterno',
                        mode: PhoneFieldMode.readOnly,
                        showCopyAction: false,
                      ),
                    ],
                  ],
                ),
              ),
              _Section(
                title: ProviderFormSection.location.humanLabel,
                onEdit: () => _onEditSection(ProviderFormSection.location),
                rows: [
                  _DetailRow(
                    icon: Icons.public,
                    label: 'País',
                    value: _humanCountry(p.countryId),
                  ),
                  _DetailRow(
                    icon: Icons.map_outlined,
                    label: 'Departamento',
                    value: _humanRegion(p.regionId),
                  ),
                  _DetailRow(
                    icon: Icons.location_city_outlined,
                    label: 'Ciudad',
                    value: _humanCity(p.cityId),
                  ),
                  _DetailRow(
                    icon: Icons.home_outlined,
                    label: 'Dirección',
                    value: p.addressLine,
                  ),
                ],
              ),
              _Section(
                title: ProviderFormSection.coverage.humanLabel,
                onEdit: () => _onEditSection(ProviderFormSection.coverage),
                rows: const [],
                extraBelow: _CoverageSection(
                  allCountry: p.coverageAllCountry,
                  cityIds: p.coverageCityIds,
                  fallbackCityId: p.cityId,
                ),
              ),
              _BranchesSection(
                providerName: p.displayName,
                branches: p.additionalBranches,
                onAdd: _onAddBranch,
                onEdit: _onEditBranch,
                onDelete: _onDeleteBranch,
              ),
              _Section(
                title: ProviderFormSection.notes.humanLabel,
                onEdit: () => _onEditSection(ProviderFormSection.notes),
                rows: [
                  _DetailRow(
                    icon: Icons.sticky_note_2_outlined,
                    label: 'Notas privadas',
                    value: p.notesPrivate,
                    multiline: true,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── ACCIONES SOBRE SEDES DESDE EL DETALLE ───────────────────────────────

  Future<void> _onAddBranch() async {
    final p = _controller.provider.value;
    if (p == null) return;
    final newBranch = await showProviderBranchEditorSheet(
      context,
      defaultCountryId: p.countryId ?? '',
    );
    if (newBranch == null) return;
    final updatedList = [...p.additionalBranches, newBranch];
    await _controller.saveAdditionalBranches(updatedList);
  }

  Future<void> _onEditBranch(ProviderBranchEntity b) async {
    final p = _controller.provider.value;
    if (p == null) return;
    final updated = await showProviderBranchEditorSheet(
      context,
      initial: b,
      defaultCountryId: p.countryId ?? '',
    );
    if (updated == null) return;
    final updatedList = p.additionalBranches
        .map((x) => x.id == updated.id ? updated : x)
        .toList(growable: false);
    await _controller.saveAdditionalBranches(updatedList);
  }

  Future<void> _onDeleteBranch(ProviderBranchEntity b) async {
    final p = _controller.provider.value;
    if (p == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar sede'),
        content: Text(
          '¿Eliminar "${b.label ?? 'esta sede'}"? No afecta al proveedor ni '
          'a las demás sedes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final updatedList =
        p.additionalBranches.where((x) => x.id != b.id).toList(growable: false);
    await _controller.saveAdditionalBranches(updatedList);
  }

  /// Primera sección a la que se asocia un campo faltante. Si todo está bien,
  /// cae en `basics` como default seguro.
  ProviderFormSection _firstMissingSection(List<String> missing) {
    if (missing.isEmpty) return ProviderFormSection.basics;
    final first = missing.first;
    if (first == ProviderProfileField.displayName) {
      return ProviderFormSection.basics;
    }
    if (first == ProviderProfileField.primaryPhoneE164) {
      return ProviderFormSection.contact;
    }
    if (first == ProviderProfileField.regionId ||
        first == ProviderProfileField.cityId) {
      return ProviderFormSection.location;
    }
    return ProviderFormSection.basics;
  }

  // ── HELPERS DE RESOLUCIÓN HUMANA ────────────────────────────────────────

  String? _humanCountry(String? id) {
    if (id == null || id.isEmpty) return null;
    switch (id.toLowerCase()) {
      case 'col':
        return 'Colombia';
      case 'pan':
        return 'Panamá';
      case 'mex':
        return 'México';
      default:
        return id.toUpperCase();
    }
  }

  String? _humanRegion(String? id) {
    if (id == null || id.isEmpty) return null;
    try {
      final loc = Get.find<LocationController>();
      final match =
          loc.regions.where((r) => r.id == id).toList(growable: false);
      if (match.isNotEmpty) return match.first.name;
    } catch (_) {}
    return id;
  }

  String? _humanCity(String? id) {
    if (id == null || id.isEmpty) return null;
    try {
      final loc = Get.find<LocationController>();
      final match = loc.cities.where((c) => c.id == id).toList(growable: false);
      if (match.isNotEmpty) return match.first.name;
    } catch (_) {}
    return id;
  }
}

enum _ProviderMenu { delete }

// ═══════════════════════════════════════════════════════════════════════════
// SUB-WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _CompletenessBanner extends StatelessWidget {
  final List<String> missing;
  final VoidCallback onComplete;
  const _CompletenessBanner({required this.missing, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    if (missing.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: cs.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completa su registro',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.onTertiaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Faltan: ${missing.map(providerProfileFieldHumanLabel).join(', ')}.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onTertiaryContainer),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            key: const Key('provider_detail.complete'),
            onPressed: onComplete,
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_DetailRow> rows;
  final Widget? extraBelow;
  final VoidCallback onEdit;
  const _Section({
    required this.title,
    required this.rows,
    required this.onEdit,
    this.extraBelow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    key: Key('provider_detail.editSection.$title'),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: const Size(0, 36),
                    ),
                    onPressed: onEdit,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ...rows,
              if (extraBelow != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: extraBelow,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  /// Acción principal opcional al final de la fila (p. ej. "Enviar correo"
  /// o "Abrir sitio web"). Si `onTrailingTap` no es null y hay valor, se
  /// renderiza un IconButton con `trailingIcon`. REGLA DE UX: el contenido
  /// textual de la celda NO es clickeable — la acción se dispara solo al
  /// tocar este botón explícito, nunca al tocar el valor o la tarjeta.
  final IconData? trailingIcon;
  final String? trailingTooltip;
  final void Function(String value)? onTrailingTap;

  final bool multiline;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailingIcon,
    this.trailingTooltip,
    this.onTrailingTap,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = (value ?? '').trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.hintColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(
                  hasValue ? value! : '—',
                  maxLines: multiline ? null : 2,
                  overflow:
                      multiline ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: hasValue
                        ? theme.colorScheme.onSurface
                        : theme.hintColor,
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (hasValue && onTrailingTap != null)
            IconButton(
              key: Key('provider_detail.trailing.$label'),
              icon: Icon(trailingIcon ?? Icons.open_in_new_rounded, size: 18),
              tooltip: trailingTooltip ?? label,
              color: theme.colorScheme.primary,
              visualDensity: VisualDensity.compact,
              onPressed: () => onTrailingTap!(value!),
            ),
        ],
      ),
    );
  }
}

class _BranchesSection extends StatelessWidget {
  final String providerName;
  final List<ProviderBranchEntity> branches;
  final VoidCallback onAdd;
  final ValueChanged<ProviderBranchEntity> onEdit;
  final ValueChanged<ProviderBranchEntity> onDelete;

  const _BranchesSection({
    required this.providerName,
    required this.branches,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      // Encabezado de la sección: "Otras sedes" con el nombre
                      // del proveedor inmediatamente debajo, para no repetirlo
                      // dentro de cada tarjeta de sede.
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Otras sedes',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (providerName.trim().isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              providerName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  TextButton.icon(
                    key: const Key('provider_detail.branches.add'),
                    icon: const Icon(Icons.add_business_outlined, size: 18),
                    label: const Text('Agregar'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: const Size(0, 36),
                    ),
                    onPressed: onAdd,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (branches.isEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Text(
                    'Este proveedor opera desde su sede principal.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                )
              else
                for (final b in branches)
                  _BranchReadTile(
                    providerName: providerName,
                    branch: b,
                    onEdit: () => onEdit(b),
                    onDelete: () => onDelete(b),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchReadTile extends StatelessWidget {
  final String providerName;
  final ProviderBranchEntity branch;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _BranchReadTile({
    required this.providerName,
    required this.branch,
    required this.onEdit,
    required this.onDelete,
  });

  /// Retorna el label propio de la sede SOLO si aporta información distinta
  /// al nombre del proveedor. Los datos legacy a veces guardaron aquí el
  /// nombre del proveedor y eso generaba duplicación visual en cada tarjeta.
  String? _customLabel() {
    final l = branch.label?.trim();
    if (l == null || l.isEmpty) return null;
    if (l.toLowerCase() == providerName.trim().toLowerCase()) return null;
    return l;
  }

  String? _resolveCity(String? cityId) {
    if (cityId == null || cityId.isEmpty) return null;
    try {
      final loc = Get.find<LocationController>();
      final match =
          loc.cities.where((c) => c.id == cityId).toList(growable: false);
      if (match.isNotEmpty) return match.first.name;
    } catch (_) {}
    return cityId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final city = _resolveCity(branch.cityId);
    final addr = branch.addressLine?.trim();
    final customLabel = _customLabel();

    // Título preferente: label propio de la sede (si es distinto del nombre
    // del proveedor) → ciudad → fallback neutro. Nunca repetir proveedor.
    final titleText = customLabel ?? city ?? 'Sede sin ciudad';
    // Si el título fue el label, mostramos la ciudad como primera línea del
    // subtítulo; en caso contrario, la ciudad ya es el título y no duplica.
    final showCityInSubtitle = customLabel != null && city != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(Icons.store_outlined, color: cs.primary),
            title: Text(titleText),
            // Ciudad y dirección cada una en su propia línea para evitar que
            // el separador ' · ' fuerce truncamiento en pantallas angostas.
            subtitle: (showCityInSubtitle || (addr != null && addr.isNotEmpty))
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showCityInSubtitle) Text(city),
                      if (addr != null && addr.isNotEmpty) Text(addr),
                    ],
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  key: Key('provider_detail.branch.edit.${branch.id}'),
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Editar sede',
                  onPressed: onEdit,
                ),
                IconButton(
                  key: Key('provider_detail.branch.delete.${branch.id}'),
                  icon: Icon(Icons.delete_outline, size: 20, color: cs.error),
                  tooltip: 'Eliminar sede',
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
          if ((branch.phoneE164 ?? '').isNotEmpty ||
              (branch.contactName ?? '').isNotEmpty ||
              (branch.notes ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if ((branch.phoneE164 ?? '').isNotEmpty)
                    PhoneField(
                      initialValue: branch.phoneE164,
                      labelText: 'Teléfono de la sede',
                      mode: PhoneFieldMode.readOnly,
                      showCopyAction: false,
                    ),
                  if ((branch.contactName ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded,
                            size: 18, color: theme.hintColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            branch.contactName!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if ((branch.notes ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.sticky_note_2_outlined,
                            size: 18, color: theme.hintColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            branch.notes!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CoverageSection extends StatelessWidget {
  final bool allCountry;
  final List<String> cityIds;
  final String? fallbackCityId;
  const _CoverageSection({
    required this.allCountry,
    required this.cityIds,
    required this.fallbackCityId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (allCountry) {
      return Row(
        children: [
          Icon(Icons.public_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text('Envíos a todo el país', style: theme.textTheme.bodyMedium),
        ],
      );
    }
    if (cityIds.isEmpty) {
      final hint = (fallbackCityId ?? '').isEmpty
          ? 'Sin cobertura definida.'
          : 'Cobertura implícita: ciudad principal del proveedor.';
      return Text(
        hint,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: cityIds.map((cid) {
        final label = _resolveCityLabel(cid);
        return Chip(
          avatar: const Icon(Icons.location_city_outlined, size: 18),
          label: Text(label),
          visualDensity: VisualDensity.compact,
        );
      }).toList(growable: false),
    );
  }

  String _resolveCityLabel(String cityId) {
    try {
      final loc = Get.find<LocationController>();
      final match =
          loc.cities.where((c) => c.id == cityId).toList(growable: false);
      if (match.isNotEmpty) return match.first.name;
    } catch (_) {}
    return cityId;
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 56, color: cs.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

// NOTA: LocalContactEntity y SupplierType se importan porque los consume la
// lectura de `_controller.provider.value`. No se re-exportan.
// ignore: unused_element
typedef _Unused = LocalContactEntity;
// ignore: unused_element
typedef _UnusedSupplier = SupplierType;
