import 'package:flutter/material.dart';

enum BottomNavItem { home, maintenance, accounting, purchase, chat }

class BottomNavMeta {
  final String label;
  final IconData icon;
  const BottomNavMeta(this.label, this.icon);
}

const Map<BottomNavItem, BottomNavMeta> _meta = {
  BottomNavItem.home: BottomNavMeta('Home', Icons.home_outlined),
  BottomNavItem.maintenance: BottomNavMeta('Mantenimientos', Icons.build_outlined),
  BottomNavItem.accounting: BottomNavMeta('Contabilidad', Icons.receipt_long_outlined),
  BottomNavItem.purchase: BottomNavMeta('Compras', Icons.shopping_cart_outlined),
  BottomNavItem.chat: BottomNavMeta('Chat', Icons.chat_bubble_outline),
};

List<BottomNavMeta> get bottomNavItems =>
    BottomNavItem.values.map((e) => _meta[e]!).toList();
