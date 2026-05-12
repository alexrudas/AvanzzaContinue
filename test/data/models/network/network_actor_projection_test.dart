import 'dart:convert';

import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:avanzza/data/models/network/network_actor_projection.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Construye un NetworkActorSummaryDto desde un JSON parcial sobre defaults
/// "sanos" (no restringido, contactos presentes, una sola categoría).
NetworkActorSummaryDto _makeNetworkDto({
  String ref = 'platform:11111111-2222-3333-4444-555555555555',
  String? displayName = 'Peña Motors',
  String? avatarRef,
  bool unresolved = false,
  List<String> categories = const ['workshop'],
  String primaryCategory = 'workshop',
  bool isTeamMember = false,
  bool isRestricted = false,
  String? restrictionReason,
  String? primaryPhoneE164 = '+573001234567',
  String? primaryEmail = 'peña@autokorea.co',
  bool hasWhatsApp = true,
  String relationshipState = 'vinculada',
  String? providerProfileId = 'prov-abc-123',
  List<Map<String, dynamic>> availableActions = const [
    {'type': 'call', 'enabled': true},
    {'type': 'whatsapp', 'enabled': true},
  ],
  List<String> sectionKeys = const ['services_and_workshops'],
  String? updatedAt,
}) {
  return NetworkActorSummaryDto.fromJson({
    'ref': ref,
    'displayName': displayName,
    'avatarRef': avatarRef,
    'unresolved': unresolved,
    'categories': categories,
    'primaryCategory': primaryCategory,
    'isTeamMember': isTeamMember,
    'isRestricted': isRestricted,
    'restrictionReason': restrictionReason,
    'primaryPhoneE164': primaryPhoneE164,
    'primaryEmail': primaryEmail,
    'hasWhatsApp': hasWhatsApp,
    'relationshipState': relationshipState,
    'providerProfileId': providerProfileId,
    'availableActions': availableActions,
    'sectionKeys': sectionKeys,
    'updatedAt': updatedAt ?? '2026-05-10T22:42:42.594870Z',
  });
}

void main() {
  group('NetworkActorProjection.fromSummaryDto — mapeo de campos', () {
    test('campos principales se preservan exactamente', () {
      final dto = _makeNetworkDto(
        ref: 'platform:abc-123',
        displayName: 'Auto Korea S.A.S.',
        avatarRef: 'avatars/auto-korea.png',
        categories: const ['workshop', 'provider'],
        primaryCategory: 'workshop',
        relationshipState: 'vinculada',
        providerProfileId: 'prov-zzz',
        primaryPhoneE164: '+573009998888',
        primaryEmail: 'ventas@autokorea.co',
        hasWhatsApp: false,
      );
      final norm = normalizeForSearch(dto.displayName!);

      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: norm,
      );

      expect(p.actorRefRaw, 'platform:abc-123');
      expect(p.actorRefKind, 'platform');
      expect(p.actorRefId, 'abc-123');
      expect(p.providerProfileId, 'prov-zzz');
      expect(p.displayName, 'Auto Korea S.A.S.');
      expect(p.displayNameNormalized, 'auto korea sas');
      expect(p.avatarRef, 'avatars/auto-korea.png');
      expect(p.primaryCategoryKey, 'workshop');
      expect(p.categoriesAllKeys, ['workshop', 'provider']);
      expect(p.relationshipState, 'vinculada');
      expect(p.isRestricted, isFalse);
      expect(p.restrictionReason, isNull);
      expect(p.primaryPhoneE164, '+573009998888');
      expect(p.primaryEmail, 'ventas@autokorea.co');
      expect(p.hasWhatsApp, isFalse);
      expect(p.updatedAt, DateTime.parse('2026-05-10T22:42:42.594870Z'));
    });

    test('displayName null en DTO se materializa como "" en projection', () {
      final dto = _makeNetworkDto(displayName: null);
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: '',
      );
      expect(p.displayName, '');
      expect(p.displayNameNormalized, '');
    });

    test('actor local: kind="local", id sin prefijo', () {
      final dto = _makeNetworkDto(
        ref: 'local:organization:org-uuid-1',
      );
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      expect(p.actorRefRaw, 'local:organization:org-uuid-1');
      expect(p.actorRefKind, 'local');
      expect(p.actorRefId, 'org-uuid-1');
    });

    test('actor restringido: contactos vienen null por contrato del DTO', () {
      final dto = _makeNetworkDto(
        isRestricted: true,
        restrictionReason: 'suspended',
        primaryPhoneE164: null,
        primaryEmail: null,
      );
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'pena motors',
      );
      expect(p.isRestricted, isTrue);
      expect(p.restrictionReason, 'suspended');
      expect(p.primaryPhoneE164, isNull);
      expect(p.primaryEmail, isNull);
    });

    test('categories preserva orden y contenido del wire', () {
      final dto = _makeNetworkDto(
        categories: const ['workshop', 'provider', 'technician'],
        primaryCategory: 'provider',
      );
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      expect(p.primaryCategoryKey, 'provider');
      expect(p.categoriesAllKeys, ['workshop', 'provider', 'technician']);
    });
  });

  group('NetworkActorProjection — drops explícitos (anti-bloat)', () {
    test('availableActions del DTO NO aparece en projection', () {
      final dto = _makeNetworkDto(
        availableActions: const [
          {'type': 'call', 'enabled': true},
          {'type': 'whatsapp', 'enabled': false, 'reason': 'phone_not_available'},
          {'type': 'email', 'enabled': true},
          {'type': 'request_quote', 'enabled': false, 'reason': 'capability_missing'},
        ],
      );
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      final json = p.toJson();
      expect(json.containsKey('availableActions'), isFalse,
          reason: 'availableActions debe recalcularse en runtime, no cachearse');
      expect(json.containsKey('availableActionsCompact'), isFalse);
    });

    test(
        'sectionKeys del DTO SE PRESERVA en projection (fallback bucketizer)',
        () {
      // CAMBIO V2: sectionKeys debe sobrevivir el round-trip wire → cache
      // local. El bucketizer cae a `sectionKeys` cuando no hay `supplierType`
      // local (actores externos sin LocalContact match). Sin esta info,
      // tales actores caerían en data debt al leer cache offline.
      final dto = _makeNetworkDto(
        sectionKeys: const [
          'services_and_workshops',
          'parts_and_supplies',
          'commercial_advisors',
        ],
      );
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      expect(p.sectionKeys,
          ['services_and_workshops', 'parts_and_supplies', 'commercial_advisors']);
      expect(p.toJson().containsKey('sectionKeys'), isTrue,
          reason: 'sectionKeys debe ir en projectionJson para que el cache '
              'round-trip preserve el fallback wire del bucketizer');
    });

    test('unresolved del DTO NO aparece en projection', () {
      final dto = _makeNetworkDto(unresolved: true);
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      expect(p.toJson().containsKey('unresolved'), isFalse);
    });

    test('isTeamMember del DTO NO aparece en projection', () {
      final dto = _makeNetworkDto(isTeamMember: true);
      final p = NetworkActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      expect(p.toJson().containsKey('isTeamMember'), isFalse);
    });
  });

  group('NetworkActorProjection.toJson — guardrail de claves permitidas', () {
    // Allowlist: cualquier campo que aparezca en projectionJson debe estar
    // listado aquí. Esta lista es la barrera contra bloat — si alguien añade
    // un campo nuevo, este test FALLA hasta que el campo se justifique y se
    // añada explícitamente al allowlist.
    const allowedKeys = <String>{
      'actorRefRaw',
      'actorRefKind',
      'actorRefId',
      'providerProfileId',
      'displayName',
      'displayNameNormalized',
      'avatarRef',
      'primaryCategoryKey',
      'categoriesAllKeys',
      'relationshipState',
      'isRestricted',
      'restrictionReason',
      'primaryPhoneE164',
      'primaryEmail',
      'hasWhatsApp',
      'updatedAt',
      // V2: añadido para preservar el fallback bucketizer wire en cache.
      'sectionKeys',
    };

    test('toJson solo expone claves del allowlist', () {
      final p = NetworkActorProjection.fromSummaryDto(
        _makeNetworkDto(),
        displayNameNormalized: 'pena motors',
      );
      final keys = p.toJson().keys.toSet();
      final unexpected = keys.difference(allowedKeys);
      expect(
        unexpected,
        isEmpty,
        reason: 'Claves no aprobadas detectadas en projectionJson: $unexpected',
      );
    });

    test('cada clave del allowlist aparece en toJson (no missing)', () {
      final p = NetworkActorProjection.fromSummaryDto(
        _makeNetworkDto(),
        displayNameNormalized: 'pena motors',
      );
      final keys = p.toJson().keys.toSet();
      final missing = allowedKeys.difference(keys);
      expect(missing, isEmpty,
          reason: 'Claves del contrato faltan en toJson: $missing');
    });

    test('cardinalidad exacta del allowlist (catálogo cerrado)', () {
      expect(allowedKeys.length, 17,
          reason: 'Si añades/quitas un campo, actualiza la cardinalidad y '
              'justifica el cambio en el doc-comment del invariante. V2 '
              'subió de 16 a 17 al añadir sectionKeys (fallback bucketizer).');
    });
  });

  group('NetworkActorProjection — JSON codec roundtrip', () {
    test('projection → json → projection preserva todos los campos', () {
      final original = NetworkActorProjection.fromSummaryDto(
        _makeNetworkDto(
          ref: 'platform:abc-123',
          displayName: 'Niño Repuestos',
          categories: const ['workshop', 'provider'],
          primaryCategory: 'provider',
          isRestricted: true,
          restrictionReason: 'closed',
          primaryPhoneE164: null,
          primaryEmail: null,
          hasWhatsApp: false,
        ),
        displayNameNormalized: 'nino repuestos',
      );

      final json = original.toJson();
      final encoded = jsonEncode(json);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      final roundtripped = NetworkActorProjection.fromJson(decoded);

      expect(roundtripped.actorRefRaw, original.actorRefRaw);
      expect(roundtripped.actorRefKind, original.actorRefKind);
      expect(roundtripped.actorRefId, original.actorRefId);
      expect(roundtripped.providerProfileId, original.providerProfileId);
      expect(roundtripped.displayName, original.displayName);
      expect(roundtripped.displayNameNormalized, original.displayNameNormalized);
      expect(roundtripped.avatarRef, original.avatarRef);
      expect(roundtripped.primaryCategoryKey, original.primaryCategoryKey);
      expect(roundtripped.categoriesAllKeys, original.categoriesAllKeys);
      expect(roundtripped.relationshipState, original.relationshipState);
      expect(roundtripped.isRestricted, original.isRestricted);
      expect(roundtripped.restrictionReason, original.restrictionReason);
      expect(roundtripped.primaryPhoneE164, original.primaryPhoneE164);
      expect(roundtripped.primaryEmail, original.primaryEmail);
      expect(roundtripped.hasWhatsApp, original.hasWhatsApp);
      expect(
        roundtripped.updatedAt.toUtc(),
        original.updatedAt.toUtc(),
      );
      expect(roundtripped.sectionKeys, original.sectionKeys,
          reason: 'sectionKeys debe sobrevivir el round-trip para que el '
              'fallback bucketizer funcione tras leer del cache local');
    });

    test('roundtrip con valores null sobrevive', () {
      final original = NetworkActorProjection.fromSummaryDto(
        _makeNetworkDto(
          providerProfileId: null,
          avatarRef: null,
          displayName: null,
        ),
        displayNameNormalized: '',
      );
      final json = jsonDecode(jsonEncode(original.toJson()))
          as Map<String, dynamic>;
      final back = NetworkActorProjection.fromJson(json);
      expect(back.providerProfileId, isNull);
      expect(back.avatarRef, isNull);
      expect(back.displayName, '');
    });
  });

  group('Anti-bloat — tamaño serializado', () {
    test('projection típica serializada < 1 KB', () {
      final p = NetworkActorProjection.fromSummaryDto(
        _makeNetworkDto(),
        displayNameNormalized: 'pena motors',
      );
      final size = jsonEncode(p.toJson()).length;
      expect(size, lessThan(1024),
          reason: 'projectionJson típico debe ser <1 KB; obtenido $size bytes');
    });

    test('projection con varias categorías serializada < 2 KB (hard cap blando)',
        () {
      final p = NetworkActorProjection.fromSummaryDto(
        _makeNetworkDto(
          categories: const [
            'workshop',
            'provider',
            'technician',
            'owner',
            'driver',
            'operator',
            'tenant',
            'legal',
          ],
          primaryCategory: 'provider',
        ),
        displayNameNormalized: 'pena motors',
      );
      final size = jsonEncode(p.toJson()).length;
      expect(size, lessThan(2048),
          reason: 'projectionJson incluso con todas las categorías debe '
              'estar bien por debajo de 2 KB; obtenido $size bytes');
    });
  });

  group('projectionSchemaVersion — constante expuesta', () {
    test('NetworkSectionMetaModel.kCurrentProjectionSchemaVersion = 1', () {
      expect(NetworkSectionMetaModel.kCurrentProjectionSchemaVersion, 1);
    });
  });
}
