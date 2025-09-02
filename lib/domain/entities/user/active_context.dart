import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_context.freezed.dart';
part 'active_context.g.dart';

@freezed
  @JsonSerializable(explicitToJson: true)
abstract class ActiveContext with _$ActiveContext {
  const factory ActiveContext({
    required String orgId,
    required String orgName,
    required String rol,
  }) = _ActiveContext;

  factory ActiveContext.fromJson(Map<String, dynamic> json) => _$ActiveContextFromJson(json);
}
