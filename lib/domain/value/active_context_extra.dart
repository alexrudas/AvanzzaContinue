class ActiveContextExtra {
  final String? providerType; // 'servicios' | 'articulos'
  final List<String> categories; // categorías proveedor
  final List<String> assetTypes; // tipos de activos de interés

  const ActiveContextExtra({
    this.providerType,
    this.categories = const [],
    this.assetTypes = const [],
  });

  Map<String, dynamic> toMap() => {
        if (providerType != null) 'providerType': providerType,
        if (categories.isNotEmpty) 'categories': categories,
        if (assetTypes.isNotEmpty) 'assetTypes': assetTypes,
      };

  factory ActiveContextExtra.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const ActiveContextExtra();
    return ActiveContextExtra(
      providerType: map['providerType'] as String?,
      categories: (map['categories'] as List?)?.cast<String>() ?? const [],
      assetTypes: (map['assetTypes'] as List?)?.cast<String>() ?? const [],
    );
  }
}
