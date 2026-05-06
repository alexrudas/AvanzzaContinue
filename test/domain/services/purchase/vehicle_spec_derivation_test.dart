// ============================================================================
// test/domain/services/purchase/vehicle_spec_derivation_test.dart
// VEHICLE SPEC DERIVATION — tests de lógica pura (Domain)
// ============================================================================

import 'package:avanzza/domain/entities/asset/special/asset_vehiculo_entity.dart';
import 'package:avanzza/domain/services/purchase/vehicle_spec_derivation.dart';
import 'package:flutter_test/flutter_test.dart';

AssetVehiculoEntity _v({
  required String marca,
  required String modelo,
  required int anio,
  String placa = 'ABC000',
  String? line,
  double? displacement,
}) {
  return AssetVehiculoEntity(
    assetId: 'a-$placa',
    refCode: placa,
    placa: placa,
    marca: marca,
    modelo: modelo,
    anio: anio,
    line: line,
    engineDisplacement: displacement,
  );
}

void main() {
  group('VehicleSpecDerivation.fromVehicles', () {
    test('agrupa por marca/modelo/año normalizados (case/trim/colapso)', () {
      final specs = VehicleSpecDerivation.fromVehicles([
        _v(marca: 'Toyota', modelo: 'Hilux', anio: 2022, placa: 'AAA111'),
        _v(marca: 'TOYOTA ', modelo: 'hilux', anio: 2022, placa: 'BBB222'),
        _v(marca: '  toyota', modelo: ' Hilux  ', anio: 2022, placa: 'CCC333'),
      ]);
      expect(specs, hasLength(1));
      expect(specs.single.linkedAssetsCount, 3);
      expect(specs.single.id, 'toyota|hilux|2022');
      expect(specs.single.makeLabel, 'Toyota');
      expect(specs.single.year, 2022);
    });

    test('colapsa espacios internos al agrupar ("Hi  lux" == "Hi lux")', () {
      final specs = VehicleSpecDerivation.fromVehicles([
        _v(marca: 'Kia', modelo: 'Hi  lux', anio: 2022, placa: 'K1'),
        _v(marca: 'Kia', modelo: 'Hi lux', anio: 2022, placa: 'K2'),
      ]);
      expect(specs, hasLength(1));
      expect(specs.single.modelKey, 'hi lux');
    });

    test('descarta vehículos con make/model/año inválidos', () {
      final specs = VehicleSpecDerivation.fromVehicles([
        _v(marca: '', modelo: 'X', anio: 2020, placa: 'P1'),
        _v(marca: 'Hyundai', modelo: '', anio: 2020, placa: 'P2'),
        _v(marca: 'Hyundai', modelo: 'Accent', anio: 0, placa: 'P3'),
        _v(marca: 'Hyundai', modelo: 'Accent', anio: 2020, placa: 'P4'),
      ]);
      expect(specs, hasLength(1));
      expect(specs.single.linkedAssetsCount, 1);
    });

    test('separa años distintos en specs distintas', () {
      final specs = VehicleSpecDerivation.fromVehicles([
        _v(marca: 'Hyundai', modelo: 'Grand i10', anio: 2020, placa: 'A1'),
        _v(marca: 'Hyundai', modelo: 'Grand i10', anio: 2021, placa: 'A2'),
        _v(marca: 'Hyundai', modelo: 'Grand i10', anio: 2021, placa: 'A3'),
      ]);
      expect(specs, hasLength(2));
      final labels = specs.map((s) => s.displayLabel).toList();
      expect(labels, containsAll([
        'Hyundai Grand I10 2021',
        'Hyundai Grand I10 2020',
      ]));
    });

    test('opcional unánime se expone; dispersión → null (no inventa)', () {
      final specs = VehicleSpecDerivation.fromVehicles([
        _v(
            marca: 'Toyota',
            modelo: 'Hilux',
            anio: 2022,
            placa: 'X1',
            line: 'SR',
            displacement: 2400),
        _v(
            marca: 'Toyota',
            modelo: 'Hilux',
            anio: 2022,
            placa: 'X2',
            line: 'SR',
            displacement: 2400),
      ]);
      expect(specs.single.version, 'SR');
      expect(specs.single.engineDisplacementCc, 2400);

      final mixed = VehicleSpecDerivation.fromVehicles([
        _v(marca: 'Toyota', modelo: 'Hilux', anio: 2022, line: 'SR'),
        _v(marca: 'Toyota', modelo: 'Hilux', anio: 2022, line: 'SRV'),
      ]);
      expect(mixed.single.version, isNull);
    });

    test('respeta siglas en labels (BMW no se vuelve Bmw)', () {
      final specs = VehicleSpecDerivation.fromVehicles([
        _v(marca: 'bmw', modelo: 'x3', anio: 2023),
      ]);
      expect(specs.single.makeLabel, 'BMW');
    });
  });
}
