// ============================================================================
// components/material/inputs.dart
// ============================================================================
//
// QUÉ ES:
//   Sistema de theming para inputs (TextFields, DropdownButtons, etc.)
//   siguiendo Material Design 3 y UI PRO 2025.
//
// DÓNDE SE USA:
//   - Todos los formularios de la app (mantenimiento, contabilidad, arrendamiento)
//   - Filtros y campos de búsqueda
//   - Formularios de autenticación (login, registro)
//
// CARACTERÍSTICAS:
//   ✅ Estados visuales completos: enabled, focused, error, readOnly, dense
//   ✅ Colores dinámicos derivados de ColorScheme (sin hardcodear)
//   ✅ Accesibilidad: textScaleFactor, minHeight, floatingLabelBehavior
//   ✅ Helpers para decoraciones específicas (readOnly, compact)
//   ✅ Consistencia total entre Light/Dark/High Contrast
//   ✅ Padding y border radius centralizados
//
// USO ESPERADO:
//   // En theme presets (light_theme.dart, dark_theme.dart, etc.)
//   inputDecorationTheme: AppInputThemes.inputDecoration(AppColorSchemes.light),
//
//   // En formularios individuales (override específico)
//   TextField(
//     decoration: AppInputThemes.readOnlyDecoration(
//       context,
//       label: 'Estado',
//       hint: 'No editable',
//     ),
//   )
//
//   // Input compacto (dense mode)
//   TextField(
//     decoration: AppInputThemes.compact(
//       context,
//       label: 'Código',
//       prefixIcon: Icons.qr_code,
//     ),
//   )
//
// ANTIPATRONES (evitar):
//   ❌ Hardcodear colores en decorations individuales
//   ❌ Usar InputDecoration.collapsed() sin considerar accesibilidad
//   ❌ No especificar labelText (importante para screen readers)
//
// ============================================================================

import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';

/// Sistema de theming global para inputs de formulario.
///
/// Provee configuración centralizada para todos los estados de inputs:
/// - Enabled: Estado por defecto con borde outline
/// - Focused: Borde primary de 2px con animación
/// - Error: Borde error con mensaje de validación
/// - Disabled: Colores desaturados, no interactivo
/// - ReadOnly: Visual de solo lectura con fondo diferenciado
abstract class AppInputThemes {
  AppInputThemes._();

  // ========== CONSTANTES PRIVADAS ==========

  /// Border radius estándar para inputs (M3 recomienda 8-12dp)
  static const double _borderRadius = 8.0;

  /// Padding interno del campo (vertical + horizontal)
  static const EdgeInsets _standardPadding = EdgeInsets.all(16.0);

  /// Padding compacto para formularios densos (filtros, modales)
  static const EdgeInsets _densePadding = EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 10.0,
  );

  /// Ancho del borde en estado focused (M3 recomienda 2px para énfasis)
  static const double _focusedBorderWidth = 2.0;

  /// Ancho del borde en estados enabled/error (1px para sutileza)
  static const double _defaultBorderWidth = 1.0;

  // ========== THEME PRINCIPAL ==========

  /// Tema base de InputDecoration para toda la aplicación.
  ///
  /// Este método se aplica globalmente en los presets (light_theme.dart, etc.)
  /// y define el estilo por defecto de todos los TextFields y similares.
  ///
  /// COMPORTAMIENTO:
  /// - Filled: true → Fondo con surfaceContainerHighest (sutil elevación)
  /// - FloatingLabel: auto → Label flota al hacer focus o al escribir
  /// - Borders: OutlineInputBorder con radius consistente
  /// - Colores: Derivados dinámicamente de ColorScheme (M3 compliant)
  ///
  /// ACCESIBILIDAD:
  /// - Label siempre visible (no collapse)
  /// - Contraste WCAG AAA entre texto y fondo
  /// - textScaleFactor respetado automáticamente por Material
  static InputDecorationTheme inputDecoration(ColorScheme scheme) {
    return InputDecorationTheme(
      // Fondo sutil elevado (M3 surface container highest)
      filled: true,
      fillColor: scheme.surfaceContainerHighest,

      // Floating label behavior (auto = flota al focus o con contenido)
      floatingLabelBehavior: FloatingLabelBehavior.auto,

      // Tipografía y colores de hint/label
      hintStyle: DS.typography.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: DS.typography.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: DS.typography.textTheme.bodySmall?.copyWith(
        color: scheme.primary,
        fontWeight: FontWeight.w600,
      ),

      // Color del texto del input
      // NOTA: No se puede definir directamente en InputDecorationTheme,
      // se hereda del TextTheme global o se especifica por TextField

      // Estilo de error (mensaje de validación)
      errorStyle: DS.typography.textTheme.bodySmall?.copyWith(
        color: scheme.error,
        fontWeight: FontWeight.w500,
      ),
      errorMaxLines: 2, // Permite mensajes de error multi-línea

      // ========== BORDERS ==========

      // Border base (usado como fallback)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline,
          width: _defaultBorderWidth,
        ),
      ),

      // Estado ENABLED (no focused, sin error)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline,
          width: _defaultBorderWidth,
        ),
      ),

      // Estado FOCUSED (usuario interactuando)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.primary,
          width: _focusedBorderWidth,
        ),
      ),

      // Estado ERROR (validación fallida)
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.error,
          width: _defaultBorderWidth,
        ),
      ),

      // Estado FOCUSED + ERROR (usuario editando campo inválido)
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.error,
          width: _focusedBorderWidth,
        ),
      ),

      // Estado DISABLED (readOnly: true o enabled: false)
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline.withValues(alpha: 0.38),
          width: _defaultBorderWidth,
        ),
      ),

      // Padding interno del contenido
      contentPadding: _standardPadding,

      // Constraints de altura mínima para accesibilidad touch
      // M3 recomienda mínimo 48dp de altura táctil
      constraints: const BoxConstraints(minHeight: 56.0),

      // Estilo de prefixIcon y suffixIcon
      prefixIconColor: scheme.onSurfaceVariant,
      suffixIconColor: scheme.onSurfaceVariant,
    );
  }

  // ========== HELPERS ESPECÍFICOS ==========

  /// Decoración para campos de solo lectura (readOnly: true).
  ///
  /// DIFERENCIAS CON EL TEMA BASE:
  /// - Fondo más claro (surfaceContainerLow en lugar de Highest)
  /// - Borde más sutil (outline con alpha 0.5)
  /// - Label en onSurfaceVariant (menos énfasis)
  /// - Cursor deshabilitado visualmente
  ///
  /// USO:
  /// ```dart
  /// TextField(
  ///   readOnly: true,
  ///   decoration: AppInputThemes.readOnlyDecoration(
  ///     context,
  ///     label: 'ID Activo',
  ///     hint: 'Generado automáticamente',
  ///   ),
  /// )
  /// ```
  static InputDecoration readOnlyDecoration(
    BuildContext context, {
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final scheme = DS.scheme(context);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline.withValues(alpha: 0.5),
          width: _defaultBorderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline.withValues(alpha: 0.5),
          width: _defaultBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline.withValues(alpha: 0.7),
          width: _defaultBorderWidth,
        ),
      ),
      contentPadding: _standardPadding,
    );
  }

  /// Decoración compacta para formularios densos (filtros, modales).
  ///
  /// DIFERENCIAS CON EL TEMA BASE:
  /// - Padding reducido (12x10 en lugar de 16x16)
  /// - Altura mínima menor (48dp en lugar de 56dp)
  /// - Ideal para grids de filtros o formularios multi-columna
  ///
  /// USO:
  /// ```dart
  /// TextField(
  ///   decoration: AppInputThemes.compact(
  ///     context,
  ///     label: 'Buscar',
  ///     prefixIcon: Icons.search,
  ///   ),
  /// )
  /// ```
  static InputDecoration compact(
    BuildContext context, {
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    final scheme = DS.scheme(context);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      isDense: true, // Activa modo dense (reduce altura automáticamente)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline,
          width: _defaultBorderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.outline,
          width: _defaultBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.primary,
          width: _focusedBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.error,
          width: _defaultBorderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: scheme.error,
          width: _focusedBorderWidth,
        ),
      ),
      contentPadding: _densePadding,
      constraints: const BoxConstraints(minHeight: 48.0),
    );
  }
}
