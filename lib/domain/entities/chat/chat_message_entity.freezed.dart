// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageEntity {
  String get id;
  String get chatId;
  String get senderId;
  String? get receiverId;
  String? get groupId;
  String get message;
  List<String> get attachments;
  DateTime get timestamp;
  String? get orgId;
  String? get cityId;
  String? get assetId;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of ChatMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatMessageEntityCopyWith<ChatMessageEntity> get copyWith =>
      _$ChatMessageEntityCopyWithImpl<ChatMessageEntity>(
          this as ChatMessageEntity, _$identity);

  /// Serializes this ChatMessageEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatMessageEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.attachments, attachments) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      chatId,
      senderId,
      receiverId,
      groupId,
      message,
      const DeepCollectionEquality().hash(attachments),
      timestamp,
      orgId,
      cityId,
      assetId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'ChatMessageEntity(id: $id, chatId: $chatId, senderId: $senderId, receiverId: $receiverId, groupId: $groupId, message: $message, attachments: $attachments, timestamp: $timestamp, orgId: $orgId, cityId: $cityId, assetId: $assetId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ChatMessageEntityCopyWith<$Res> {
  factory $ChatMessageEntityCopyWith(
          ChatMessageEntity value, $Res Function(ChatMessageEntity) _then) =
      _$ChatMessageEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String chatId,
      String senderId,
      String? receiverId,
      String? groupId,
      String message,
      List<String> attachments,
      DateTime timestamp,
      String? orgId,
      String? cityId,
      String? assetId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ChatMessageEntityCopyWithImpl<$Res>
    implements $ChatMessageEntityCopyWith<$Res> {
  _$ChatMessageEntityCopyWithImpl(this._self, this._then);

  final ChatMessageEntity _self;
  final $Res Function(ChatMessageEntity) _then;

  /// Create a copy of ChatMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? receiverId = freezed,
    Object? groupId = freezed,
    Object? message = null,
    Object? attachments = null,
    Object? timestamp = null,
    Object? orgId = freezed,
    Object? cityId = freezed,
    Object? assetId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _self.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: freezed == receiverId
          ? _self.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _self.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orgId: freezed == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatMessageEntity].
extension ChatMessageEntityPatterns on ChatMessageEntity {
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
    TResult Function(_ChatMessageEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessageEntity() when $default != null:
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
    TResult Function(_ChatMessageEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageEntity():
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
    TResult? Function(_ChatMessageEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageEntity() when $default != null:
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
            String chatId,
            String senderId,
            String? receiverId,
            String? groupId,
            String message,
            List<String> attachments,
            DateTime timestamp,
            String? orgId,
            String? cityId,
            String? assetId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessageEntity() when $default != null:
        return $default(
            _that.id,
            _that.chatId,
            _that.senderId,
            _that.receiverId,
            _that.groupId,
            _that.message,
            _that.attachments,
            _that.timestamp,
            _that.orgId,
            _that.cityId,
            _that.assetId,
            _that.createdAt,
            _that.updatedAt);
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
            String chatId,
            String senderId,
            String? receiverId,
            String? groupId,
            String message,
            List<String> attachments,
            DateTime timestamp,
            String? orgId,
            String? cityId,
            String? assetId,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageEntity():
        return $default(
            _that.id,
            _that.chatId,
            _that.senderId,
            _that.receiverId,
            _that.groupId,
            _that.message,
            _that.attachments,
            _that.timestamp,
            _that.orgId,
            _that.cityId,
            _that.assetId,
            _that.createdAt,
            _that.updatedAt);
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
            String chatId,
            String senderId,
            String? receiverId,
            String? groupId,
            String message,
            List<String> attachments,
            DateTime timestamp,
            String? orgId,
            String? cityId,
            String? assetId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageEntity() when $default != null:
        return $default(
            _that.id,
            _that.chatId,
            _that.senderId,
            _that.receiverId,
            _that.groupId,
            _that.message,
            _that.attachments,
            _that.timestamp,
            _that.orgId,
            _that.cityId,
            _that.assetId,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatMessageEntity implements ChatMessageEntity {
  const _ChatMessageEntity(
      {required this.id,
      required this.chatId,
      required this.senderId,
      this.receiverId,
      this.groupId,
      required this.message,
      final List<String> attachments = const <String>[],
      required this.timestamp,
      this.orgId,
      this.cityId,
      this.assetId,
      this.createdAt,
      this.updatedAt})
      : _attachments = attachments;
  factory _ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);

  @override
  final String id;
  @override
  final String chatId;
  @override
  final String senderId;
  @override
  final String? receiverId;
  @override
  final String? groupId;
  @override
  final String message;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final DateTime timestamp;
  @override
  final String? orgId;
  @override
  final String? cityId;
  @override
  final String? assetId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of ChatMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatMessageEntityCopyWith<_ChatMessageEntity> get copyWith =>
      __$ChatMessageEntityCopyWithImpl<_ChatMessageEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatMessageEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessageEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      chatId,
      senderId,
      receiverId,
      groupId,
      message,
      const DeepCollectionEquality().hash(_attachments),
      timestamp,
      orgId,
      cityId,
      assetId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'ChatMessageEntity(id: $id, chatId: $chatId, senderId: $senderId, receiverId: $receiverId, groupId: $groupId, message: $message, attachments: $attachments, timestamp: $timestamp, orgId: $orgId, cityId: $cityId, assetId: $assetId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ChatMessageEntityCopyWith<$Res>
    implements $ChatMessageEntityCopyWith<$Res> {
  factory _$ChatMessageEntityCopyWith(
          _ChatMessageEntity value, $Res Function(_ChatMessageEntity) _then) =
      __$ChatMessageEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String chatId,
      String senderId,
      String? receiverId,
      String? groupId,
      String message,
      List<String> attachments,
      DateTime timestamp,
      String? orgId,
      String? cityId,
      String? assetId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$ChatMessageEntityCopyWithImpl<$Res>
    implements _$ChatMessageEntityCopyWith<$Res> {
  __$ChatMessageEntityCopyWithImpl(this._self, this._then);

  final _ChatMessageEntity _self;
  final $Res Function(_ChatMessageEntity) _then;

  /// Create a copy of ChatMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? receiverId = freezed,
    Object? groupId = freezed,
    Object? message = null,
    Object? attachments = null,
    Object? timestamp = null,
    Object? orgId = freezed,
    Object? cityId = freezed,
    Object? assetId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_ChatMessageEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _self.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: freezed == receiverId
          ? _self.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _self._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orgId: freezed == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
