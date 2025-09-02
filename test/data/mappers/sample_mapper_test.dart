import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/domain/entities/asset/asset_entity.dart' as domain;
import 'package:avanzza/data/models/asset/asset_model.dart' as model;

void main() {
  test('Asset entity <-> model mapping', () {
    final e = domain.AssetEntity(
      id: 'a1',
      orgId: 'org1',
      assetType: 'vehiculo',
      countryId: 'CO',
      regionId: 'cund',
      cityId: 'bog',
      ownerType: 'org',
      ownerId: 'org1',
      estado: 'activo',
      etiquetas: const ['x'],
      fotosUrls: const [],
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 2),
    );

    final m = model.AssetModel.fromEntity(e);
    final roundtrip = m.toEntity();

    expect(roundtrip.id, e.id);
    expect(roundtrip.orgId, e.orgId);
    expect(roundtrip.assetType, e.assetType);
    expect(roundtrip.countryId, e.countryId);
    expect(roundtrip.cityId, e.cityId);
    expect(roundtrip.ownerId, e.ownerId);
    expect(roundtrip.estado, e.estado);
    expect(roundtrip.etiquetas, e.etiquetas);
    expect(roundtrip.fotosUrls, e.fotosUrls);
  });
}
