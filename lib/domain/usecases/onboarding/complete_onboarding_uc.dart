// ============================================================================
// lib/domain/usecases/onboarding/complete_onboarding_uc.dart
// CompleteOnboardingUC — bootstrap del primer Workspace al cerrar onboarding.
// ============================================================================
// QUÉ HACE:
//   - Crea Organization + Membership + Portfolio (condicional) a partir
//     del estado capturado en Q3/Q4 del flujo demo.
//   - Usa `mapIntentToCanonical` para derivar capabilityProfiles +
//     expectedRelationKind + shellMode.
//   - Asigna SIEMPRE [MembershipRole.admin] al fundador (regla canónica).
//   - Marca isOwner=true en la membership (BYPASS DE FUNDADOR — capa de
//     policy lo respeta independientemente de los roles).
//   - Es IDEMPOTENTE: si el usuario ya tiene memberships, hidrata los
//     existentes en lugar de crear duplicados.
//   - Emite warnings del mapper vía
//     [LegacyMembershipMigrationTelemetry.recordIntentMappingWarning] si
//     existen (best-effort, never throws).
//
// QUÉ NO HACE:
//   - NO crea AssetActorLink. La relación con activos concretos la
//     materializa VRC al añadir el primer asset, usando
//     `Portfolio.expectedRelationKind` como hint.
//   - NO navega. Retorna el resultado y el caller decide la ruta.
//   - NO escribe en Membership.roles valores derivados del intent. Solo
//     el rol del fundador (`admin`) — los demás roles se añaden en
//     flujos posteriores (invitaciones, etc.).
//   - NO valida la existencia de los FKs externos (BusinessCategoryRef,
//     etc.). Eso es responsabilidad de los registries en boundary.
//
// CONDICIONES PARA CREAR PORTFOLIO:
//   - state.assetType != null
//   - state.role ∈ {owner, assetAdmin, renter}
//
//   Si el role es provider/advisor/broker/legal/insurer, el workspace
//   nace SIN Portfolio (su rol es ofrecer al mercado, no mantener
//   activos propios).
//
// PRINCIPIOS:
//   - Repos inyectados (testeable con fakes).
//   - Generador de IDs inyectable (deterministic en tests).
//   - Persistencia delegada a los repos (que internamente siguen
//     offline-first via syncService).
//   - Errores propagados (throw): el caller maneja.
// ============================================================================

import 'package:uuid/uuid.dart';

import '../../../presentation/demo_registration_v2/demo_state.dart';
import '../../../core/telemetry/legacy_membership_migration_telemetry.dart';
import '../../entities/org/organization_entity.dart';
import '../../entities/portfolio/portfolio_entity.dart';
import '../../entities/user/active_context.dart';
import '../../entities/user/membership_entity.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/org_repository.dart';
import '../../repositories/portfolio_repository.dart';
import '../../repositories/user_repository.dart';
import '../../services/onboarding/map_intent_to_canonical.dart';
import '../../services/onboarding/map_shell_mode.dart';
import '../../shared/enums/asset_type.dart';
import '../../value/membership_role.dart';
import '../../value/membership_scope.dart';
import 'workspace_bootstrap_result.dart';

class CompleteOnboardingUC {
  final OrgRepository orgRepository;
  final UserRepository userRepository;
  final PortfolioRepository portfolioRepository;

  /// Generador de IDs. Inyectable en tests para producir IDs deterministas.
  /// Default: uuid v4.
  final String Function() _idGenerator;

  /// Reloj inyectable para tests (controlled time). Default: DateTime.now().toUtc().
  final DateTime Function() _clock;

  CompleteOnboardingUC({
    required this.orgRepository,
    required this.userRepository,
    required this.portfolioRepository,
    String Function()? idGenerator,
    DateTime Function()? clock,
  })  : _idGenerator = idGenerator ?? _defaultIdGenerator,
        _clock = clock ?? _defaultClock;

  static String _defaultIdGenerator() => const Uuid().v4();
  static DateTime _defaultClock() => DateTime.now().toUtc();

  /// Ejecuta el bootstrap del primer workspace.
  ///
  /// - Throws si `state.role == null` (mapper interno) o si los repos
  ///   propagan errores de persistencia.
  /// - Idempotente: si el usuario ya tiene memberships, retorna hidratando
  ///   los existentes (con `fromExisting: true`).
  Future<WorkspaceBootstrapResult> execute({
    required String userId,
    required DemoRegistrationState state,
  }) async {
    // ── 1. Idempotencia ──────────────────────────────────────────────────
    final existing = await userRepository.fetchMemberships(userId);
    if (existing.isNotEmpty) {
      final m = existing.first;
      final org = await orgRepository.getOrg(m.orgId);
      if (org != null) {
        final portfolios =
            await portfolioRepository.getActivePortfoliosByOrg(m.orgId);
        final portfolio = portfolios.isNotEmpty ? portfolios.first : null;
        final shellMode = mapShellMode(
          capabilityProfiles: org.capabilityProfiles,
          expectedRelationKind: portfolio?.expectedRelationKind,
        );
        // GUARDRAIL DE HIDRATACIÓN: el UserModel local (con activeContext.orgId)
        // es lo que `SessionContextController.init(uid)` necesita para pasar
        // Gate 2 del splash. Sin esto, un usuario que YA tiene memberships
        // pero cuyo UserModel se borró (cache wipe, reinstall, schema reset)
        // queda atrapado en `authOkProfileEmpty` → countryCity. Hidratamos
        // siempre — `upsertUser` es last-write-wins.
        await _ensureLocalUserModel(
          userId: userId,
          org: org,
          state: state,
          now: _clock(),
        );
        return WorkspaceBootstrapResult(
          organization: org,
          membership: m,
          portfolio: portfolio,
          shellMode: shellMode,
          fromExisting: true,
        );
      }
      // Edge case: membership huérfana (org no encontrada). Caemos a
      // creación fresca.
    }

    // ── 2. Mapear intent ────────────────────────────────────────────────
    final mapping = mapIntentToCanonical(state);

    // ── 3. Resolver tipo (Q4) ───────────────────────────────────────────
    final tipo = state.titularType == DemoTitularType.empresa
        ? 'empresa'
        : 'personal';

    // ── 4. Crear Organization ───────────────────────────────────────────
    final orgId = _idGenerator();
    final now = _clock();
    final nitTrimmed = state.nit.trim();
    final nameTrimmed = state.fullNameOrCompany.trim();
    final org = OrganizationEntity(
      id: orgId,
      nombre: nameTrimmed,
      tipo: tipo,
      countryId: state.countryCode,
      regionId: state.regionId,
      cityId: state.cityId,
      ownerUid: userId,
      nitOrTaxId: nitTrimmed.isEmpty ? null : nitTrimmed,
      capabilityProfiles: mapping.capabilityProfiles,
      metadata: <String, dynamic>{
        'createdFromOnboarding': true,
        'onboardingIntent': state.role!.name,
        'titularType': state.titularType.name,
      },
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    await orgRepository.upsertOrg(org);

    // ── 5. Crear Membership (fundador) ──────────────────────────────────
    final membership = MembershipEntity(
      userId: userId,
      orgId: orgId,
      orgName: org.nombre,
      roles: <String>[MembershipRole.admin.wireName],
      estatus: 'activo',
      primaryLocation: <String, String>{
        'countryId': state.countryCode,
        if (state.regionId != null) 'regionId': state.regionId!,
        if (state.cityId != null) 'cityId': state.cityId!,
      },
      // BYPASS DE FUNDADOR — DOS CAMPOS DISTINTOS, NO SINÓNIMOS:
      //
      //   1. `isOwner: true` — IDENTIDAD: el creador del workspace.
      //      Es el BYPASS CANÓNICO consultado por `MembershipPolicy`
      //      (hasAdminAccess y futuros canAccessAsset). Independiente
      //      de roles, scope, capabilities. Si el fundador pierde
      //      todo lo demás, isOwner sigue garantizando acceso.
      //
      //   2. `scope: MembershipScope.global()` — ALCANCE: representación
      //      de "puede acceder a todos los assets de la org". Coherente
      //      con la realidad del fundador, pero NO es bypass por sí
      //      mismo. La policy NUNCA debe usar scope=global como
      //      sinónimo de isFounder.
      //
      // Ambos se persisten para que la representación del fundador sea
      // correcta. La policy decide consultando isOwner PRIMERO (regla
      // canónica documentada en MembershipPolicy).
      scope: MembershipScope.global(),
      isOwner: true,
      createdAt: now,
      updatedAt: now,
    );
    await userRepository.upsertMembership(membership);

    // ── 5b. UserModel local (para SessionContextController) ─────────────
    // Sin este upsert el splash Gate 2 ve `authOkProfileEmpty` y manda al
    // usuario a `Routes.countryCity` (legacy). El UserModel debe contener
    // `activeContext.orgId` para que la sesión se considere "lista".
    await _ensureLocalUserModel(
      userId: userId,
      org: org,
      state: state,
      now: now,
    );

    // ── 6. Portfolio condicional ────────────────────────────────────────
    PortfolioEntity? portfolio;
    final demoAssetType = state.assetType;
    if (demoAssetType != null && _shouldCreatePortfolio(state.role!)) {
      final canonical = _toCanonicalAssetType(demoAssetType);
      final portfolioId = _idGenerator();

      // Blindaje contra IDs geo corruptos. Los selectores de UI
      // (LocationController + BottomSheetSelector) garantizan IDs canónicos
      // del catálogo Isar (formato `<COUNTRY>-<REGION>-<CITY>`, ej.
      // 'CO-ANT-MEDELLIN'). Este assert detecta en debug si algún path
      // alternativo (deep-link, restauración de borrador, futura import)
      // inyecta un cityId fuera del catálogo. En release el assert se
      // elimina por completo — el campo se persiste tal cual y un mismatch
      // queda visible en la query downstream.
      assert(
        state.cityId == null ||
            state.cityId!.isEmpty ||
            state.cityId!.startsWith('${state.countryCode}-'),
        'cityId "${state.cityId}" no respeta el contrato del catálogo geo: '
        'debe iniciar con "${state.countryCode}-" '
        '(formato canónico <COUNTRY>-<REGION>-<CITY>).',
      );

      // STATUS = ACTIVE (no DRAFT) — DEUDA RETIRADA (2026-05).
      //
      // El portfolio default se crea como contenedor técnico INVISIBLE para
      // el usuario; el workspace abre aunque tenga 0 activos. Bajo el
      // modelo viejo se creaba en DRAFT y solo pasaba a ACTIVE al registrar
      // el primer activo, lo que dejaba al usuario atrapado en el wizard
      // legacy `createPortfolioStep1` si bailaba antes del primer registro.
      //
      // Hoy ACTIVE desde el nacimiento: el shell muestra empty-state con
      // CTA "Registrar activo" si `assetsCount==0`, sin dependencia del
      // status. La auto-transición DRAFT→ACTIVE en `incrementAssetsCountTx`
      // queda como no-op para portfolios nuevos y preserva compatibilidad
      // con datos viejos que sigan en DRAFT.
      portfolio = PortfolioEntity(
        id: portfolioId,
        portfolioType: canonical.portfolioType,
        portfolioName: canonical.suggestedPortfolioName,
        countryId: state.countryCode,
        cityId: state.cityId ?? '',
        orgId: orgId,
        status: PortfolioStatus.active,
        assetsCount: 0,
        createdBy: userId,
        expectedRelationKind: mapping.expectedRelationKind,
        createdAt: now,
        updatedAt: now,
      );
      await portfolioRepository.createPortfolio(portfolio);
    }

    // ── 7. Emitir warnings del mapper (best-effort) ─────────────────────
    if (mapping.hasWarnings) {
      LegacyMembershipMigrationTelemetry.recordIntentMappingWarning(
        warnings: mapping.warnings
            .map((w) => w.toMap())
            .toList(growable: false),
        orgId: orgId,
        membershipId: '$userId@$orgId',
      );
    }

    // ── 8. Retornar ─────────────────────────────────────────────────────
    return WorkspaceBootstrapResult(
      organization: org,
      membership: membership,
      portfolio: portfolio,
      shellMode: mapping.shellMode,
      warnings: List.unmodifiable(mapping.warnings),
      fromExisting: false,
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // HELPERS PRIVADOS
  // ─────────────────────────────────────────────────────────────────────

  static bool _shouldCreatePortfolio(DemoRoleCode role) {
    return role == DemoRoleCode.owner ||
        role == DemoRoleCode.assetAdmin ||
        role == DemoRoleCode.renter;
  }

  /// Persiste/actualiza el UserModel local con `activeContext.orgId`. Es el
  /// modelo que `SessionContextController.init(uid)` consulta para decidir
  /// `hydrationState`. La ausencia de este modelo es lo que hace que el
  /// splash Gate 2 se quede en `authOkProfileEmpty` y mande al usuario al
  /// flow legacy de país/ciudad.
  ///
  /// Idempotente: el repo aplica last-write-wins. No leemos el UserEntity
  /// previo (de existir) porque los campos relevantes para Gate 2 son los
  /// que aquí escribimos; otros campos (addresses, tipoDoc, etc.) no se
  /// capturan en FusionadoFlow y deben permanecer `null` hasta que el
  /// flujo correspondiente los pueble.
  Future<void> _ensureLocalUserModel({
    required String userId,
    required OrganizationEntity org,
    required DemoRegistrationState state,
    required DateTime now,
  }) async {
    final activeCtx = ActiveContext(
      orgId: org.id,
      orgName: org.nombre,
      // KILL SWITCH ROL LEGACY (alineado con RegistrationController.finalize):
      // el `rol` UI se deriva de capabilities + isProvider en runtime, no de
      // este string. Mantener vacío para no contradecir el contrato.
      rol: '',
    );
    final userEntity = UserEntity(
      uid: userId,
      name: state.fullNameOrCompany.trim(),
      email: '',
      phone: state.phone.isNotEmpty ? state.phone : null,
      countryId: state.countryCode,
      activeContext: activeCtx,
      createdAt: now,
      updatedAt: now,
    );
    await userRepository.upsertUser(userEntity);
  }

  static AssetRegistrationType _toCanonicalAssetType(DemoAssetType t) {
    switch (t) {
      case DemoAssetType.vehiculo:
        return AssetRegistrationType.vehiculo;
      case DemoAssetType.inmueble:
        return AssetRegistrationType.inmueble;
      case DemoAssetType.maquinaria:
        return AssetRegistrationType.maquinaria;
      case DemoAssetType.equipo:
        return AssetRegistrationType.equipo;
      case DemoAssetType.otro:
        return AssetRegistrationType.otro;
    }
  }
}
