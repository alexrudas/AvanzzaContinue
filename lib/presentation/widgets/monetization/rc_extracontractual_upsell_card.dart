// ============================================================================
// lib/presentation/widgets/monetization/rc_extracontractual_upsell_card.dart
// RC EXTRACONTRACTUAL UPSELL CARD — Card comercial para monetización de SRCE
//
// QUÉ HACE:
// - Define un widget reusable para promover la adquisición del Seguro de
//   Responsabilidad Civil Extracontractual (SRCE) dentro de la app.
// - Presenta una oportunidad comercial con jerarquía visual superior al
//   contenido informativo estándar de la pantalla.
// - Comunica riesgo patrimonial, beneficios clave, ancla económica y un CTA
//   principal para iniciar el flujo comercial.
// - Incluye micro-interacción de entrada (fade + slide) y feedback táctil
//   sutil en el CTA para elevar percepción de producto sin caer en efectos
//   exagerados.
// - Expone callbacks explícitos para separar presentación, tracking y acción.
//
// QUÉ NO HACE:
// - No decide cuándo debe mostrarse; esa decisión vive en la página que lo usa.
// - No consulta repositorios, APIs, RUNT, Isar ni servicios de backend.
// - No ejecuta navegación por sí mismo.
// - No calcula precios, coberturas reales ni reglas comerciales dinámicas.
// - No contiene lógica de dominio sobre seguros, vigencias o elegibilidad.
//
// PRINCIPIOS:
// - Reusable: puede usarse en páginas de detalle, alert center, oportunidades
//   o futuros funnels comerciales sin duplicar UI.
// - Presentation-only: cero lógica de dominio, cero side effects internos
//   fuera de callbacks explícitos.
// - Theme-only: usa exclusivamente [Theme.of(context)] y [ColorScheme].
// - CTA-first: la card prioriza claridad comercial y acción.
// - Jerarquía visual: debe distinguirse del contenido informativo sin romper
//   coherencia con el sistema visual de la app.
// - Copia sobria y accionable: transmite riesgo y valor sin caer en tono
//   alarmista barato ni en publicidad genérica.
// - Motion sutil: la animación solo refuerza presencia; no roba atención.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Primer bloque de monetización para SRCE.
// DISEÑADO PARA:
// - Vehículos particulares sin RC extracontractual activa.
// - Escenarios donde la app detecta oportunidad comercial sin contaminar el
//   canal de alertas críticas.
// EVOLUCIÓN ESPERADA:
// - Conectar [onTap] a flujo real de cotización / proveedor / cierre.
// - Conectar [onViewed] y [onCtaPressed] a analytics real.
// - Parametrizar precio orientativo, beneficios y cobertura según estrategia
//   comercial futura, manteniendo este widget como capa de presentación.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Card de monetización para RC extracontractual con micro-interacción.
///
/// USO ESPERADO:
/// - Mostrar cuando el vehículo no tenga RC extracontractual activa
///   o cuando la estrategia comercial decida presentar la oportunidad.
///
/// RESPONSABILIDAD:
/// - Comunicar valor.
/// - Crear intención.
/// - Ofrecer CTA claro.
/// - Permitir tracking desacoplado.
///
/// NO DECIDE:
/// - visibilidad
/// - pricing real
/// - navegación
class RcExtracontractualUpsellCard extends StatefulWidget {
  /// Acción principal del CTA.
  ///
  /// La pantalla padre define qué ocurre al tocar el botón:
  /// - abrir cotización
  /// - abrir bottom sheet
  /// - abrir funnel comercial
  /// - registrar lead
  final VoidCallback onTap;

  /// Callback opcional para tracking de impresión.
  ///
  /// Se dispara una sola vez después del primer frame.
  final VoidCallback? onViewed;

  /// Callback opcional para tracking de click en CTA.
  ///
  /// Se dispara justo antes de [onTap].
  final VoidCallback? onCtaPressed;

  const RcExtracontractualUpsellCard({
    super.key,
    required this.onTap,
    this.onViewed,
    this.onCtaPressed,
  });

  @override
  State<RcExtracontractualUpsellCard> createState() =>
      _RcExtracontractualUpsellCardState();
}

class _RcExtracontractualUpsellCardState
    extends State<RcExtracontractualUpsellCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool _hasTrackedView = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(_fade);

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasTrackedView) return;
      _hasTrackedView = true;

      if (widget.onViewed != null) {
        widget.onViewed!();
      } else if (kDebugMode) {
        debugPrint('[TRACK] rc_upsell_viewed');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onCtaPressed != null) {
      widget.onCtaPressed!();
    } else if (kDebugMode) {
      debugPrint('[TRACK] rc_upsell_clicked');
    }

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 8),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                cs.primary.withValues(alpha: 0.10),
                cs.primary.withValues(alpha: 0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'RECOMENDADO',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Título
              Text(
                'Protege tu patrimonio',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 12),

              // Descripción
              Text(
                'Un accidente puede generar costos elevados que pagas de tu bolsillo.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 22),

              // Valor
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: _ValueBlock(
                        icon: Icons.shield_outlined,
                        title: '\$50M cobertura',
                        subtitle: 'Respaldo económico',
                      ),
                    ),
                    VerticalDivider(
                      width: 24,
                      thickness: 1,
                      color: cs.outline.withValues(alpha: 0.15),
                    ),
                    const Expanded(
                      child: _ValueBlock(
                        icon: Icons.home_outlined,
                        title: 'Daños a terceros',
                        subtitle: 'Vehículos y bienes',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const _BenefitLine(
                icon: Icons.gavel_outlined,
                text: 'Asistencia jurídica incluida',
              ),

              const SizedBox(height: 16),

              Text(
                'Desde \$250.000/año',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 22),

              // CTA CORREGIDO (única fuente de tap)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleTap,
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                  ),
                  child: Text(
                    'Cotizar RC extracontractual',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ValueBlock({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            icon,
            size: 22,
            color: cs.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: cs.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
