// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_access_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductAccessContext {
  String get userId;
  String get orgId;

  /// Roles activos del usuario en la organización.
  ///
  /// Contrato: esta colección DEBE llegar como Set.unmodifiable(...)
  /// desde ProductAccessContextFactory.
  Set<String> get roles;

  /// Alcance de acceso a activos.
  /// Nunca null; fallback seguro (en factory): MembershipScope().
  MembershipScope get membershipScope;

  /// Contrato de acceso de la organización.
  /// Nunca null; fallback seguro (en factory): OrganizationAccessContract.defaultRestricted().
  OrganizationAccessContract get organizationContract;

  /// Estado de conectividad en el momento de construcción del snapshot.
  bool get isOnline;

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductAccessContextCopyWith<ProductAccessContext> get copyWith =>
      _$ProductAccessContextCopyWithImpl<ProductAccessContext>(
          this as ProductAccessContext, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductAccessContext &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            (identical(other.membershipScope, membershipScope) ||
                other.membershipScope == membershipScope) &&
            (identical(other.organizationContract, organizationContract) ||
                other.organizationContract == organizationContract) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      orgId,
      const DeepCollectionEquality().hash(roles),
      membershipScope,
      organizationContract,
      isOnline);

  @override
  String toString() {
    return 'ProductAccessContext(userId: $userId, orgId: $orgId, roles: $roles, membershipScope: $membershipScope, organizationContract: $organizationContract, isOnline: $isOnline)';
  }
}

/// @nodoc
abstract mixin class $ProductAccessContextCopyWith<$Res> {
  factory $ProductAccessContextCopyWith(ProductAccessContext value,
          $Res Function(ProductAccessContext) _then) =
      _$ProductAccessContextCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      String orgId,
      Set<String> roles,
      MembershipScope membershipScope,
      OrganizationAccessContract organizationContract,
      bool isOnline});

  $MembershipScopeCopyWith<$Res> get membershipScope;
  $OrganizationAccessContractCopyWith<$Res> get organizationContract;
}

/// @nodoc
class _$ProductAccessContextCopyWithImpl<$Res>
    implements $ProductAccessContextCopyWith<$Res> {
  _$ProductAccessContextCopyWithImpl(this._self, this._then);

  final ProductAccessContext _self;
  final $Res Function(ProductAccessContext) _then;

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? orgId = null,
    Object? roles = null,
    Object? membershipScope = null,
    Object? organizationContract = null,
    Object? isOnline = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _self.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      membershipScope: null == membershipScope
          ? _self.membershipScope
          : membershipScope // ignore: cast_nullable_to_non_nullable
              as MembershipScope,
      organizationContract: null == organizationContract
          ? _self.organizationContract
          : organizationContract // ignore: cast_nullable_to_non_nullable
              as OrganizationAccessContract,
      isOnline: null == isOnline
          ? _self.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipScopeCopyWith<$Res> get membershipScope {
    return $MembershipScopeCopyWith<$Res>(_self.membershipScope, (value) {
      return _then(_self.copyWith(membershipScope: value));
    });
  }

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationAccessContractCopyWith<$Res> get organizationContract {
    return $OrganizationAccessContractCopyWith<$Res>(_self.organizationContract,
        (value) {
      return _then(_self.copyWith(organizationContract: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ProductAccessContext].
extension ProductAccessContextPatterns on ProductAccessContext {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProductAccessContext value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductAccessContext() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProductAccessContext value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAccessContext():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProductAccessContext value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAccessContext() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String userId,
            String orgId,
            Set<String> roles,
            MembershipScope membershipScope,
            OrganizationAccessContract organizationContract,
            bool isOnline)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductAccessContext() when $default != null:
        return $default(_that.userId, _that.orgId, _that.roles,
            _that.membershipScope, _that.organizationContract, _that.isOnline);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String userId,
            String orgId,
            Set<String> roles,
            MembershipScope membershipScope,
            OrganizationAccessContract organizationContract,
            bool isOnline)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAccessContext():
        return $default(_that.userId, _that.orgId, _that.roles,
            _that.membershipScope, _that.organizationContract, _that.isOnline);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String userId,
            String orgId,
            Set<String> roles,
            MembershipScope membershipScope,
            OrganizationAccessContract organizationContract,
            bool isOnline)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAccessContext() when $default != null:
        return $default(_that.userId, _that.orgId, _that.roles,
            _that.membershipScope, _that.organizationContract, _that.isOnline);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ProductAccessContext extends ProductAccessContext {
  const _ProductAccessContext(
      {required this.userId,
      required this.orgId,
      required final Set<String> roles,
      required this.membershipScope,
      required this.organizationContract,
      required this.isOnline})
      : _roles = roles,
        super._();

  @override
  final String userId;
  @override
  final String orgId;

  /// Roles activos del usuario en la organización.
  ///
  /// Contrato: esta colección DEBE llegar como Set.unmodifiable(...)
  /// desde ProductAccessContextFactory.
  final Set<String> _roles;

  /// Roles activos del usuario en la organización.
  ///
  /// Contrato: esta colección DEBE llegar como Set.unmodifiable(...)
  /// desde ProductAccessContextFactory.
  @override
  Set<String> get roles {
    if (_roles is EqualUnmodifiableSetView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_roles);
  }

  /// Alcance de acceso a activos.
  /// Nunca null; fallback seguro (en factory): MembershipScope().
  @override
  final MembershipScope membershipScope;

  /// Contrato de acceso de la organización.
  /// Nunca null; fallback seguro (en factory): OrganizationAccessContract.defaultRestricted().
  @override
  final OrganizationAccessContract organizationContract;

  /// Estado de conectividad en el momento de construcción del snapshot.
  @override
  final bool isOnline;

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductAccessContextCopyWith<_ProductAccessContext> get copyWith =>
      __$ProductAccessContextCopyWithImpl<_ProductAccessContext>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductAccessContext &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.membershipScope, membershipScope) ||
                other.membershipScope == membershipScope) &&
            (identical(other.organizationContract, organizationContract) ||
                other.organizationContract == organizationContract) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      orgId,
      const DeepCollectionEquality().hash(_roles),
      membershipScope,
      organizationContract,
      isOnline);

  @override
  String toString() {
    return 'ProductAccessContext(userId: $userId, orgId: $orgId, roles: $roles, membershipScope: $membershipScope, organizationContract: $organizationContract, isOnline: $isOnline)';
  }
}

/// @nodoc
abstract mixin class _$ProductAccessContextCopyWith<$Res>
    implements $ProductAccessContextCopyWith<$Res> {
  factory _$ProductAccessContextCopyWith(_ProductAccessContext value,
          $Res Function(_ProductAccessContext) _then) =
      __$ProductAccessContextCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      String orgId,
      Set<String> roles,
      MembershipScope membershipScope,
      OrganizationAccessContract organizationContract,
      bool isOnline});

  @override
  $MembershipScopeCopyWith<$Res> get membershipScope;
  @override
  $OrganizationAccessContractCopyWith<$Res> get organizationContract;
}

/// @nodoc
class __$ProductAccessContextCopyWithImpl<$Res>
    implements _$ProductAccessContextCopyWith<$Res> {
  __$ProductAccessContextCopyWithImpl(this._self, this._then);

  final _ProductAccessContext _self;
  final $Res Function(_ProductAccessContext) _then;

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? orgId = null,
    Object? roles = null,
    Object? membershipScope = null,
    Object? organizationContract = null,
    Object? isOnline = null,
  }) {
    return _then(_ProductAccessContext(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _self._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      membershipScope: null == membershipScope
          ? _self.membershipScope
          : membershipScope // ignore: cast_nullable_to_non_nullable
              as MembershipScope,
      organizationContract: null == organizationContract
          ? _self.organizationContract
          : organizationContract // ignore: cast_nullable_to_non_nullable
              as OrganizationAccessContract,
      isOnline: null == isOnline
          ? _self.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipScopeCopyWith<$Res> get membershipScope {
    return $MembershipScopeCopyWith<$Res>(_self.membershipScope, (value) {
      return _then(_self.copyWith(membershipScope: value));
    });
  }

  /// Create a copy of ProductAccessContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationAccessContractCopyWith<$Res> get organizationContract {
    return $OrganizationAccessContractCopyWith<$Res>(_self.organizationContract,
        (value) {
      return _then(_self.copyWith(organizationContract: value));
    });
  }
}

// dart format on
