// ============================================================================
// lib/presentation/auth/mappers/registration_summary_mapper.dart
//
// QUÉ HACE:
// Transforma RegistrationProgressModel en List<SummaryItem> legibles.
// - Detecta el método de autenticación y muestra solo los campos relevantes.
// - Convierte códigos técnicos a etiquetas legibles (CO → Colombia, etc.).
// - Omite campos nulos o vacíos.
//
// QUÉ NO HACE:
// - No accede a red ni a Isar (puro, sin efectos secundarios).
// - No hardcodea lógica de navegación ni de negocio.
//
// ENTERPRISE NOTES:
// - SummaryItem es un value object inmutable.
// - Los lookup maps son privados y extensibles sin cambiar la API pública.
// - Para agregar un nuevo país/región, basta añadir la entrada al mapa.
// ============================================================================

import '../../../data/models/auth/registration_progress_model.dart';

/// Valor inmutable que representa una fila del resumen de registro.
class SummaryItem {
  final String label;
  final String value;

  const SummaryItem({required this.label, required this.value});
}

/// Agrupación estructurada del resumen de registro por bloques lógicos.
///
/// Cada sección corresponde a un bloque editable en [SummaryPage]:
/// - [contactItems]  → bloque Contacto (teléfono, email, proveedor OAuth)
/// - [locationItems] → bloque Ubicación (país, región, ciudad)
/// - [profileItems]  → bloque Perfil inicial (tipo, empresa, rol)
class RegistrationSummaryData {
  final List<SummaryItem> contactItems;
  final List<SummaryItem> locationItems;
  final List<SummaryItem> profileItems;

  const RegistrationSummaryData({
    required this.contactItems,
    required this.locationItems,
    required this.profileItems,
  });

  bool get hasContact => contactItems.isNotEmpty;
  bool get hasLocation => locationItems.isNotEmpty;
  bool get hasProfile => profileItems.isNotEmpty;
}

/// Mapper sin estado que convierte un [RegistrationProgressModel] en una
/// lista de [SummaryItem] adaptada al método de autenticación usado.
class RegistrationSummaryMapper {
  RegistrationSummaryMapper._();

  /// Construye el resumen agrupado en tres bloques lógicos.
  ///
  /// Usar este método cuando la UI necesita secciones editables separadas.
  static RegistrationSummaryData buildGrouped(RegistrationProgressModel p) {
    final method = (p.authMethod ?? 'phone').toLowerCase();

    // ── Bloque Contacto ────────────────────────────────────────────────────
    final contact = <SummaryItem>[];

    if (method == 'google') {
      contact.add(const SummaryItem(label: 'Cuenta vinculada', value: 'Google'));
    } else if (method == 'apple') {
      contact.add(const SummaryItem(label: 'Cuenta vinculada', value: 'Apple'));
    } else if (method == 'facebook') {
      contact.add(const SummaryItem(label: 'Cuenta vinculada', value: 'Facebook'));
    }
    if (p.phone?.isNotEmpty == true) {
      contact.add(SummaryItem(label: 'Número de teléfono', value: p.phone!));
    }
    if (p.email?.isNotEmpty == true) {
      contact.add(SummaryItem(label: 'Correo electrónico', value: p.email!));
    }

    // ── Bloque Ubicación ──────────────────────────────────────────────────
    final location = <SummaryItem>[];

    if (p.countryId?.isNotEmpty == true) {
      location
          .add(SummaryItem(label: 'País', value: _countryLabel(p.countryId!)));
    }
    if (p.regionId?.isNotEmpty == true) {
      location.add(
          SummaryItem(label: 'Región / Estado', value: _regionLabel(p.regionId!)));
    }
    if (p.cityId?.isNotEmpty == true) {
      location.add(SummaryItem(label: 'Ciudad', value: _cityLabel(p.cityId!)));
    }

    // ── Bloque Perfil inicial ─────────────────────────────────────────────
    final profile = <SummaryItem>[];

    if (p.titularType?.isNotEmpty == true) {
      profile.add(SummaryItem(
          label: 'Tipo de usuario', value: _titularLabel(p.titularType!)));
    }
    if ((p.titularType ?? '').toLowerCase() == 'empresa' &&
        p.companyName?.trim().isNotEmpty == true) {
      profile.add(
          SummaryItem(label: 'Nombre de empresa', value: p.companyName!.trim()));
    }
    if (p.selectedRole?.isNotEmpty == true) {
      profile.add(
          SummaryItem(label: 'Rol inicial', value: _roleLabel(p.selectedRole!)));
    }

    return RegistrationSummaryData(
      contactItems: contact,
      locationItems: location,
      profileItems: profile,
    );
  }

  /// Construye la lista plana (todos los items, sin agrupación).
  ///
  /// Conservado por compatibilidad. Preferir [buildGrouped] para UIs con bloques.
  static List<SummaryItem> build(RegistrationProgressModel p) {
    final items = <SummaryItem>[];
    final method = (p.authMethod ?? 'phone').toLowerCase();

    // ── Sección: Método de autenticación ────────────────────────────────────

    if (method == 'google') {
      items.add(const SummaryItem(
        label: 'Cuenta vinculada',
        value: 'Google',
      ));
    } else if (method == 'apple') {
      items.add(const SummaryItem(
        label: 'Cuenta vinculada',
        value: 'Apple',
      ));
    } else if (method == 'facebook') {
      items.add(const SummaryItem(
        label: 'Cuenta vinculada',
        value: 'Facebook',
      ));
    }

    // Número de teléfono — siempre disponible en flujo OTP; también en MFA federado.
    if (p.phone?.isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'Número de teléfono',
        value: p.phone!,
      ));
    }

    // Correo electrónico — solo si existe (Google provee, OTP no).
    if (p.email?.isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'Correo electrónico',
        value: p.email!,
      ));
    }

    // ── Sección: Ubicación ────────────────────────────────────────────────

    if (p.countryId?.isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'País',
        value: _countryLabel(p.countryId!),
      ));
    }

    if (p.regionId?.isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'Región / Estado',
        value: _regionLabel(p.regionId!),
      ));
    }

    if (p.cityId?.isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'Ciudad',
        value: _cityLabel(p.cityId!),
      ));
    }

    // ── Sección: Tipo de usuario ──────────────────────────────────────────

    if (p.titularType?.isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'Tipo de usuario',
        value: _titularLabel(p.titularType!),
      ));
    }

    // Nombre de empresa — solo si es titular de tipo empresa.
    if ((p.titularType ?? '').toLowerCase() == 'empresa' &&
        p.companyName?.trim().isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'Nombre de empresa',
        value: p.companyName!.trim(),
      ));
    }

    // ── Sección: Rol ─────────────────────────────────────────────────────

    if (p.selectedRole?.isNotEmpty == true) {
      items.add(SummaryItem(
        label: 'Rol inicial',
        value: _roleLabel(p.selectedRole!),
      ));
    }

    return items;
  }

  // ── Lookup tables ───────────────────────────────────────────────────────

  static String _countryLabel(String code) {
    const map = {
      'CO': 'Colombia',
      'MX': 'México',
      'US': 'Estados Unidos',
      'AR': 'Argentina',
      'CL': 'Chile',
      'PE': 'Perú',
      'EC': 'Ecuador',
      'VE': 'Venezuela',
      'PA': 'Panamá',
      'CR': 'Costa Rica',
    };
    return map[code.toUpperCase()] ?? code;
  }

  static String _regionLabel(String code) {
    const map = {
      // Colombia — departamentos (ISO 3166-2:CO)
      'CO-ANT': 'Antioquia',
      'CO-ATL': 'Atlántico',
      'CO-BOG': 'Bogotá D.C.',
      'CO-BOL': 'Bolívar',
      'CO-BOY': 'Boyacá',
      'CO-CAL': 'Caldas',
      'CO-CAQ': 'Caquetá',
      'CO-CAU': 'Cauca',
      'CO-CES': 'Cesar',
      'CO-CHO': 'Chocó',
      'CO-COR': 'Córdoba',
      'CO-CUN': 'Cundinamarca',
      'CO-GUA': 'Guainía',
      'CO-GUV': 'Guaviare',
      'CO-HUI': 'Huila',
      'CO-LGU': 'La Guajira',
      'CO-MAG': 'Magdalena',
      'CO-MET': 'Meta',
      'CO-NAR': 'Nariño',
      'CO-NSA': 'Norte de Santander',
      'CO-PUT': 'Putumayo',
      'CO-QUI': 'Quindío',
      'CO-RIS': 'Risaralda',
      'CO-SAP': 'San Andrés y Providencia',
      'CO-SAN': 'Santander',
      'CO-SUC': 'Sucre',
      'CO-TOL': 'Tolima',
      'CO-VAC': 'Valle del Cauca',
      'CO-VAU': 'Vaupés',
      'CO-VID': 'Vichada',
      'CO-ARA': 'Arauca',
      'CO-AMZ': 'Amazonas',
    };
    return map[code.toUpperCase()] ?? _humanizeCode(code);
  }

  /// Convierte un código de ciudad (ej. 'CO-ATL-BARRANQUILLA') a nombre
  /// legible extrayendo y formateando el segmento final.
  static String _cityLabel(String code) {
    final parts = code.split('-');
    // Si el código tiene al menos 3 partes, el nombre es la tercera en adelante.
    if (parts.length >= 3) {
      return parts
          .sublist(2)
          .join(' ')
          .toLowerCase()
          .split(' ')
          .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
    }
    // Fallback: humanizar el código tal cual.
    return _humanizeCode(code);
  }

  /// Formatea un código técnico a texto legible:
  /// 'CO-ATL-BARRANQUILLA' → 'Barranquilla'
  /// 'CO-ATL' → 'Co Atl'
  static String _humanizeCode(String code) {
    return code
        .replaceAll('-', ' ')
        .toLowerCase()
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static String _titularLabel(String type) {
    switch (type.toLowerCase()) {
      case 'persona':
        return 'Persona natural';
      case 'empresa':
        return 'Empresa / Organización';
      default:
        return type;
    }
  }

  static String _roleLabel(String code) {
    switch (code) {
      case 'admin_activos_ind':
      case 'admin_activos_org':
        return 'Administrador de activos';
      case 'propietario':
      case 'propietario_emp':
        return 'Propietario';
      case 'proveedor':
        return 'Proveedor';
      case 'arrendatario':
      case 'arrendatario_emp':
        return 'Arrendatario';
      case 'asesor_seguros':
        return 'Asesor de seguros';
      case 'aseguradora':
        return 'Aseguradora';
      case 'abogado':
      case 'abogados_firma':
        return 'Abogado';
      default:
        // Fallback: capitalizar el code tal cual para no mostrar texto técnico.
        return code.isEmpty
            ? code
            : '${code[0].toUpperCase()}${code.substring(1).replaceAll('_', ' ')}';
    }
  }
}
