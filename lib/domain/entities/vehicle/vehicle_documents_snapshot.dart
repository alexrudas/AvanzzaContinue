// ============================================================================
// lib/domain/entities/vehicle/vehicle_documents_snapshot.dart
// Domain Layer - Agregador de estado documental de vehículo
// Dart puro (sin dependencias externas excepto modelos propios)
// ============================================================================

import '../../../data/runt/models/runt_vehicle_models.dart';
import 'vehicle_document_status.dart';

/// Agregador de dominio inmutable que representa el ESTADO DOCUMENTAL GLOBAL
/// de un vehículo, derivado de documentos normalizados.
///
/// Proporciona una vista consolidada del estado de todos los documentos
/// requeridos (SOAT, RTM, RC) con lógica de negocio para determinar
/// cumplimiento y prioridades de atención.
class VehicleDocumentsSnapshot {
  /// Lista de documentos normalizados, ordenados por prioridad.
  ///
  /// Orden: Vencidos → Por Vencer → Vigentes → Desconocidos
  /// Dentro de cada grupo: ordenados por daysToExpire ascendente.
  final List<VehicleDocumentStatus> documents;

  /// Constructor privado - usar factories.
  const VehicleDocumentsSnapshot._({
    required this.documents,
  });

  // ===========================================================================
  // GETTERS COMPUTADOS - LÓGICA DE NEGOCIO
  // ===========================================================================

  /// True si algún documento tiene status == vencido.
  bool get hasExpiredDocuments {
    return documents.any(
      (doc) => doc.status == DocumentValidityStatus.vencido,
    );
  }

  /// True si algún documento tiene status == porVencer.
  bool get hasDocumentsAboutToExpire {
    return documents.any(
      (doc) => doc.status == DocumentValidityStatus.porVencer,
    );
  }

  /// True SOLO SI:
  /// - NO hay documentos vencidos
  /// - NO hay documentos por vencer
  /// - Y documents NO está vacía
  bool get isVehicleCompliant {
    if (documents.isEmpty) return false;
    return !hasExpiredDocuments && !hasDocumentsAboutToExpire;
  }

  /// True si hay documentos vencidos O por vencer.
  bool get requiresAttention {
    return hasExpiredDocuments || hasDocumentsAboutToExpire;
  }

  /// Devuelve el documento que requiere atención inmediata.
  ///
  /// Prioridad:
  /// 1. Documento vencido con daysToExpire más bajo (más negativo = más crítico)
  /// 2. Si no hay vencidos, documento porVencer con menor daysToExpire
  ///
  /// Retorna null si todos están vigentes o la lista está vacía.
  VehicleDocumentStatus? get mostCriticalDocument {
    if (documents.isEmpty) return null;

    // Buscar vencidos (prioridad 1)
    final expired = documents
        .where((d) => d.status == DocumentValidityStatus.vencido)
        .toList();

    if (expired.isNotEmpty) {
      // Ordenar por daysToExpire ascendente (más negativo primero)
      expired.sort((a, b) {
        final daysA = a.daysToExpire ?? 0;
        final daysB = b.daysToExpire ?? 0;
        return daysA.compareTo(daysB);
      });
      return expired.first;
    }

    // Buscar por vencer (prioridad 2)
    final aboutToExpire = documents
        .where((d) => d.status == DocumentValidityStatus.porVencer)
        .toList();

    if (aboutToExpire.isNotEmpty) {
      // Ordenar por daysToExpire ascendente (menor primero)
      aboutToExpire.sort((a, b) {
        final daysA = a.daysToExpire ?? 0;
        final daysB = b.daysToExpire ?? 0;
        return daysA.compareTo(daysB);
      });
      return aboutToExpire.first;
    }

    // Todos vigentes o desconocidos
    return null;
  }

  // ===========================================================================
  // GETTERS DE CONVENIENCIA
  // ===========================================================================

  /// Obtiene el estado del SOAT, si existe.
  VehicleDocumentStatus? get soat {
    return _findByType('SOAT');
  }

  /// Obtiene el estado de la RTM, si existe.
  VehicleDocumentStatus? get rtm {
    return _findByType('RTM');
  }

  /// Obtiene el estado del RC Contractual, si existe.
  VehicleDocumentStatus? get rcContractual {
    return _findByType('RC_CONTRACTUAL');
  }

  /// Obtiene el estado del RC Extracontractual, si existe.
  VehicleDocumentStatus? get rcExtraContractual {
    return _findByType('RC_EXTRACONTRACTUAL');
  }

  /// Busca un documento por tipo.
  VehicleDocumentStatus? _findByType(String documentType) {
    for (final doc in documents) {
      if (doc.documentType == documentType) return doc;
    }
    return null;
  }

  /// Cantidad total de documentos.
  int get documentCount => documents.length;

  /// Cantidad de documentos vencidos.
  int get expiredCount {
    return documents
        .where((d) => d.status == DocumentValidityStatus.vencido)
        .length;
  }

  /// Cantidad de documentos por vencer.
  int get aboutToExpireCount {
    return documents
        .where((d) => d.status == DocumentValidityStatus.porVencer)
        .length;
  }

  // ===========================================================================
  // FACTORY - DESDE RUNT DATA
  // ===========================================================================

  /// Crea un snapshot a partir de datos RUNT.
  ///
  /// Extrae las listas de documentos del [runtData], las procesa con
  /// [VehicleDocumentStatusResolver] y construye la lista ordenada.
  factory VehicleDocumentsSnapshot.fromRuntData({
    required RuntVehicleData runtData,
  }) {
    final documents = <VehicleDocumentStatus>[];

    // Resolver SOAT
    final soatMaps = runtData.soat.map((e) => e.toJson()).toList();
    final soatStatus = VehicleDocumentStatusResolver.resolveSoat(soatMaps);
    if (soatStatus != null) {
      documents.add(soatStatus);
    }

    // Resolver RTM
    final rtmMaps = runtData.rtmHistory.map((e) => e.toJson()).toList();
    final rtmStatus = VehicleDocumentStatusResolver.resolveRtm(rtmMaps);
    if (rtmStatus != null) {
      documents.add(rtmStatus);
    }

    // Resolver RC (puede devolver 0, 1 o 2 documentos)
    final rcMaps = runtData.rcInsurances.map((e) => e.toJson()).toList();
    final rcStatuses =
        VehicleDocumentStatusResolver.resolveRcInsurances(rcMaps);
    documents.addAll(rcStatuses);

    // Ordenar por prioridad
    final sortedDocuments = _sortByPriority(documents);

    return VehicleDocumentsSnapshot._(documents: sortedDocuments);
  }

  /// Factory para crear snapshot vacío.
  factory VehicleDocumentsSnapshot.empty() {
    return const VehicleDocumentsSnapshot._(documents: []);
  }

  /// Factory desde lista de documentos ya normalizados.
  factory VehicleDocumentsSnapshot.fromDocuments(
    List<VehicleDocumentStatus> documents,
  ) {
    final sortedDocuments = _sortByPriority(documents);
    return VehicleDocumentsSnapshot._(documents: sortedDocuments);
  }

  // ===========================================================================
  // ORDENAMIENTO POR PRIORIDAD
  // ===========================================================================

  /// Ordena documentos por prioridad:
  /// 1. Vencidos (daysToExpire ascendente - más antiguo primero)
  /// 2. Por Vencer (daysToExpire ascendente - más próximo primero)
  /// 3. Vigentes (daysToExpire ascendente)
  /// 4. Desconocidos
  static List<VehicleDocumentStatus> _sortByPriority(
    List<VehicleDocumentStatus> documents,
  ) {
    if (documents.isEmpty) return const [];

    // Separar por status
    final vencidos = <VehicleDocumentStatus>[];
    final porVencer = <VehicleDocumentStatus>[];
    final vigentes = <VehicleDocumentStatus>[];
    final desconocidos = <VehicleDocumentStatus>[];

    for (final doc in documents) {
      switch (doc.status) {
        case DocumentValidityStatus.vencido:
          vencidos.add(doc);
        case DocumentValidityStatus.porVencer:
          porVencer.add(doc);
        case DocumentValidityStatus.vigente:
          vigentes.add(doc);
        case DocumentValidityStatus.desconocido:
          desconocidos.add(doc);
      }
    }

    // Ordenar cada grupo por daysToExpire ascendente
    int compareDays(VehicleDocumentStatus a, VehicleDocumentStatus b) {
      final daysA = a.daysToExpire ?? 0;
      final daysB = b.daysToExpire ?? 0;
      return daysA.compareTo(daysB);
    }

    vencidos.sort(compareDays);
    porVencer.sort(compareDays);
    vigentes.sort(compareDays);
    // desconocidos no tienen daysToExpire, mantener orden original

    // Concatenar en orden de prioridad
    return [
      ...vencidos,
      ...porVencer,
      ...vigentes,
      ...desconocidos,
    ];
  }

  // ===========================================================================
  // STANDARD OVERRIDES
  // ===========================================================================

  @override
  String toString() {
    return 'VehicleDocumentsSnapshot('
        'count: ${documents.length}, '
        'compliant: $isVehicleCompliant, '
        'expired: $expiredCount, '
        'aboutToExpire: $aboutToExpireCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VehicleDocumentsSnapshot) return false;
    if (documents.length != other.documents.length) return false;
    for (int i = 0; i < documents.length; i++) {
      if (documents[i] != other.documents[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(documents);
}
