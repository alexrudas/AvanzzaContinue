// ============================================================================
// lib/presentation/widgets/selectors/asset_type_selector.dart
// ASSET TYPE SELECTOR — Avanzza 2.0
//
// QUÉ HACE:
// - Widget reutilizable para seleccionar AssetRegistrationType usando ActionSheetPro.
// - Muestra disparador visual (icono + etiqueta) con el valor actual o placeholder.
// - Al hacer tap abre ActionSheetPro con las 5 opciones de AssetRegistrationType.
// - Integra iconos y etiquetas automáticamente desde AssetRegistrationTypeUI.
// - Callback onChanged ejecutado al seleccionar una opción.
//
// QUÉ NO HACE:
// - No conoce el AssetType canónico de domain/entities — usa AssetRegistrationType.
// - Sin lógica de negocio acoplada: 100% presentacional.
//
// PRINCIPIOS:
// - StatelessWidget puro, sin estado interno.
// - La conversión a AssetType canónico se hace en el llamador con AssetTypeMapper.
//
// ENTERPRISE NOTES:
// ACTUALIZADO (2026-03): AssetType → AssetRegistrationType (renombrado para
// eliminar colisión conceptual con AssetType canónico en asset_entity.dart).
// ============================================================================

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/presentation/widgets/modal/action_sheet_pro.dart';
import 'package:flutter/material.dart';

/// Widget selector de tipo de activo que usa ActionSheetPro.
class AssetTypeSelector extends StatelessWidget {
  /// Valor actualmente seleccionado (null si no hay selección)
  final AssetRegistrationType? selected;

  /// Callback ejecutado cuando el usuario selecciona un tipo
  final ValueChanged<AssetRegistrationType> onChanged;

  /// Título del ActionSheetPro (default: "Selecciona el tipo de activo")
  final String? title;

  /// Subtítulo opcional del ActionSheetPro
  final String? subtitle;

  /// Si el selector está habilitado (default: true)
  final bool enabled;

  const AssetTypeSelector({
    super.key,
    this.selected,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () => showAssetTypeSheet(context,
              title: title, subtitle: subtitle, onChanged: onChanged)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? const Color(0xFFE5E7EB) : const Color(0xFFF3F4F6),
          ),
        ),
        child: Row(
          children: [
            // Icono del tipo seleccionado o icono genérico
            Icon(
              selected?.icon ?? Icons.category_outlined,
              color: enabled
                  ? (selected != null
                      ? const Color(0xFF1F2937)
                      : const Color(0xFF9CA3AF))
                  : const Color(0xFFD1D5DB),
              size: 22,
            ),
            const SizedBox(width: 12),
            // Texto del tipo seleccionado o placeholder
            Expanded(
              child: Text(
                selected?.displayName ?? 'Selecciona tipo de activo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: enabled
                      ? (selected != null
                          ? const Color(0xFF1F2937)
                          : const Color(0xFF9CA3AF))
                      : const Color(0xFFD1D5DB),
                ),
              ),
            ),
            // Icono chevron
            Icon(
              Icons.arrow_drop_down,
              color:
                  enabled ? const Color(0xFF9CA3AF) : const Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}

/// Muestra el ActionSheetPro con las opciones de AssetRegistrationType.
Future<void> showAssetTypeSheet(
  BuildContext context, {
  String? title,
  String? subtitle,
  ValueChanged<AssetRegistrationType>? onChanged,
}) async {
  await ActionSheetPro.show(
    context,
    title: title ?? 'Selecciona el tipo de activo',
    data: [
      ActionSection(
        header: subtitle,
        items: AssetRegistrationType.values
            .map(
              (type) => ActionItem(
                label: type.displayName,
                icon: type.icon,
                onTap: () {
                  onChanged?.call(type);
                },
              ),
            )
            .toList(),
      ),
    ],
  );
}
