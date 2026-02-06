/// Modal con el detalle completo de una cotización.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quote_request_card.dart';

class QuoteDetailsSheet extends StatelessWidget {
  final String title, subtitle;
  final String assetType, assetID, assetDescription;
  final List<String> items;
  final List<StoreReply> stores;
  const QuoteDetailsSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetType,
    required this.assetID,
    required this.assetDescription,
    required this.items,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      child: ListView(children: [
        Row(children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))
        ]),
        Text(subtitle,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.black54)),
        const Divider(height: 24),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(assetType,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text('ID $assetID',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 4),
              Text(assetDescription),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text('Descripción',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        ...items.toList().asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('${e.key + 1}. ${e.value}'))),
        const Divider(height: 24),
        Text('Tiendas',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        ...stores.map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Expanded(
                    child: Text(s.name,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                if (s.price != null)
                  Text('\$${s.price!.toStringAsFixed(0)}   ',
                      style: const TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()])),
                if (s.etaDays != null) Text('${s.etaDays} días'),
              ]),
            ))
      ]),
    ));
  }
}
