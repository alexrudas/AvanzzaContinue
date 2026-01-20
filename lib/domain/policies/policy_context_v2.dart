// lib/domain/policies/policy_context_v2.dart

library;

import 'policy_types.dart';
export 'policy_types.dart';

class PolicyCapabilities {
  final bool canSyncCloud;
  final bool canCreateOperational;
  final bool canCreateDrafts;

  const PolicyCapabilities({
    required this.canSyncCloud,
    required this.canCreateOperational,
    required this.canCreateDrafts,
  });

  static const PolicyCapabilities blocked = PolicyCapabilities(
    canSyncCloud: false,
    canCreateOperational: false,
    canCreateDrafts: false,
  );

  static const PolicyCapabilities readonly = PolicyCapabilities(
    canSyncCloud: false,
    canCreateOperational: false,
    canCreateDrafts: false,
  );

  PolicyCapabilities copyWith({
    bool? canSyncCloud,
    bool? canCreateOperational,
    bool? canCreateDrafts,
  }) {
    return PolicyCapabilities(
      canSyncCloud: canSyncCloud ?? this.canSyncCloud,
      canCreateOperational: canCreateOperational ?? this.canCreateOperational,
      canCreateDrafts: canCreateDrafts ?? this.canCreateDrafts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolicyCapabilities &&
          runtimeType == other.runtimeType &&
          canSyncCloud == other.canSyncCloud &&
          canCreateOperational == other.canCreateOperational &&
          canCreateDrafts == other.canCreateDrafts;

  @override
  int get hashCode => Object.hash(
        canSyncCloud,
        canCreateOperational,
        canCreateDrafts,
      );

  @override
  String toString() =>
      'PolicyCapabilities(sync: $canSyncCloud, operational: $canCreateOperational, drafts: $canCreateDrafts)';
}

class PolicyContextV2 {
  final String? userId;
  final String? orgId;
  final Role role;
  final LegalStatus legalStatus;
  final AuthState authState;
  final ContractStatus contractStatus;
  final DateTime? lastValidatedAt;
  final DateTime? maxOfflineGraceUntil;
  final OfflineMode offlineMode;
  final PolicyCapabilities capabilities;
  final ContextSource sourceOfTruth;
  final ContextReasonCode reasonCode;

  /// Timestamp de creación del contexto.
  /// NOTA: Excluido intencionalmente de == y hashCode para evitar rebuilds
  /// innecesarios cuando el contexto se reconstruye con los mismos datos.
  final DateTime createdAt;

  const PolicyContextV2({
    required this.userId,
    required this.orgId,
    required this.role,
    required this.legalStatus,
    required this.authState,
    required this.contractStatus,
    required this.lastValidatedAt,
    required this.maxOfflineGraceUntil,
    required this.offlineMode,
    required this.capabilities,
    required this.sourceOfTruth,
    required this.reasonCode,
    required this.createdAt,
  });

  bool get isBlocked => offlineMode == OfflineMode.blocked;

  factory PolicyContextV2.failSafe({
    required ContextReasonCode reasonCode,
  }) {
    return PolicyContextV2(
      userId: null,
      orgId: null,
      role: Role.tenant,
      legalStatus: LegalStatus.informal,
      authState: AuthState.unknown,
      contractStatus: ContractStatus.unknown,
      lastValidatedAt: null,
      maxOfflineGraceUntil: null,
      offlineMode: OfflineMode.blocked,
      capabilities: PolicyCapabilities.blocked,
      sourceOfTruth: ContextSource.synthetic,
      reasonCode: reasonCode,
      createdAt: DateTime.now(),
    );
  }

  factory PolicyContextV2.blockedIdentified({
    required String userId,
    required String orgId,
    required Role role,
    required LegalStatus legalStatus,
    required AuthState authState,
    required ContractStatus contractStatus,
    required DateTime? lastValidatedAt,
    required DateTime? maxOfflineGraceUntil,
    required ContextReasonCode reasonCode,
    required ContextSource source,
  }) {
    return PolicyContextV2(
      userId: userId,
      orgId: orgId,
      role: role,
      legalStatus: legalStatus,
      authState: authState,
      contractStatus: contractStatus,
      lastValidatedAt: lastValidatedAt,
      maxOfflineGraceUntil: maxOfflineGraceUntil,
      offlineMode: OfflineMode.blocked,
      capabilities: PolicyCapabilities.blocked,
      sourceOfTruth: source,
      reasonCode: reasonCode,
      createdAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolicyContextV2 &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          orgId == other.orgId &&
          role == other.role &&
          legalStatus == other.legalStatus &&
          authState == other.authState &&
          contractStatus == other.contractStatus &&
          lastValidatedAt == other.lastValidatedAt &&
          maxOfflineGraceUntil == other.maxOfflineGraceUntil &&
          offlineMode == other.offlineMode &&
          capabilities == other.capabilities &&
          sourceOfTruth == other.sourceOfTruth &&
          reasonCode == other.reasonCode;
  // createdAt excluido intencionalmente para evitar rebuilds innecesarios

  @override
  int get hashCode => Object.hash(
        userId,
        orgId,
        role,
        legalStatus,
        authState,
        contractStatus,
        lastValidatedAt,
        maxOfflineGraceUntil,
        offlineMode,
        capabilities,
        sourceOfTruth,
        reasonCode,
        // createdAt excluido intencionalmente para evitar rebuilds innecesarios
      );

  @override
  String toString() =>
      'PolicyContextV2(user: $userId, org: $orgId, role: ${role.wireName}, contract: ${contractStatus.wireName}, offline: ${offlineMode.wireName}, reason: ${reasonCode.wireName}, caps: $capabilities)';
}
