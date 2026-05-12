// ============================================================================
// lib/core/services/scanner/barcode_scanner_service.dart
// BARCODE SCANNER SERVICE — Interfaz cross-platform
// ============================================================================
// QUÉ HACE:
//   - Define el contrato para escanear códigos de barras (PDF417/QR/EAN/etc.)
//     que la app necesita para registro de cédula y otros flujos.
//   - El dominio y la UI consumen esta interfaz; nunca importan
//     `mobile_scanner` ni `google_mlkit_barcode_scanning` directamente.
//
// CONTRATO:
//   - `isAvailable`: indica si la plataforma actual soporta escaneo nativo.
//   - `scan(context)`: abre el escáner. Retorna `ScannerResult.success(text)`
//     o `.cancelled` o `.unsupported`.
//
// PHASE 0:
//   - Mobile impl envuelve el flujo existente (`MobileScanner` + MLKit).
//   - Windows stub devuelve siempre `.unsupported` para que la UI muestre
//     un mensaje "Función disponible en la app móvil" sin crashear.
// ============================================================================

import 'package:flutter/widgets.dart';

class ScannerResult {
  final String? rawValue;
  final _ScannerResultKind _kind;

  const ScannerResult._(this._kind, [this.rawValue]);

  factory ScannerResult.success(String rawValue) =>
      ScannerResult._(_ScannerResultKind.success, rawValue);

  factory ScannerResult.cancelled() =>
      const ScannerResult._(_ScannerResultKind.cancelled);

  factory ScannerResult.unsupported() =>
      const ScannerResult._(_ScannerResultKind.unsupported);

  bool get isSuccess => _kind == _ScannerResultKind.success;
  bool get isCancelled => _kind == _ScannerResultKind.cancelled;
  bool get isUnsupported => _kind == _ScannerResultKind.unsupported;
}

enum _ScannerResultKind { success, cancelled, unsupported }

abstract class BarcodeScannerService {
  bool get isAvailable;
  Future<ScannerResult> scan(BuildContext context);
}

/// Stub que siempre reporta no soportado. Lo usa Windows en Phase 0 y
/// también sirve como fallback seguro para tests/headless.
class UnsupportedBarcodeScannerService implements BarcodeScannerService {
  const UnsupportedBarcodeScannerService();

  @override
  bool get isAvailable => false;

  @override
  Future<ScannerResult> scan(BuildContext context) async =>
      ScannerResult.unsupported();
}
