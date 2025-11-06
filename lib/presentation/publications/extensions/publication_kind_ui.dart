// lib/presentation/publications/extensions/publication_kind_ui.dart
// Capa de presentación: aquí sí se permite Flutter y el Design System.

import 'package:flutter/material.dart';
import '../../../core/design_system/semantic_tone.dart';
import '../../../domain/publications/entities/kinds/publication_kind.dart';

/// Extensión UI para PublicationKind.
/// Provee iconos, tonos semánticos y textos fallback.
extension PublicationKindUI on PublicationKind {
  /// Texto fallback en español.
  /// TODO: Reemplazar con AppLocalizations.of(context).translate(i18nKey)
  String displayFallbackEs() {
    switch (this) {
      case PublicationKind.driverSeek:
        return 'Busco Vehículo (Conductor)';
      case PublicationKind.tenantSeek:
        return 'Busco Inmueble';
      case PublicationKind.productOffer:
        return 'Oferta de Productos';
      case PublicationKind.serviceOffer:
        return 'Oferta de Servicios';
      case PublicationKind.branchAnnouncement:
        return 'Anuncio de Sede';
    }
  }

  /// Icono material semántico.
  IconData get icon {
    switch (this) {
      case PublicationKind.driverSeek:
        return Icons.search;
      case PublicationKind.tenantSeek:
        return Icons.home_work_outlined;
      case PublicationKind.productOffer:
        return Icons.inventory_2_outlined;
      case PublicationKind.serviceOffer:
        return Icons.handyman_outlined;
      case PublicationKind.branchAnnouncement:
        return Icons.storefront_outlined;
    }
  }

  /// Tono semántico para mapear a SemanticColors.
  SemanticTone get tone {
    switch (this) {
      case PublicationKind.driverSeek:
        return SemanticTone.info;
      case PublicationKind.tenantSeek:
        return SemanticTone.primary;
      case PublicationKind.productOffer:
        return SemanticTone.success;
      case PublicationKind.serviceOffer:
        return SemanticTone.warning;
      case PublicationKind.branchAnnouncement:
        return SemanticTone.accent;
    }
  }
}
