import 'package:flutter/material.dart';

class SelectCountryCityPage extends StatelessWidget {
  const SelectCountryCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder UI; wiring to controller/usecases can be added after repositories provide geo lists
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona país y ciudad')),
      body: const Center(child: Text('Seleccionar país/ciudad')),
    );
  }
}
