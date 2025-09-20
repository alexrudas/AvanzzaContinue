import 'dart:async';

import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/data/models/geo/city_model.dart';
import 'package:avanzza/data/models/geo/country_model.dart';
import 'package:avanzza/data/models/geo/local_regulation_model.dart';
import 'package:avanzza/data/models/geo/region_model.dart';
import 'package:avanzza/data/sources/local/geo_local_ds.dart';
import 'package:avanzza/data/sources/remote/geo_remote_ds.dart';

import '../../../domain/entities/geo/city_entity.dart';
import '../../../domain/entities/geo/country_entity.dart';
import '../../../domain/entities/geo/local_regulation_entity.dart';
import '../../../domain/entities/geo/region_entity.dart';
import '../../../domain/repositories/geo_repository.dart';

class GeoRepositoryImpl implements GeoRepository {
  final GeoLocalDataSource local;
  final GeoRemoteDataSource remote;
  GeoRepositoryImpl({required this.local, required this.remote});

  // Countries
  @override
  Stream<List<CountryEntity>> watchCountries({bool? isActive}) async* {
    final controller = StreamController<List<CountryEntity>>();
    Future(() async {
      final locals = await local.countries(isActive: isActive);
      controller.add(locals.map((e) => e.toEntity()).toList());
      // background sync
      final remotes = await remote.countries(isActive: isActive);
      await _syncCountries(locals, remotes);
      final updated = await local.countries(isActive: isActive);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<CountryEntity>> fetchCountries({bool? isActive}) async {
    final locals = await local.countries(isActive: isActive);
    // background sync
    unawaited(() async {
      final remotes = await remote.countries(isActive: isActive);
      await _syncCountries(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncCountries(
      List<CountryModel> locals, List<CountryModel> remotes) async {
    final mapLocal = {for (final c in locals) c.id: c};
    for (final r in remotes) {
      final l = mapLocal[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertCountry(r);
      }
    }
  }

  @override
  Stream<CountryEntity?> watchCountry(String id) async* {
    final controller = StreamController<CountryEntity?>();
    Future(() async {
      final list = await local.countries();
      controller.add(list
          .firstWhere((e) => e.id == id,
              orElse: () => CountryModel(id: id, name: '', iso3: ''))
          .toEntity());
      final remoteItem = await remote.getCountry(id);
      if (remoteItem != null) {
        await local.upsertCountry(remoteItem);
        final updated = await local.countries();
        controller.add(updated.firstWhere((e) => e.id == id).toEntity());
      }
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<CountryEntity?> getCountry(String id) async {
    final list = await local.countries();
    final found = list.where((e) => e.id == id).toList();
    unawaited(() async {
      final remoteItem = await remote.getCountry(id);
      if (remoteItem != null) await local.upsertCountry(remoteItem);
    }());
    return found.isEmpty ? null : found.first.toEntity();
  }

  @override
  Future<void> upsertCountry(CountryEntity country) async {
    final model = CountryModel.fromEntity(country.copyWith(
        updatedAt: country.updatedAt ?? DateTime.now().toUtc()));
    await local.upsertCountry(model);
    try {
      await remote.upsertCountry(model);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertCountry(model));
    }
  }

  // Regions
  @override
  Stream<List<RegionEntity>> watchRegions(
      {required String countryId, bool? isActive}) async* {
    final controller = StreamController<List<RegionEntity>>();
    Future(() async {
      final locals =
          await local.regions(countryId: countryId, isActive: isActive);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.regions(countryId: countryId, isActive: isActive);
      await _syncRegions(locals, remotes);
      final updated =
          await local.regions(countryId: countryId, isActive: isActive);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<RegionEntity>> fetchRegions(
      {required String countryId, bool? isActive}) async {
    final locals =
        await local.regions(countryId: countryId, isActive: isActive);
    unawaited(() async {
      final remotes =
          await remote.regions(countryId: countryId, isActive: isActive);
      await _syncRegions(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncRegions(
      List<RegionModel> locals, List<RegionModel> remotes) async {
    final mapLocal = {for (final c in locals) c.id: c};
    for (final r in remotes) {
      final l = mapLocal[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertRegion(r);
      }
    }
  }

  @override
  Stream<RegionEntity?> watchRegion(String id) async* {
    final controller = StreamController<RegionEntity?>();
    Future(() async {
      final locals = await local.regions(countryId: '');
      final l = locals.where((e) => e.id == id).toList();
      controller.add(l.isEmpty ? null : l.first.toEntity());
      final r = await remote.getRegion(id);
      if (r != null) {
        await local.upsertRegion(r);
        final updated = await local.regions(countryId: r.countryId);
        controller.add(updated.firstWhere((e) => e.id == id).toEntity());
      }
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<RegionEntity?> getRegion(String id) async {
    final locals = await local.regions(countryId: '');
    final l = locals.where((e) => e.id == id).toList();
    unawaited(() async {
      final r = await remote.getRegion(id);
      if (r != null) await local.upsertRegion(r);
    }());
    return l.isEmpty ? null : l.first.toEntity();
  }

  @override
  Future<void> upsertRegion(RegionEntity region) async {
    final m = RegionModel.fromEntity(
        region.copyWith(updatedAt: region.updatedAt ?? DateTime.now().toUtc()));
    await local.upsertRegion(m);
    try {
      await remote.upsertRegion(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertRegion(m));
    }
  }

  // Cities
  @override
  Stream<List<CityEntity>> watchCities(
      {required String countryId, String? regionId, bool? isActive}) async* {
    final controller = StreamController<List<CityEntity>>();
    Future(() async {
      final locals = await local.cities(
          countryId: countryId, regionId: regionId, isActive: isActive);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes = await remote.cities(
          countryId: countryId, regionId: regionId, isActive: isActive);
      await _syncCities(locals, remotes);
      final updated = await local.cities(
          countryId: countryId, regionId: regionId, isActive: isActive);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<CityEntity>> fetchCities(
      {required String countryId, String? regionId, bool? isActive}) async {
    final locals = await local.cities(
        countryId: countryId, regionId: regionId, isActive: isActive);
    unawaited(() async {
      final remotes = await remote.cities(
          countryId: countryId, regionId: regionId, isActive: isActive);
      await _syncCities(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncCities(
      List<CityModel> locals, List<CityModel> remotes) async {
    final mapLocal = {for (final c in locals) c.id: c};
    for (final r in remotes) {
      final l = mapLocal[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertCity(r);
      }
    }
  }

  // Local Regulations
  @override
  Stream<List<LocalRegulationEntity>> watchLocalRegulations(
      {String? countryId, String? cityId}) async* {
    final controller = StreamController<List<LocalRegulationEntity>>();
    Future(() async {
      final locals =
          await local.localRegulations(countryId: countryId, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.localRegulations(countryId: countryId, cityId: cityId);
      await _syncRegs(locals, remotes);
      final updated =
          await local.localRegulations(countryId: countryId, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<LocalRegulationEntity>> fetchLocalRegulations(
      {String? countryId, String? cityId}) async {
    final locals =
        await local.localRegulations(countryId: countryId, cityId: cityId);
    unawaited(() async {
      final remotes =
          await remote.localRegulations(countryId: countryId, cityId: cityId);
      await _syncRegs(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncRegs(List<LocalRegulationModel> locals,
      List<LocalRegulationModel> remotes) async {
    final mapLocal = {for (final c in locals) c.id: c};
    for (final r in remotes) {
      final l = mapLocal[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertLocalRegulation(r);
      }
    }
  }

  @override
  Stream<LocalRegulationEntity?> watchLocalRegulation(String id) async* {
    final controller = StreamController<LocalRegulationEntity?>();
    Future(() async {
      final locals = await local.localRegulations();
      final l = locals.where((e) => e.id == id).toList();
      controller.add(l.isEmpty ? null : l.first.toEntity());
      final r = await remote.getLocalRegulation(id);
      if (r != null) {
        await local.upsertLocalRegulation(r);
        final updated = await local.localRegulations();
        controller.add(updated.firstWhere((e) => e.id == id).toEntity());
      }
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<LocalRegulationEntity?> getLocalRegulation(String id) async {
    final locals = await local.localRegulations();
    final l = locals.where((e) => e.id == id).toList();
    unawaited(() async {
      final r = await remote.getLocalRegulation(id);
      if (r != null) await local.upsertLocalRegulation(r);
    }());
    return l.isEmpty ? null : l.first.toEntity();
  }

  @override
  Future<void> upsertLocalRegulation(LocalRegulationEntity regulation) async {
    final m = LocalRegulationModel.fromEntity(regulation.copyWith(
        updatedAt: regulation.updatedAt ?? DateTime.now().toUtc()));
    await local.upsertLocalRegulation(m);
    try {
      await remote.upsertLocalRegulation(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertLocalRegulation(m));
    }
  }

  @override
  Future<CityEntity?> getCity(String id) async {
    // 1) Lee local
    final locals =
        await local.cities(countryId: '', regionId: null, isActive: null);
    final l = locals.where((e) => e.id == id).toList();

    // 2) Sincroniza en background
    unawaited(() async {
      final r = await remote.getCity(id);
      if (r != null) {
        await local.upsertCity(r);
      }
    }());

    // 3) Devuelve lo que haya localmente
    return l.isEmpty ? null : l.first.toEntity();
  }

  @override
  Future<void> upsertCity(CityEntity city) async {
    final m = CityModel.fromEntity(
      city.copyWith(updatedAt: city.updatedAt ?? DateTime.now().toUtc()),
    );
    // write-through
    await local.upsertCity(m);
    try {
      await remote.upsertCity(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertCity(m));
    }
  }

  @override
  Stream<CityEntity?> watchCity(String id) async* {
    final controller = StreamController<CityEntity?>();
    Future(() async {
      try {
        // 1) Emite valor local (si existe)
        final locals =
            await local.cities(countryId: '', regionId: null, isActive: null);
        final l = locals.where((e) => e.id == id).toList();
        controller.add(l.isEmpty ? null : l.first.toEntity());

        // 2) Trae remoto y sincroniza; luego vuelve a emitir
        final r = await remote.getCity(id);
        if (r != null) {
          await local.upsertCity(r);
          final updated =
              await local.cities(countryId: '', regionId: null, isActive: null);
          final u = updated.where((e) => e.id == id).toList();
          controller.add(u.isEmpty ? null : u.first.toEntity());
        }
      } catch (_) {
        // opcional: log
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }
}
