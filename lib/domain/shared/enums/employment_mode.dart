// lib/domain/shared/enums/employment_mode.dart
// Enum para modalidad de empleo con serialización wire-stable.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: enum para modalidad de empleo con mapeo a wire names estables.
enum EmploymentMode {
  empleado,
  contratista,
  flexible,
  otro,
}

// Comentarios en el código: extensión para serialización y parseo de EmploymentMode.
extension EmploymentModeWire on EmploymentMode {
  String get wireName {
    switch (this) {
      case EmploymentMode.empleado:
        return 'empleado';
      case EmploymentMode.contratista:
        return 'contratista';
      case EmploymentMode.flexible:
        return 'flexible';
      case EmploymentMode.otro:
        return 'otro';
    }
  }

  static EmploymentMode fromWire(String? raw) {
    if (raw == null) return EmploymentMode.otro;
    switch (raw.trim().toLowerCase()) {
      case 'empleado':
        return EmploymentMode.empleado;
      case 'contratista':
        return EmploymentMode.contratista;
      case 'flexible':
        return EmploymentMode.flexible;
      default:
        return EmploymentMode.otro;
    }
  }
}
