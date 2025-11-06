// lib/domain/publications/entities/kinds/publication_kind.dart
// Dominio puro: sin Flutter, sin DS. Solo reglas y serialización estable.

/// Tipos de publicaciones disponibles en Avanzza.
enum PublicationKind {
  driverSeek, // Conductor busca vehículo
  tenantSeek, // Inquilino busca inmueble/local
  productOffer, // Proveedor ofrece productos
  serviceOffer, // Proveedor ofrece servicios
  branchAnnouncement, // Proveedor anuncia apertura de sede
}

/// Roles disponibles en el sistema de publicaciones.
enum UserRole {
  tenantDriver,
  tenantRenter,
  providerProducts,
  providerServices,
  admin, // definido pero no habilita creación por defecto
}

/// Helpers de dominio: roles válidos, serialización y parsers.
extension PublicationKindDomain on PublicationKind {
  /// Roles permitidos para crear cada tipo de publicación.
  Set<UserRole> get allowedRoles {
    switch (this) {
      case PublicationKind.driverSeek:
        return const {UserRole.tenantDriver, UserRole.tenantRenter};
      case PublicationKind.tenantSeek:
        return const {UserRole.tenantRenter};
      case PublicationKind.productOffer:
        return const {UserRole.providerProducts};
      case PublicationKind.serviceOffer:
        return const {UserRole.providerServices};
      case PublicationKind.branchAnnouncement:
        return const {UserRole.providerProducts, UserRole.providerServices};
    }
  }

  /// Clave i18n estable para resolución en UI.
  String get i18nKey {
    switch (this) {
      case PublicationKind.driverSeek:
        return 'publication.kind.driver_seek';
      case PublicationKind.tenantSeek:
        return 'publication.kind.tenant_seek';
      case PublicationKind.productOffer:
        return 'publication.kind.product_offer';
      case PublicationKind.serviceOffer:
        return 'publication.kind.service_offer';
      case PublicationKind.branchAnnouncement:
        return 'publication.kind.branch_announcement';
    }
  }

  /// Wire names explícitos y versionables: NO usar enum.name.
  /// Garantiza estabilidad ante refactors internos.
  String get wireName {
    switch (this) {
      case PublicationKind.driverSeek:
        return 'driver_seek';
      case PublicationKind.tenantSeek:
        return 'tenant_seek';
      case PublicationKind.productOffer:
        return 'product_offer';
      case PublicationKind.serviceOffer:
        return 'service_offer';
      case PublicationKind.branchAnnouncement:
        return 'branch_announcement';
    }
  }

  /// Parse seguro desde string externo.
  /// Lanza ArgumentError si el valor no es válido.
  static PublicationKind fromWire(String raw) {
    switch (raw) {
      case 'driver_seek':
        return PublicationKind.driverSeek;
      case 'tenant_seek':
        return PublicationKind.tenantSeek;
      case 'product_offer':
        return PublicationKind.productOffer;
      case 'service_offer':
        return PublicationKind.serviceOffer;
      case 'branch_announcement':
        return PublicationKind.branchAnnouncement;
      default:
        throw ArgumentError('PublicationKind desconocido: $raw');
    }
  }
}

/// Extensión para serialización de roles.
extension UserRoleWire on UserRole {
  String get wireName {
    switch (this) {
      case UserRole.tenantDriver:
        return 'tenant_driver';
      case UserRole.tenantRenter:
        return 'tenant_renter';
      case UserRole.providerProducts:
        return 'provider_products';
      case UserRole.providerServices:
        return 'provider_services';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromWire(String raw) {
    switch (raw) {
      case 'tenant_driver':
        return UserRole.tenantDriver;
      case 'tenant_renter':
        return UserRole.tenantRenter;
      case 'provider_products':
        return UserRole.providerProducts;
      case 'provider_services':
        return UserRole.providerServices;
      case 'admin':
        return UserRole.admin;
      default:
        throw ArgumentError('UserRole desconocido: $raw');
    }
  }
}
