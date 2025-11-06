// lib/presentation/tenant/widgets/construction_equipment_card.dart
import 'package:flutter/material.dart';

class ConstructionEquipmentCard extends StatelessWidget {
  final String title;                // p.ej. "Equipo de Construcción"
  final bool inUse;
  final String paidLabel;            // p.ej. "\$2.500.000"
  final String totalReceived;        // p.ej. "8"
  final String returnDateLabel;      // p.ej. "28 de Marzo 2025"
  final String daysToDue;            // p.ej. "23"
  final String damagedCount;         // p.ej. "2"
  final VoidCallback? onViewDetails;
  final VoidCallback? onReport;

  const ConstructionEquipmentCard({
    super.key,
    required this.title,
    required this.inUse,
    required this.paidLabel,
    required this.totalReceived,
    required this.returnDateLabel,
    required this.daysToDue,
    required this.damagedCount,
    this.onViewDetails,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [cs.primary, cs.secondary]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('⚙️', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A))),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Equipos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A), letterSpacing: 1)),
          _Pill(
            label: inUse ? 'En uso' : 'Inactivo',
            bg: inUse ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
            icon: inUse ? Icons.check : Icons.pause_circle_filled,
            iconColor: inUse ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
            textColor: inUse ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
          ),
        ]),
        const SizedBox(height: 16),
        _InfoPaidRow('VALOR PAGADO', paidLabel),
        const SizedBox(height: 16),
        Container(height: 1, color: const Color(0xFFE0E0E0)),
        const SizedBox(height: 16),
        _InfoRow('Total equipos recibidos', totalReceived),
        _InfoRow('Fecha de reintegro', returnDateLabel),
        _InfoRow('Días para vencer', daysToDue, state: _State.warning),
        _InfoRow('Equipos averiados', damagedCount, state: _State.danger),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onViewDetails,
              icon: const Icon(Icons.visibility),
              label: const Text('Ver Detalles'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onReport,
              icon: const Text('⚠️'),
              label: const Text('Reportar'),
            ),
          ),
        ]),
      ]),
    );
  }
}

enum _State { normal, warning, danger }

class _InfoPaidRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoPaidRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF616161))),
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
    ]);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final _State state;

  const _InfoRow(this.label, this.value, {this.state = _State.normal});

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xFF1A1A1A);
    if (state == _State.warning) color = const Color(0xFFFF9800);
    if (state == _State.danger) color = const Color(0xFFFF6B6B);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF616161))),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bg;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  const _Pill({required this.label, required this.bg, required this.icon, required this.iconColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
      ]),
    );
  }
}
