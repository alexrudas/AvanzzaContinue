// lib/domain/policies/policy_types.dart

enum Role {
  owner,
  admin,
  tenant,
  provider;

  String get wireName {
    switch (this) {
      case Role.owner:
        return 'OWNER';
      case Role.admin:
        return 'ADMIN';
      case Role.tenant:
        return 'TENANT';
      case Role.provider:
        return 'PROVIDER';
    }
  }

  static Role fromWire(String wire) {
    final normalized = wire.trim().toUpperCase();
    for (final value in Role.values) {
      if (value.wireName == normalized) {
        return value;
      }
    }
    return Role.tenant;
  }

  static Role? tryFromWire(String? wire) {
    if (wire == null || wire.trim().isEmpty) return null;
    return fromWire(wire);
  }
}

enum LegalStatus {
  formal,
  informal;

  String get wireName {
    switch (this) {
      case LegalStatus.formal:
        return 'FORMAL';
      case LegalStatus.informal:
        return 'INFORMAL';
    }
  }

  static LegalStatus fromWire(String wire) {
    final normalized = wire.trim().toUpperCase();
    for (final value in LegalStatus.values) {
      if (value.wireName == normalized) {
        return value;
      }
    }
    return LegalStatus.informal;
  }

  static LegalStatus? tryFromWire(String? wire) {
    if (wire == null || wire.trim().isEmpty) return null;
    return fromWire(wire);
  }
}

enum AuthState {
  authenticated,
  unauthenticated,
  expired,
  unknown;

  String get wireName {
    switch (this) {
      case AuthState.authenticated:
        return 'AUTHENTICATED';
      case AuthState.unauthenticated:
        return 'UNAUTHENTICATED';
      case AuthState.expired:
        return 'EXPIRED';
      case AuthState.unknown:
        return 'UNKNOWN';
    }
  }

  static AuthState fromWire(String wire) {
    final normalized = wire.trim().toUpperCase();
    for (final value in AuthState.values) {
      if (value.wireName == normalized) {
        return value;
      }
    }
    return AuthState.unknown;
  }

  static AuthState? tryFromWire(String? wire) {
    if (wire == null || wire.trim().isEmpty) return null;
    return fromWire(wire);
  }
}

enum ContractStatus {
  trial,
  active,
  pastDue,
  grace,
  suspended,
  cancelled,
  unknown;

  String get wireName {
    switch (this) {
      case ContractStatus.trial:
        return 'TRIAL';
      case ContractStatus.active:
        return 'ACTIVE';
      case ContractStatus.pastDue:
        return 'PAST_DUE';
      case ContractStatus.grace:
        return 'GRACE';
      case ContractStatus.suspended:
        return 'SUSPENDED';
      case ContractStatus.cancelled:
        return 'CANCELLED';
      case ContractStatus.unknown:
        return 'UNKNOWN';
    }
  }

  static ContractStatus fromWire(String wire) {
    final normalized = wire.trim().toUpperCase();
    for (final value in ContractStatus.values) {
      if (value.wireName == normalized) {
        return value;
      }
    }
    return ContractStatus.unknown;
  }

  static ContractStatus? tryFromWire(String? wire) {
    if (wire == null || wire.trim().isEmpty) return null;
    return fromWire(wire);
  }

  bool get isOperational => this == trial || this == active;

  bool get isBlocked =>
      this == suspended || this == cancelled || this == unknown;
}

enum OfflineMode {
  fullLocal,
  localReadonly,
  blocked;

  String get wireName {
    switch (this) {
      case OfflineMode.fullLocal:
        return 'FULL_LOCAL';
      case OfflineMode.localReadonly:
        return 'LOCAL_READONLY';
      case OfflineMode.blocked:
        return 'BLOCKED';
    }
  }

  static OfflineMode fromWire(String wire) {
    final normalized = wire.trim().toUpperCase();
    for (final value in OfflineMode.values) {
      if (value.wireName == normalized) {
        return value;
      }
    }
    return OfflineMode.blocked;
  }

  static OfflineMode? tryFromWire(String? wire) {
    if (wire == null || wire.trim().isEmpty) return null;
    return fromWire(wire);
  }
}

enum ContextSource {
  firebase,
  isar,
  synthetic;

  String get wireName {
    switch (this) {
      case ContextSource.firebase:
        return 'FIREBASE';
      case ContextSource.isar:
        return 'ISAR';
      case ContextSource.synthetic:
        return 'SYNTHETIC';
    }
  }

  static ContextSource fromWire(String wire) {
    final normalized = wire.trim().toUpperCase();
    for (final value in ContextSource.values) {
      if (value.wireName == normalized) {
        return value;
      }
    }
    return ContextSource.synthetic;
  }

  static ContextSource? tryFromWire(String? wire) {
    if (wire == null || wire.trim().isEmpty) return null;
    return fromWire(wire);
  }
}

enum ContextReasonCode {
  valid,
  userNotAuthenticated,
  networkOffline,
  authExpired,
  ttlExpired,
  hardDeadlineExpired,
  contractBlocked,
  noDataAvailable,
  constructionError;

  String get wireName {
    switch (this) {
      case ContextReasonCode.valid:
        return 'VALID';
      case ContextReasonCode.userNotAuthenticated:
        return 'USER_NOT_AUTHENTICATED';
      case ContextReasonCode.networkOffline:
        return 'NETWORK_OFFLINE';
      case ContextReasonCode.authExpired:
        return 'AUTH_EXPIRED';
      case ContextReasonCode.ttlExpired:
        return 'TTL_EXPIRED';
      case ContextReasonCode.hardDeadlineExpired:
        return 'HARD_DEADLINE_EXPIRED';
      case ContextReasonCode.contractBlocked:
        return 'CONTRACT_BLOCKED';
      case ContextReasonCode.noDataAvailable:
        return 'NO_DATA_AVAILABLE';
      case ContextReasonCode.constructionError:
        return 'CONSTRUCTION_ERROR';
    }
  }

  static ContextReasonCode fromWire(String wire) {
    final normalized = wire.trim().toUpperCase();
    for (final value in ContextReasonCode.values) {
      if (value.wireName == normalized) {
        return value;
      }
    }
    return ContextReasonCode.constructionError;
  }

  static ContextReasonCode? tryFromWire(String? wire) {
    if (wire == null || wire.trim().isEmpty) return null;
    return fromWire(wire);
  }
}
