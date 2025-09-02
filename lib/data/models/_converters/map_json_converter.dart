import 'dart:convert';

class MapJsonConverter {
  const MapJsonConverter();

  Map<String, dynamic> fromIsar(String object) {
    final decoded = jsonDecode(object);
    return decoded is Map<String, dynamic>
        ? decoded
        : Map<String, dynamic>.from(decoded as Map);
  }

  String toIsar(Map<String, dynamic> object) => jsonEncode(object);
}

class MapStrStrConverter {
  const MapStrStrConverter();

  Map<String, String> fromIsar(String object) {
    final decoded = jsonDecode(object);
    final map = Map<String, dynamic>.from(decoded as Map);
    return map.map((k, v) => MapEntry(k, v?.toString() ?? ''));
  }

  String toIsar(Map<String, String> object) => jsonEncode(object);
}
