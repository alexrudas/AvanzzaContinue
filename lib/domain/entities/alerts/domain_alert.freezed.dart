// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'domain_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DomainAlert {
  /// UUID único de esta alerta.
  String get id;

  /// Código canónico wire-stable que identifica el tipo de alerta.
  AlertCode get code;

  /// Nivel de urgencia.
  AlertSeverity get severity;

  /// Naturaleza semántica de la señal.
  ///
  /// Determina conteo en métricas, elegibilidad para Home y rendering.
  /// Default [AlertKind.compliance] — retrocompatible con V1.
  AlertKind get alertKind;

  /// Dominio operativo de origen.
  AlertScope get scope;

  /// Rol objetivo. En V1 siempre [AlertAudience.assetAdmin].
  AlertAudience get audience;

  /// Política de visibilidad en Home.
  AlertPromotionPolicy get promotionPolicy;

  /// ID del activo u entidad que originó la alerta.
  String get sourceEntityId;

  /// Key i18n del título de la alerta (NO el string final).
  String get titleKey;

  /// Key i18n del cuerpo/descripción de la alerta (NO el string final).
  String get bodyKey;

  /// Datos contextuales de la alerta.
  ///
  /// REGLAS: las keys deben estar definidas en [AlertFactKeys].
  /// Los productores no pueden inventar keys ad hoc — toda key nueva
  /// requiere agregarla primero en AlertFactKeys.
  /// Los values deben ser serializables y estables (String, num, bool, null).
  /// No insertar objetos arbitrarios ni instancias no serializables.
  Map<String, Object?> get facts;

  /// Referencias a la evidencia real que originó la alerta.
  ///
  /// REGLAS: cada entrada usa keys de [AlertEvidenceKeys] exclusivamente:
  /// sourceType, sourceId, sourceCollection, documentId, externalRef.
  /// Los productores no pueden inventar keys fuera de [AlertEvidenceKeys].
  /// Los values deben ser Strings estables o null — no insertar objetos.
  List<Map<String, Object?>> get evidenceRefs;

  /// Siempre true en V1 (cálculo on-read).
  ///
  /// Reservado para V2 donde las alertas persistidas podrían
  /// marcarse como inactivas sin eliminarse.
  bool get isActive;

  /// Momento en que esta alerta fue calculada/detectada.
  DateTime get detectedAt;

  /// Última actualización de la fuente que originó esta alerta.
  ///
  /// Usado como desempate final en el algoritmo de sort.
  DateTime get sourceUpdatedAt;

  /// Key de deduplicación canónica.
  ///
  /// Formato (V4 §12.1):
  ///   `"{code.wireName}:{scope.wireName}:{sourceEntityId}:{primaryEvidenceId}"`
  ///
  /// Reglas wire-stability:
  /// - `code` → [AlertCode.wireName] (e.g. `"soat_expired"`). NUNCA `.name`.
  /// - `scope` → [AlertScope.wireName] (e.g. `"asset"`). NUNCA `.name`.
  ///   Ambos enums usan wireName por consistencia (V4 §19 regla 12).
  /// - `primaryEvidenceId` → [AlertEvidenceKeys.sourceId] de `evidenceRefs[0]`.
  ///   La mecánica exacta de construcción pertenece al productor, no a esta entidad.
  ///
  /// Calculado por el productor al construir la alerta.
  /// El pipeline de dedupe retiene la de [detectedAt] más reciente
  /// ante duplicados con el mismo dedupeKey.
  String get dedupeKey;

  /// Create a copy of DomainAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DomainAlertCopyWith<DomainAlert> get copyWith =>
      _$DomainAlertCopyWithImpl<DomainAlert>(this as DomainAlert, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DomainAlert &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.alertKind, alertKind) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.audience, audience) ||
                other.audience == audience) &&
            (identical(other.promotionPolicy, promotionPolicy) ||
                other.promotionPolicy == promotionPolicy) &&
            (identical(other.sourceEntityId, sourceEntityId) ||
                other.sourceEntityId == sourceEntityId) &&
            (identical(other.titleKey, titleKey) ||
                other.titleKey == titleKey) &&
            (identical(other.bodyKey, bodyKey) || other.bodyKey == bodyKey) &&
            const DeepCollectionEquality().equals(other.facts, facts) &&
            const DeepCollectionEquality()
                .equals(other.evidenceRefs, evidenceRefs) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            (identical(other.sourceUpdatedAt, sourceUpdatedAt) ||
                other.sourceUpdatedAt == sourceUpdatedAt) &&
            (identical(other.dedupeKey, dedupeKey) ||
                other.dedupeKey == dedupeKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      severity,
      const DeepCollectionEquality().hash(alertKind),
      scope,
      audience,
      promotionPolicy,
      sourceEntityId,
      titleKey,
      bodyKey,
      const DeepCollectionEquality().hash(facts),
      const DeepCollectionEquality().hash(evidenceRefs),
      isActive,
      detectedAt,
      sourceUpdatedAt,
      dedupeKey);

  @override
  String toString() {
    return 'DomainAlert(id: $id, code: $code, severity: $severity, alertKind: $alertKind, scope: $scope, audience: $audience, promotionPolicy: $promotionPolicy, sourceEntityId: $sourceEntityId, titleKey: $titleKey, bodyKey: $bodyKey, facts: $facts, evidenceRefs: $evidenceRefs, isActive: $isActive, detectedAt: $detectedAt, sourceUpdatedAt: $sourceUpdatedAt, dedupeKey: $dedupeKey)';
  }
}

/// @nodoc
abstract mixin class $DomainAlertCopyWith<$Res> {
  factory $DomainAlertCopyWith(
          DomainAlert value, $Res Function(DomainAlert) _then) =
      _$DomainAlertCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      AlertCode code,
      AlertSeverity severity,
      AlertKind alertKind,
      AlertScope scope,
      AlertAudience audience,
      AlertPromotionPolicy promotionPolicy,
      String sourceEntityId,
      String titleKey,
      String bodyKey,
      Map<String, Object?> facts,
      List<Map<String, Object?>> evidenceRefs,
      bool isActive,
      DateTime detectedAt,
      DateTime sourceUpdatedAt,
      String dedupeKey});
}

/// @nodoc
class _$DomainAlertCopyWithImpl<$Res> implements $DomainAlertCopyWith<$Res> {
  _$DomainAlertCopyWithImpl(this._self, this._then);

  final DomainAlert _self;
  final $Res Function(DomainAlert) _then;

  /// Create a copy of DomainAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? severity = null,
    Object? alertKind = freezed,
    Object? scope = null,
    Object? audience = null,
    Object? promotionPolicy = null,
    Object? sourceEntityId = null,
    Object? titleKey = null,
    Object? bodyKey = null,
    Object? facts = null,
    Object? evidenceRefs = null,
    Object? isActive = null,
    Object? detectedAt = null,
    Object? sourceUpdatedAt = null,
    Object? dedupeKey = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as AlertCode,
      severity: null == severity
          ? _self.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      alertKind: freezed == alertKind
          ? _self.alertKind
          : alertKind // ignore: cast_nullable_to_non_nullable
              as AlertKind,
      scope: null == scope
          ? _self.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as AlertScope,
      audience: null == audience
          ? _self.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as AlertAudience,
      promotionPolicy: null == promotionPolicy
          ? _self.promotionPolicy
          : promotionPolicy // ignore: cast_nullable_to_non_nullable
              as AlertPromotionPolicy,
      sourceEntityId: null == sourceEntityId
          ? _self.sourceEntityId
          : sourceEntityId // ignore: cast_nullable_to_non_nullable
              as String,
      titleKey: null == titleKey
          ? _self.titleKey
          : titleKey // ignore: cast_nullable_to_non_nullable
              as String,
      bodyKey: null == bodyKey
          ? _self.bodyKey
          : bodyKey // ignore: cast_nullable_to_non_nullable
              as String,
      facts: null == facts
          ? _self.facts
          : facts // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
      evidenceRefs: null == evidenceRefs
          ? _self.evidenceRefs
          : evidenceRefs // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedAt: null == detectedAt
          ? _self.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sourceUpdatedAt: null == sourceUpdatedAt
          ? _self.sourceUpdatedAt
          : sourceUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dedupeKey: null == dedupeKey
          ? _self.dedupeKey
          : dedupeKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [DomainAlert].
extension DomainAlertPatterns on DomainAlert {
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
    TResult Function(_DomainAlert value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DomainAlert() when $default != null:
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
    TResult Function(_DomainAlert value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DomainAlert():
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
    TResult? Function(_DomainAlert value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DomainAlert() when $default != null:
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
            String id,
            AlertCode code,
            AlertSeverity severity,
            AlertKind alertKind,
            AlertScope scope,
            AlertAudience audience,
            AlertPromotionPolicy promotionPolicy,
            String sourceEntityId,
            String titleKey,
            String bodyKey,
            Map<String, Object?> facts,
            List<Map<String, Object?>> evidenceRefs,
            bool isActive,
            DateTime detectedAt,
            DateTime sourceUpdatedAt,
            String dedupeKey)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DomainAlert() when $default != null:
        return $default(
            _that.id,
            _that.code,
            _that.severity,
            _that.alertKind,
            _that.scope,
            _that.audience,
            _that.promotionPolicy,
            _that.sourceEntityId,
            _that.titleKey,
            _that.bodyKey,
            _that.facts,
            _that.evidenceRefs,
            _that.isActive,
            _that.detectedAt,
            _that.sourceUpdatedAt,
            _that.dedupeKey);
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
            String id,
            AlertCode code,
            AlertSeverity severity,
            AlertKind alertKind,
            AlertScope scope,
            AlertAudience audience,
            AlertPromotionPolicy promotionPolicy,
            String sourceEntityId,
            String titleKey,
            String bodyKey,
            Map<String, Object?> facts,
            List<Map<String, Object?>> evidenceRefs,
            bool isActive,
            DateTime detectedAt,
            DateTime sourceUpdatedAt,
            String dedupeKey)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DomainAlert():
        return $default(
            _that.id,
            _that.code,
            _that.severity,
            _that.alertKind,
            _that.scope,
            _that.audience,
            _that.promotionPolicy,
            _that.sourceEntityId,
            _that.titleKey,
            _that.bodyKey,
            _that.facts,
            _that.evidenceRefs,
            _that.isActive,
            _that.detectedAt,
            _that.sourceUpdatedAt,
            _that.dedupeKey);
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
            String id,
            AlertCode code,
            AlertSeverity severity,
            AlertKind alertKind,
            AlertScope scope,
            AlertAudience audience,
            AlertPromotionPolicy promotionPolicy,
            String sourceEntityId,
            String titleKey,
            String bodyKey,
            Map<String, Object?> facts,
            List<Map<String, Object?>> evidenceRefs,
            bool isActive,
            DateTime detectedAt,
            DateTime sourceUpdatedAt,
            String dedupeKey)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DomainAlert() when $default != null:
        return $default(
            _that.id,
            _that.code,
            _that.severity,
            _that.alertKind,
            _that.scope,
            _that.audience,
            _that.promotionPolicy,
            _that.sourceEntityId,
            _that.titleKey,
            _that.bodyKey,
            _that.facts,
            _that.evidenceRefs,
            _that.isActive,
            _that.detectedAt,
            _that.sourceUpdatedAt,
            _that.dedupeKey);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DomainAlert implements DomainAlert {
  const _DomainAlert(
      {required this.id,
      required this.code,
      required this.severity,
      this.alertKind = AlertKind.compliance,
      required this.scope,
      required this.audience,
      required this.promotionPolicy,
      required this.sourceEntityId,
      required this.titleKey,
      required this.bodyKey,
      final Map<String, Object?> facts = const {},
      final List<Map<String, Object?>> evidenceRefs = const [],
      this.isActive = true,
      required this.detectedAt,
      required this.sourceUpdatedAt,
      required this.dedupeKey})
      : _facts = facts,
        _evidenceRefs = evidenceRefs;

  /// UUID único de esta alerta.
  @override
  final String id;

  /// Código canónico wire-stable que identifica el tipo de alerta.
  @override
  final AlertCode code;

  /// Nivel de urgencia.
  @override
  final AlertSeverity severity;

  /// Naturaleza semántica de la señal.
  ///
  /// Determina conteo en métricas, elegibilidad para Home y rendering.
  /// Default [AlertKind.compliance] — retrocompatible con V1.
  @override
  @JsonKey()
  final AlertKind alertKind;

  /// Dominio operativo de origen.
  @override
  final AlertScope scope;

  /// Rol objetivo. En V1 siempre [AlertAudience.assetAdmin].
  @override
  final AlertAudience audience;

  /// Política de visibilidad en Home.
  @override
  final AlertPromotionPolicy promotionPolicy;

  /// ID del activo u entidad que originó la alerta.
  @override
  final String sourceEntityId;

  /// Key i18n del título de la alerta (NO el string final).
  @override
  final String titleKey;

  /// Key i18n del cuerpo/descripción de la alerta (NO el string final).
  @override
  final String bodyKey;

  /// Datos contextuales de la alerta.
  ///
  /// REGLAS: las keys deben estar definidas en [AlertFactKeys].
  /// Los productores no pueden inventar keys ad hoc — toda key nueva
  /// requiere agregarla primero en AlertFactKeys.
  /// Los values deben ser serializables y estables (String, num, bool, null).
  /// No insertar objetos arbitrarios ni instancias no serializables.
  final Map<String, Object?> _facts;

  /// Datos contextuales de la alerta.
  ///
  /// REGLAS: las keys deben estar definidas en [AlertFactKeys].
  /// Los productores no pueden inventar keys ad hoc — toda key nueva
  /// requiere agregarla primero en AlertFactKeys.
  /// Los values deben ser serializables y estables (String, num, bool, null).
  /// No insertar objetos arbitrarios ni instancias no serializables.
  @override
  @JsonKey()
  Map<String, Object?> get facts {
    if (_facts is EqualUnmodifiableMapView) return _facts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_facts);
  }

  /// Referencias a la evidencia real que originó la alerta.
  ///
  /// REGLAS: cada entrada usa keys de [AlertEvidenceKeys] exclusivamente:
  /// sourceType, sourceId, sourceCollection, documentId, externalRef.
  /// Los productores no pueden inventar keys fuera de [AlertEvidenceKeys].
  /// Los values deben ser Strings estables o null — no insertar objetos.
  final List<Map<String, Object?>> _evidenceRefs;

  /// Referencias a la evidencia real que originó la alerta.
  ///
  /// REGLAS: cada entrada usa keys de [AlertEvidenceKeys] exclusivamente:
  /// sourceType, sourceId, sourceCollection, documentId, externalRef.
  /// Los productores no pueden inventar keys fuera de [AlertEvidenceKeys].
  /// Los values deben ser Strings estables o null — no insertar objetos.
  @override
  @JsonKey()
  List<Map<String, Object?>> get evidenceRefs {
    if (_evidenceRefs is EqualUnmodifiableListView) return _evidenceRefs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidenceRefs);
  }

  /// Siempre true en V1 (cálculo on-read).
  ///
  /// Reservado para V2 donde las alertas persistidas podrían
  /// marcarse como inactivas sin eliminarse.
  @override
  @JsonKey()
  final bool isActive;

  /// Momento en que esta alerta fue calculada/detectada.
  @override
  final DateTime detectedAt;

  /// Última actualización de la fuente que originó esta alerta.
  ///
  /// Usado como desempate final en el algoritmo de sort.
  @override
  final DateTime sourceUpdatedAt;

  /// Key de deduplicación canónica.
  ///
  /// Formato (V4 §12.1):
  ///   `"{code.wireName}:{scope.wireName}:{sourceEntityId}:{primaryEvidenceId}"`
  ///
  /// Reglas wire-stability:
  /// - `code` → [AlertCode.wireName] (e.g. `"soat_expired"`). NUNCA `.name`.
  /// - `scope` → [AlertScope.wireName] (e.g. `"asset"`). NUNCA `.name`.
  ///   Ambos enums usan wireName por consistencia (V4 §19 regla 12).
  /// - `primaryEvidenceId` → [AlertEvidenceKeys.sourceId] de `evidenceRefs[0]`.
  ///   La mecánica exacta de construcción pertenece al productor, no a esta entidad.
  ///
  /// Calculado por el productor al construir la alerta.
  /// El pipeline de dedupe retiene la de [detectedAt] más reciente
  /// ante duplicados con el mismo dedupeKey.
  @override
  final String dedupeKey;

  /// Create a copy of DomainAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DomainAlertCopyWith<_DomainAlert> get copyWith =>
      __$DomainAlertCopyWithImpl<_DomainAlert>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DomainAlert &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.alertKind, alertKind) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.audience, audience) ||
                other.audience == audience) &&
            (identical(other.promotionPolicy, promotionPolicy) ||
                other.promotionPolicy == promotionPolicy) &&
            (identical(other.sourceEntityId, sourceEntityId) ||
                other.sourceEntityId == sourceEntityId) &&
            (identical(other.titleKey, titleKey) ||
                other.titleKey == titleKey) &&
            (identical(other.bodyKey, bodyKey) || other.bodyKey == bodyKey) &&
            const DeepCollectionEquality().equals(other._facts, _facts) &&
            const DeepCollectionEquality()
                .equals(other._evidenceRefs, _evidenceRefs) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            (identical(other.sourceUpdatedAt, sourceUpdatedAt) ||
                other.sourceUpdatedAt == sourceUpdatedAt) &&
            (identical(other.dedupeKey, dedupeKey) ||
                other.dedupeKey == dedupeKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      severity,
      const DeepCollectionEquality().hash(alertKind),
      scope,
      audience,
      promotionPolicy,
      sourceEntityId,
      titleKey,
      bodyKey,
      const DeepCollectionEquality().hash(_facts),
      const DeepCollectionEquality().hash(_evidenceRefs),
      isActive,
      detectedAt,
      sourceUpdatedAt,
      dedupeKey);

  @override
  String toString() {
    return 'DomainAlert(id: $id, code: $code, severity: $severity, alertKind: $alertKind, scope: $scope, audience: $audience, promotionPolicy: $promotionPolicy, sourceEntityId: $sourceEntityId, titleKey: $titleKey, bodyKey: $bodyKey, facts: $facts, evidenceRefs: $evidenceRefs, isActive: $isActive, detectedAt: $detectedAt, sourceUpdatedAt: $sourceUpdatedAt, dedupeKey: $dedupeKey)';
  }
}

/// @nodoc
abstract mixin class _$DomainAlertCopyWith<$Res>
    implements $DomainAlertCopyWith<$Res> {
  factory _$DomainAlertCopyWith(
          _DomainAlert value, $Res Function(_DomainAlert) _then) =
      __$DomainAlertCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      AlertCode code,
      AlertSeverity severity,
      AlertKind alertKind,
      AlertScope scope,
      AlertAudience audience,
      AlertPromotionPolicy promotionPolicy,
      String sourceEntityId,
      String titleKey,
      String bodyKey,
      Map<String, Object?> facts,
      List<Map<String, Object?>> evidenceRefs,
      bool isActive,
      DateTime detectedAt,
      DateTime sourceUpdatedAt,
      String dedupeKey});
}

/// @nodoc
class __$DomainAlertCopyWithImpl<$Res> implements _$DomainAlertCopyWith<$Res> {
  __$DomainAlertCopyWithImpl(this._self, this._then);

  final _DomainAlert _self;
  final $Res Function(_DomainAlert) _then;

  /// Create a copy of DomainAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? severity = null,
    Object? alertKind = freezed,
    Object? scope = null,
    Object? audience = null,
    Object? promotionPolicy = null,
    Object? sourceEntityId = null,
    Object? titleKey = null,
    Object? bodyKey = null,
    Object? facts = null,
    Object? evidenceRefs = null,
    Object? isActive = null,
    Object? detectedAt = null,
    Object? sourceUpdatedAt = null,
    Object? dedupeKey = null,
  }) {
    return _then(_DomainAlert(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as AlertCode,
      severity: null == severity
          ? _self.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      alertKind: freezed == alertKind
          ? _self.alertKind
          : alertKind // ignore: cast_nullable_to_non_nullable
              as AlertKind,
      scope: null == scope
          ? _self.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as AlertScope,
      audience: null == audience
          ? _self.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as AlertAudience,
      promotionPolicy: null == promotionPolicy
          ? _self.promotionPolicy
          : promotionPolicy // ignore: cast_nullable_to_non_nullable
              as AlertPromotionPolicy,
      sourceEntityId: null == sourceEntityId
          ? _self.sourceEntityId
          : sourceEntityId // ignore: cast_nullable_to_non_nullable
              as String,
      titleKey: null == titleKey
          ? _self.titleKey
          : titleKey // ignore: cast_nullable_to_non_nullable
              as String,
      bodyKey: null == bodyKey
          ? _self.bodyKey
          : bodyKey // ignore: cast_nullable_to_non_nullable
              as String,
      facts: null == facts
          ? _self._facts
          : facts // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
      evidenceRefs: null == evidenceRefs
          ? _self._evidenceRefs
          : evidenceRefs // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedAt: null == detectedAt
          ? _self.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sourceUpdatedAt: null == sourceUpdatedAt
          ? _self.sourceUpdatedAt
          : sourceUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dedupeKey: null == dedupeKey
          ? _self.dedupeKey
          : dedupeKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
