// lib/domain/entities/workspace/workspace_type.dart

/// Enum canónico de tipos de workspace en AVANZZA.
///
/// Este enum reemplaza el patrón legacy basado en strings de rol
/// (`isAdmin`, `isOwner`, `rol.contains(...)`, etc.) por un sistema
/// tipado y estable para bootstrap, navegación y resolución de contexto.
///
/// REGLA DE ESTABILIDAD (WIRE STABILITY):
/// - Nunca renombrar valores existentes.
/// - Si un valor debe cambiarse, agregar uno nuevo y deprecar el anterior
///   durante el periodo de migración correspondiente.
///
/// IMPORTANTE:
/// Este archivo pertenece a la capa de dominio.
/// No debe depender de Flutter, Material, GetX ni artefactos de UI.
enum WorkspaceType {
  /// Gestión operativa completa de activos.
  ///
  /// Corresponde al contexto principal de administración de vehículos,
  /// inmuebles u otros activos, incluyendo operación, mantenimiento,
  /// documentación, compras y contabilidad.
  assetAdmin,

  /// Workspace del propietario/inversionista.
  ///
  /// Representa una experiencia de supervisión patrimonial:
  /// lectura, seguimiento, delegación y revocación de administradores.
  ///
  /// No implica necesariamente gestión operativa directa del activo.
  owner,

  /// Workspace del arrendatario / usuario operativo bajo contrato.
  ///
  /// Este contexto se enfoca en uso, pagos, incidencias, documentos
  /// y relación contractual con el activo.
  renter,

  /// Workspace de taller o centro de servicio técnico.
  ///
  /// Enfocado en diagnósticos, órdenes de trabajo, mantenimientos,
  /// agenda técnica y ejecución de servicio.
  workshop,

  /// Workspace de proveedor de bienes, insumos o repuestos.
  ///
  /// Orientado a catálogo, pedidos, cotizaciones y suministro físico.
  supplier,

  /// Workspace de aseguradora, broker o actor de pólizas.
  ///
  /// Orientado a siniestros, pólizas, renovaciones, reclamaciones
  /// y seguimiento asegurador.
  insurer,

  /// Workspace jurídico / legal.
  ///
  /// Para abogados, despachos, trámites legales, litigios,
  /// recuperación de cartera jurídica o soporte documental legal.
  legal,

  /// Workspace de asesoría externa o consultoría.
  ///
  /// Para auditores, consultores, asesores financieros,
  /// expertos externos u otros perfiles de acompañamiento.
  advisor,

  /// Contexto inválido, no reconocido o no resoluble.
  ///
  /// Debe disparar un flujo de cuarentena / recuperación / actualización
  /// y NUNCA otorgar acceso por defecto a paneles administrativos.
  unknown,
}

/// Extensiones semánticas de dominio para [WorkspaceType].
///
/// Estas extensiones están permitidas en la capa de dominio porque:
/// - no dependen de UI,
/// - no dependen de Flutter,
/// - y expresan reglas de negocio semánticas útiles para bootstrap,
///   validación de contexto y routing de alto nivel.
extension WorkspaceTypeX on WorkspaceType {
  /// Indica si este tipo representa el contexto operativo
  /// principal de administración de activos.
  bool get isAssetAdmin => this == WorkspaceType.assetAdmin;

  /// Indica si este tipo representa un contexto de supervisión
  /// patrimonial/propiedad más que de operación directa.
  bool get isOwner => this == WorkspaceType.owner;

  /// Indica si este tipo representa un usuario arrendatario
  /// o usuario operativo del activo bajo contrato.
  bool get isRenter => this == WorkspaceType.renter;

  /// Indica si este tipo pertenece al grupo de proveedores
  /// o contrapartes externas del ecosistema.
  ///
  /// IMPORTANTE:
  /// Esta agrupación es semántica y útil para ciertas decisiones
  /// transicionales, pero NO debe usarse para colapsar navegación,
  /// permisos o políticas de acceso distintas en un solo comportamiento.
  bool get isExternalProvider {
    switch (this) {
      case WorkspaceType.workshop:
      case WorkspaceType.supplier:
      case WorkspaceType.insurer:
      case WorkspaceType.legal:
      case WorkspaceType.advisor:
        return true;
      case WorkspaceType.assetAdmin:
      case WorkspaceType.owner:
      case WorkspaceType.renter:
      case WorkspaceType.unknown:
        return false;
    }
  }

  /// Indica si este contexto es inválido o desconocido.
  ///
  /// Este caso debe ser manejado por un validador o flow de recuperación,
  /// nunca por fallback automático a `assetAdmin`.
  bool get isInvalid => this == WorkspaceType.unknown;

  /// Indica si el contexto es utilizable para navegación normal.
  bool get isValid => !isInvalid;

  /// Nombre canónico estable del tipo de workspace.
  ///
  /// Útil para persistencia ligera, logging estructurado,
  /// telemetría, serialización o debugging técnico.
  ///
  /// No usar este getter como sustituto de un mapper formal
  /// si en el futuro se requiere serialización más estricta.
  String get wireName {
    switch (this) {
      case WorkspaceType.assetAdmin:
        return 'assetAdmin';
      case WorkspaceType.owner:
        return 'owner';
      case WorkspaceType.renter:
        return 'renter';
      case WorkspaceType.workshop:
        return 'workshop';
      case WorkspaceType.supplier:
        return 'supplier';
      case WorkspaceType.insurer:
        return 'insurer';
      case WorkspaceType.legal:
        return 'legal';
      case WorkspaceType.advisor:
        return 'advisor';
      case WorkspaceType.unknown:
        return 'unknown';
    }
  }

  /// Reconstruye un [WorkspaceType] a partir de su nombre estable.
  ///
  /// Si el valor recibido no coincide con ningún tipo conocido,
  /// retorna [WorkspaceType.unknown].
  static WorkspaceType fromWireName(String? value) {
    switch (value) {
      case 'assetAdmin':
        return WorkspaceType.assetAdmin;
      case 'owner':
        return WorkspaceType.owner;
      case 'renter':
        return WorkspaceType.renter;
      case 'workshop':
        return WorkspaceType.workshop;
      case 'supplier':
        return WorkspaceType.supplier;
      case 'insurer':
        return WorkspaceType.insurer;
      case 'legal':
        return WorkspaceType.legal;
      case 'advisor':
        return WorkspaceType.advisor;
      case 'unknown':
        return WorkspaceType.unknown;
      default:
        return WorkspaceType.unknown;
    }
  }
}
