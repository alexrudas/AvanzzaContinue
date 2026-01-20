// lib/domain/policies/real_policy_context_factory.dart

library;

import 'policy_context_v2.dart';

class ContractData {
  final String userId;
  final String orgId;
  final Role role;
  final LegalStatus legalStatus;
  final ContractStatus contractStatus;
  final DateTime? lastValidatedAt;
  final DateTime? maxOfflineGraceUntil;

  const ContractData({
    required this.userId,
    required this.orgId,
    required this.role,
    required this.legalStatus,
    required this.contractStatus,
    required this.lastValidatedAt,
    required this.maxOfflineGraceUntil,
  });
}

abstract class PolicyContextLocalStore {
  Future<ContractData?> getStoredContext(String userId);
  Future<void> storeContext(ContractData data);
  Future<void> invalidateContext(String userId);
}

abstract class AuthStateProvider {
  String? get currentUserId;
  bool get isAuthenticated;
  bool get isSessionExpired;
}

abstract class NetworkStateProvider {
  bool get isOnline;
}

abstract class ContractRemoteProvider {
  Future<bool> get isAvailable;
  Future<ContractData?> fetchContractData(String userId);
}

class RealPolicyContextFactory {
  final AuthStateProvider _auth;
  final NetworkStateProvider _network;
  final ContractRemoteProvider _remote;
  final PolicyContextLocalStore _local;

  const RealPolicyContextFactory({
    required AuthStateProvider auth,
    required NetworkStateProvider network,
    required ContractRemoteProvider remote,
    required PolicyContextLocalStore local,
  })  : _auth = auth,
        _network = network,
        _remote = remote,
        _local = local;

  Future<PolicyContextV2> build() async {
    // ─────────────────────────────────────────────────────────────────────────
    // PASO 0: RESOLVER AUTH & USER
    // ─────────────────────────────────────────────────────────────────────────
    final userId = _auth.currentUserId;
    if (userId == null) {
      return PolicyContextV2.failSafe(
        reasonCode: ContextReasonCode.userNotAuthenticated,
      );
    }

    final AuthState authState;
    if (_auth.isAuthenticated && !_auth.isSessionExpired) {
      authState = AuthState.authenticated;
    } else if (_auth.isSessionExpired) {
      authState = AuthState.expired;
    } else {
      authState = AuthState.unauthenticated;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PASO 1: OBTENCIÓN DE DATOS (LOCAL VS REMOTE) — LOCAL-FIRST
    // ─────────────────────────────────────────────────────────────────────────
    ContractData? data;
    ContextSource sourceOfTruth = ContextSource.isar;

    final localData = await _local.getStoredContext(userId);

    final bool remoteAvailable = _network.isOnline &&
        await _remote.isAvailable &&
        authState == AuthState.authenticated;

    if (remoteAvailable) {
      final remoteData = await _remote.fetchContractData(userId);
      if (remoteData != null) {
        await _local.storeContext(remoteData);
        data = remoteData;
        sourceOfTruth = ContextSource.firebase;
      } else {
        data = localData;
        sourceOfTruth = ContextSource.isar;
      }
    } else {
      data = localData;
      sourceOfTruth = ContextSource.isar;
    }

    // CORRECCIÓN 1: Diagnóstico exacto en fail safe
    if (data == null) {
      if (!_network.isOnline) {
        return PolicyContextV2.failSafe(
          reasonCode: ContextReasonCode.networkOffline,
        );
      }
      return PolicyContextV2.failSafe(
        reasonCode: ContextReasonCode.noDataAvailable,
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PASO 2: EVALUACIÓN DE LA DATA
    // ─────────────────────────────────────────────────────────────────────────
    final now = DateTime.now();
    final lastValidatedAt = data.lastValidatedAt;
    final maxOfflineGraceUntil = data.maxOfflineGraceUntil;
    final contractStatus = data.contractStatus;

    // ─────────────────────────────────────────────────────────────────────────
    // 1) HARD DEADLINE CHECK (FUENTE SUPREMA)
    // ─────────────────────────────────────────────────────────────────────────
    if (maxOfflineGraceUntil == null || now.isAfter(maxOfflineGraceUntil)) {
      return PolicyContextV2.blockedIdentified(
        userId: data.userId,
        orgId: data.orgId,
        role: data.role,
        legalStatus: data.legalStatus,
        authState: authState,
        contractStatus: contractStatus,
        lastValidatedAt: lastValidatedAt,
        maxOfflineGraceUntil: maxOfflineGraceUntil,
        reasonCode: ContextReasonCode.hardDeadlineExpired,
        source: sourceOfTruth,
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 2) CONTRACT BLOCK CHECK
    // ─────────────────────────────────────────────────────────────────────────
    if (contractStatus.isBlocked) {
      return PolicyContextV2.blockedIdentified(
        userId: data.userId,
        orgId: data.orgId,
        role: data.role,
        legalStatus: data.legalStatus,
        authState: authState,
        contractStatus: contractStatus,
        lastValidatedAt: lastValidatedAt,
        maxOfflineGraceUntil: maxOfflineGraceUntil,
        reasonCode: ContextReasonCode.contractBlocked,
        source: sourceOfTruth,
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 3) TTL CHECK (ZONA GRIS vs OPERACIONAL)
    // ─────────────────────────────────────────────────────────────────────────
    if (lastValidatedAt == null) {
      // ZONA GRIS: sin timestamp de validación
      return PolicyContextV2(
        userId: data.userId,
        orgId: data.orgId,
        role: data.role,
        legalStatus: data.legalStatus,
        authState: authState,
        contractStatus: contractStatus,
        lastValidatedAt: null,
        maxOfflineGraceUntil: maxOfflineGraceUntil,
        offlineMode: OfflineMode.localReadonly,
        capabilities: PolicyCapabilities.readonly,
        sourceOfTruth: sourceOfTruth,
        reasonCode: ContextReasonCode.ttlExpired,
        createdAt: now,
      );
    }

    final cacheAge = now.difference(lastValidatedAt);
    const ttlLimit = Duration(hours: 24);

    if (cacheAge <= ttlLimit) {
      // TTL OPERATIVO: cache válido (≤24h)

      // CORRECCIÓN 2: Degradación de modo según red
      final mode =
          _network.isOnline ? OfflineMode.fullLocal : OfflineMode.localReadonly;

      final bool canSyncCloud = _network.isOnline &&
          authState == AuthState.authenticated &&
          contractStatus.isOperational;

      // canCreateOperational depende del contrato, NO del modo
      final bool canCreateOperational = contractStatus.isOperational;

      // CEO RULE: canCreateDrafts = FALSE siempre
      const bool canCreateDrafts = false;

      final ContextReasonCode reasonCode;
      if (authState == AuthState.authenticated) {
        reasonCode = ContextReasonCode.valid;
      } else if (authState == AuthState.expired) {
        reasonCode = ContextReasonCode.authExpired;
      } else {
        reasonCode = ContextReasonCode.userNotAuthenticated;
      }

      return PolicyContextV2(
        userId: data.userId,
        orgId: data.orgId,
        role: data.role,
        legalStatus: data.legalStatus,
        authState: authState,
        contractStatus: contractStatus,
        lastValidatedAt: lastValidatedAt,
        maxOfflineGraceUntil: maxOfflineGraceUntil,
        offlineMode: mode,
        capabilities: PolicyCapabilities(
          canSyncCloud: canSyncCloud,
          canCreateOperational: canCreateOperational,
          canCreateDrafts: canCreateDrafts,
        ),
        sourceOfTruth: sourceOfTruth,
        reasonCode: reasonCode,
        createdAt: now,
      );
    }

    // ZONA GRIS: TTL expirado (>24h) pero hard deadline vigente
    return PolicyContextV2(
      userId: data.userId,
      orgId: data.orgId,
      role: data.role,
      legalStatus: data.legalStatus,
      authState: authState,
      contractStatus: contractStatus,
      lastValidatedAt: lastValidatedAt,
      maxOfflineGraceUntil: maxOfflineGraceUntil,
      offlineMode: OfflineMode.localReadonly,
      capabilities: PolicyCapabilities.readonly,
      sourceOfTruth: sourceOfTruth,
      reasonCode: ContextReasonCode.ttlExpired,
      createdAt: now,
    );
  }
}
