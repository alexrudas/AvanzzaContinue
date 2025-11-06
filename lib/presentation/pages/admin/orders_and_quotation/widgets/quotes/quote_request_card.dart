/// Tarjeta de solicitud de cotización con tiendas, estados y acciones.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/format_helpers.dart';
import 'quote_details_sheet.dart';
import 'quotes_compare_sheet.dart';

enum StoreStatus { pending, answered, expired }

enum DeliveryType { home, pickup }

class StoreReply {
  final String name;
  final StoreStatus status;
  final DeliveryType delivery;
  final double? price;
  final int? etaDays;
  const StoreReply({
    required this.name,
    required this.status,
    required this.delivery,
    this.price,
    this.etaDays,
  });
}

class QuoteRequestCard extends StatelessWidget {
  final int quoteId;
  final String assetType;
  final String assetID;
  final String assetDescription;
  final String subtitle;
  final List<String> items;
  final List<StoreReply> stores;

  const QuoteRequestCard({
    super.key,
    required this.quoteId,
    required this.assetType,
    required this.assetID,
    required this.assetDescription,
    required this.subtitle,
    required this.items,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final answered =
        stores.where((s) => s.status == StoreStatus.answered).toList();
    final total = stores.length;

    final series = 'C${assetKindCode(assetType)}-$quoteId';
    final title = 'Cotización # $series';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.store_mall_directory_outlined),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12)),
            child: Text('${answered.length}/$total respondidas',
                style: const TextStyle(color: Colors.white)),
          ),
        ]),
        Text(subtitle, style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  theme.colorScheme.surfaceContainerHighest.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(assetType,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text(assetID,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 4),
              Text(assetDescription),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                items.length, (i) => Text('${i + 1}. ${items[i]}'))),
        const SizedBox(height: 12),
        StoresBlock(stores: stores),
        const Divider(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OutlinedButton.icon(
              onPressed: answered.isEmpty
                  ? () => Get.snackbar('Comparar', 'Aún no hay respuestas')
                  : () => Get.bottomSheet(
                        QuotesCompareSheet(responded: answered),
                        isScrollControlled: true,
                      ),
              icon: const Icon(Icons.compare_arrows),
              label: const Text('Comparar')),
          const SizedBox(width: 8),
          FilledButton(
              onPressed: () => Get.bottomSheet(
                    QuoteDetailsSheet(
                        title: title,
                        subtitle: subtitle,
                        assetType: assetType,
                        assetID: assetID,
                        assetDescription: assetDescription,
                        items: items,
                        stores: stores),
                    isScrollControlled: true,
                  ),
              child: const Text('Ver')),
        ])
      ]),
    );
  }
}

class StoresBlock extends StatelessWidget {
  final List<StoreReply> stores;
  const StoresBlock({super.key, required this.stores});

  Color _statusColor(StoreStatus s) => switch (s) {
        StoreStatus.answered => const Color(0xFF2F5AFF),
        StoreStatus.expired => const Color(0xFFD32F2F),
        _ => const Color(0xFF9AA0A6)
      };

  IconData _deliveryIcon(DeliveryType d) =>
      d == DeliveryType.pickup ? Icons.storefront : Icons.local_shipping;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiendas',
            style:
                t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        ...stores.toList().asMap().entries.map((e) {
          final s = e.value;
          final color = _statusColor(s.status);
          final icon = _deliveryIcon(s.delivery);
          final text = switch (s.status) {
            StoreStatus.answered => 'Respondida',
            StoreStatus.expired => 'Expirada',
            _ => 'Sin respuesta'
          };
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              SizedBox(width: 16, child: Text('${e.key + 1}')),
              Expanded(
                  child: Text(s.name,
                      style: const TextStyle(fontWeight: FontWeight.w600))),
              Text(text, style: TextStyle(color: color)),
              const SizedBox(width: 8),
              Icon(icon,
                  size: 20,
                  color: s.status == StoreStatus.answered
                      ? color
                      : Colors.black38),
            ]),
          );
        })
      ],
    );
  }
}
