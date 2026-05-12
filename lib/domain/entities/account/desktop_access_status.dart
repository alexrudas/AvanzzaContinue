// ============================================================================
// lib/domain/entities/account/desktop_access_status.dart
// Estado del acceso para escritorio (username/password) del usuario actual.
//
// Discriminador cerrado — sin Map<String, dynamic> ni strings sueltos. La
// presentación solo debe ramificar sobre [kind] y leer [username] cuando
// aplique.
// ============================================================================

enum DesktopAccessStateKind {
  /// El usuario aún no ha vinculado una credencial email/password al UID.
  notConfigured,

  /// El usuario tiene una credencial password vinculada y un username
  /// reservado en Firestore.
  configured,
}

class DesktopAccessStatus {
  final DesktopAccessStateKind kind;

  /// Username (alias) configurado para login desktop. Solo presente cuando
  /// [kind] == [DesktopAccessStateKind.configured].
  final String? username;

  const DesktopAccessStatus.notConfigured()
      : kind = DesktopAccessStateKind.notConfigured,
        username = null;

  const DesktopAccessStatus.configured({required this.username})
      : kind = DesktopAccessStateKind.configured;

  bool get isConfigured => kind == DesktopAccessStateKind.configured;
}
