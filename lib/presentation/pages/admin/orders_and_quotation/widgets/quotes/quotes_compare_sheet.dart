/// Modal comparador de respuestas de cotizaciones ordenadas por precio.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quote_request_card.dart';

class QuotesCompareSheet extends StatelessWidget {
  final List<StoreReply> responded;
  const QuotesCompareSheet({super.key, required this.responded});

  @override
  Widget build(BuildContext context) {
    final data = [...responded]..sort((a, b) =>
        (a.price ?? double.infinity).compareTo(b.price ?? double.infinity));
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Text('Comparador de cotizaciones',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))
        ]),
        const Divider(),
        const Row(children: [
          Expanded(
              child: Text('Tienda',
                  style: TextStyle(fontWeight: FontWeight.w700))),
          SizedBox(
              width: 100,
              child: Text('Precio',
                  style: TextStyle(fontWeight: FontWeight.w700))),
          SizedBox(
              width: 90,
              child: Text('Entrega',
                  style: TextStyle(fontWeight: FontWeight.w700))),
          SizedBox(
              width: 60,
              child:
                  Text('ETA', style: TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const Divider(),
        ...data.map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Expanded(child: Text(s.name)),
                SizedBox(
                    width: 100,
                    child: Text(s.price == null
                        ? '-'
                        : '\$${s.price!.toStringAsFixed(0)}')),
                SizedBox(
                    width: 90,
                    child: Row(children: [
                      Icon(
                          s.delivery == DeliveryType.home
                              ? Icons.local_shipping
                              : Icons.storefront,
                          size: 18),
                      const SizedBox(width: 4),
                      Text(s.delivery == DeliveryType.home
                          ? 'Domicilio'
                          : 'Tienda'),
                    ])),
                SizedBox(
                    width: 60,
                    child: Text(s.etaDays == null ? '-' : '${s.etaDays} d',
                        textAlign: TextAlign.end)),
              ]),
            )),
      ]),
    ));
  }
}