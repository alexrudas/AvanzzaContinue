import 'package:flutter/material.dart';

class SelectRolePage extends StatelessWidget {
  const SelectRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona rol')),
      body: const Center(child: Text('Roles disponibles')),
    );
  }
}
