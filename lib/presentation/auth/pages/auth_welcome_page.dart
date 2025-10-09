import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AuthWelcomePage extends StatelessWidget {
  AuthWelcomePage({super.key}) {
    //seedRegionsAndCitiesCO();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Bienvenido a Avanzza 2.0',
                  style: TextStyle(fontSize: 22)),
              const SizedBox(height: 24),
              // Login con username + password
              ElevatedButton(
                onPressed: () => Get.toNamed(Routes.loginUserPass),
                child: const Text('Iniciar sesión (usuario + contraseña)'),
              ),
              const SizedBox(height: 12),
              // Login/registro con teléfono (flujo OTP existente como fallback)
              OutlinedButton(
                onPressed: () => Get.toNamed(Routes.phone),
                child: const Text('Usar teléfono (OTP)'),
              ),
              const SizedBox(height: 24),
              // Registro (wizard)
              TextButton(
                onPressed: () => Get.toNamed(Routes.registerUsername),
                child: const Text('Crear cuenta (wizard)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ejecuta una sola vez desde un flujo de admin:
/// await seedRegionsAndCitiesCO();
Future<void> seedRegionsAndCitiesCO() async {
  final fs = FirebaseFirestore.instance;

  // 1) Cargar JSON
  final regionsJsonStr =
      await rootBundle.loadString('assets/regions_entities_co.json');
  final citiesJsonStr =
      await rootBundle.loadString('assets/cities_entities_co.json');

  final List regions = jsonDecode(regionsJsonStr) as List;
  final List cities = jsonDecode(citiesJsonStr) as List;

  // 2) Helper batch (límite seguro)
  Future<void> commitInChunks(
    List<MapEntry<DocumentReference, Map<String, dynamic>>> ops,
  ) async {
    const maxPerBatch = 450;
    for (var i = 0; i < ops.length; i += maxPerBatch) {
      final chunk = ops.sublist(i, (i + maxPerBatch).clamp(0, ops.length));
      final batch = fs.batch();
      for (final e in chunk) {
        batch.set(
          e.key,
          {
            ...e.value,
            'updatedAt': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }
      await batch.commit();
    }
  }

  // 3) Regions -> collection('regions')
  final regionOps = <MapEntry<DocumentReference, Map<String, dynamic>>>[];
  for (final r in regions) {
    final id = r['id'] as String; // ej: "CO-ANT" / "CO-DC"
    final data = <String, dynamic>{
      'id': id,
      'countryId': r['countryId'] ?? 'CO',
      'name': r['name'],
      'code': r['code'], // ISO-3166-2 o null
      'isActive': r['isActive'] ?? true,
    };
    regionOps.add(MapEntry(fs.collection('regions').doc(id), data));
  }

  // 4) Cities -> collection('cities')
  // JSON ya viene con id = "CO-REGION-CIUDAD" y regionId = "CO-REGION"
  final cityOps = <MapEntry<DocumentReference, Map<String, dynamic>>>[];
  for (final c in cities) {
    final regionId = c['regionId'] as String; // ej: "CO-ANT"
    final countryId = regionId.split('-').first; // "CO"
    final data = <String, dynamic>{
      'id': c['id'], // ej: "CO-ANT-MEDELLIN"
      'countryId': countryId,
      'regionId': regionId,
      'name': c['name'],
      'lat': c['lat'],
      'lng': c['lng'],
      'timezoneOverride': c['timezoneOverride'],
      'isActive': c['isActive'] ?? true,
    };
    cityOps.add(MapEntry(fs.collection('cities').doc(c['id']), data));
  }

  // 5) Ejecutar
  await commitInChunks(regionOps);
  await commitInChunks(cityOps);
}
