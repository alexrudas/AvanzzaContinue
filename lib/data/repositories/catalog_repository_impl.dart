import '../../domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  // Catálogo mínimo en memoria; clave (providerType, segment)
  // Soporta order y es extensible
  static const String _version = '2025.10';
  @override
  String get version => _version;

  static final Map<String, List<Map<String, dynamic>>> _categories = {
    // Productos / Vehículos
    'articulos|vehiculos': [
      {'id': 'lubricentro', 'label': 'Lubricentro', 'order': 1},
      {'id': 'llanteria', 'label': 'Llantería', 'order': 2},
      {'id': 'carwash', 'label': 'CarWash', 'order': 3},
      {'id': 'accesorios', 'label': 'Accesorios', 'order': 4},
    ],
    // Servicios / Vehículos
    'servicios|vehiculos': [
      {'id': 'taller_mecanico', 'label': 'Taller mecánico', 'order': 1},
      {'id': 'diagnostico', 'label': 'Diagnóstico', 'order': 2},
      {'id': 'pintura_carroceria', 'label': 'Pintura/Carrocería', 'order': 3},
    ],
    // Productos / Inmuebles
    'articulos|inmuebles': [
      {'id': 'ferreteria', 'label': 'Ferretería', 'order': 1},
      {'id': 'pisos_enchapes', 'label': 'Pisos y enchapes', 'order': 2},
      {'id': 'pinturas', 'label': 'Pinturas', 'order': 3},
      {'id': 'plomeria_insumos', 'label': 'Insumos de plomería', 'order': 4},
    ],
    // Servicios / Inmuebles
    'servicios|inmuebles': [
      {'id': 'plomeria', 'label': 'Plomería', 'order': 1},
      {'id': 'electricidad', 'label': 'Electricidad', 'order': 2},
      {'id': 'pintura', 'label': 'Pintura', 'order': 3},
      {'id': 'aseo', 'label': 'Aseo', 'order': 4},
    ],
  };

  String _key(String type, String segment) => '${type.toLowerCase()}|${segment.toLowerCase()}';

  @override
  List<Map<String, dynamic>> getProviderCategories(String providerType, String segment) {
    final list = _categories[_key(providerType, segment)] ?? const [];
    final ordered = [...list]..sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
    return ordered;
  }
}
