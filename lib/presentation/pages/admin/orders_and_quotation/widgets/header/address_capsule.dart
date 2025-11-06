/// Cápsula de dirección con ícono de ubicación, clickeable.
library;

import 'package:flutter/material.dart';

class AddressCapsule extends StatelessWidget {
  final String address;
  final VoidCallback onTap;
  const AddressCapsule({super.key, required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.location_on_outlined, size: 16),
          const SizedBox(width: 4),
          Text(address, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
