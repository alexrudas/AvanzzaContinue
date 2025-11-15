import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum UserDocument {
  /// Cedula
  cardId,

  /// Licencia de conducción
  drivingLicense,

  /// Tarjeta de propiedad
  ownershipCard,

  /// Tarjeta de operación
  operationCard,
}

final DateFormat birthDateFormat = DateFormat.yMMMd('es_ES');

int parseStringToInt(String value) {
  return int.tryParse(value.replaceAll(".", "")) ?? 0;
}

class ScannerDocumentModel {
  String? codigoAfis;
  String? numeroTarjetaPropiedad;
  String? tarjetaDactilar;
  String? numeroDocumento;
  UserDocument userDocument;
  String? docId;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? primerNombre;
  String? segundoNombre;
  String? genero;
  String? fechaNacimiento;
  String? anio;
  String? mes;
  String? dia;
  String? municipio;
  String? departamento;
  String? tipoSangre;
  String? licenciaDeConducir;
  String? tipoDeLicencia;
  String? tipoVehiculo;
  String? idPropietario;
  String? tipoDeOperacion;
  String? areaDeOperacion;
  String? nit;
  String? fechaInicio;
  String? fechaFin;
  String? numeroLibretaDeOperacion;
  String? direccionNotificacion;
  String? numeroDePlaca;
  String? area;
  String? fechaExpedicion;
  String? numeroChasis;
  String? fullDecode;
  String? empresaTransporte;

  ScannerDocumentModel({
    this.codigoAfis,
    this.numeroTarjetaPropiedad,
    this.tarjetaDactilar,
    required this.userDocument,
    this.numeroDocumento,
    this.docId,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.primerNombre,
    this.segundoNombre,
    this.genero,
    this.fechaNacimiento,
    this.anio,
    this.mes,
    this.dia,
    this.municipio,
    this.departamento,
    this.tipoSangre,
    this.licenciaDeConducir,
    this.tipoDeLicencia,
    this.tipoVehiculo,
    this.idPropietario,
    this.tipoDeOperacion,
    this.areaDeOperacion,
    this.nit,
    this.fechaInicio,
    this.fechaFin,
    this.area,
    this.numeroLibretaDeOperacion,
    this.direccionNotificacion,
    this.numeroDePlaca,
    this.fechaExpedicion,
    this.numeroChasis,
    this.fullDecode,
    this.empresaTransporte,
  });

  DateTime? getFechaNacimiento() => anio != null && mes != null && dia != null
      ? DateTime(int.parse(anio!), int.parse(mes!), int.parse(dia!))
      : null;

  String getFechaNacimientoComoString() =>
      (dia != null && mes != null && anio != null)
          ? birthDateFormat
              .format(
                DateTime(
                  parseStringToInt(anio!),
                  parseStringToInt(mes!),
                  parseStringToInt(dia!),
                ),
              )
              .capitalize!
          : "";

  String get nombres => "${primerNombre ?? ""} ${segundoNombre ?? ""}";
  String get apellidos => "${apellidoPaterno ?? ""} ${apellidoMaterno ?? ""}";
  String get nombreCompleto =>
      "${primerNombre ?? ""} ${segundoNombre ?? ""} ${apellidoPaterno ?? ""} ${apellidoMaterno ?? ""} ";
  String get cedula => "CC"
      " ${numeroDocumento ?? ""}";

  String get nombreGenero => genero != null
      ? (genero == "F" || genero == "f")
          ? "Femenino"
          : "Masculino"
      : "";

  String edad() {
    final fechaDeNacimiento = getFechaNacimiento();

    if (fechaDeNacimiento != null) {
      return (fechaDeNacimiento.difference(DateTime.now()).inDays.abs() ~/ 365)
          .toString();
    }
    return "";
  }

  //-------------Licencia de conducir----------------------////////////////////////////////

  String get categoriaLicenciaConducir => tipoDeLicencia ?? "";
  String get numeroLicenciaConducir => licenciaDeConducir ?? "";

  //-------------Tarjeta de Propiedad Vehículo----------------------////////////////////////////////

  String get placa => numeroDePlaca ?? "";
  // String get chasis => numeroChasis ?? "";String get tarjetaPropiedad => numeroTarjetaPropiedad ?? "";

  //-------------Tarjeta de Operación del Vehículo----------------------////////////////////////////////

  String get nombreEmpresaTransporte => nit != null
      ? (nit == "802001960")
          ? "AUTOTAXI"
          : ""
      : "";

  static ScannerDocumentModel mock() {
//ya vuelvo
    final Random random = Random();

    // === Pool de nombres y apellidos ===
    final data = [
      ["1042417555", "JONATAN ENRIQUE", "PAREJO", "ORTIZ", "M"],
      ["72283973", "SERGIO LUIS", "GUETTE", "OROZCO", "M"],
      ["8789394", "JOHN JAIRO", "ARENAS", "RODRIGUEZ", "M"],
      ["8645143", "ARCENIO RAFAEL", "VILORIA", "CORONADO", "M"],
      ["1007894071", "DAYAM EFREI", "MORALES", "MATOS", "M"],
      ["19895348", "AGEOVALDI ", "PARRA", "SARMIENTO", "M"],
      ["72182645 ", "JHONNY ENRIQUE", "HERNANDEZ", "GAMEZ", "M"],
      ["8776426 ", "RAFAEL ANTONIO", "MANJARRES", "MARIN", "M"],
      ["72257281 ", "VICTOR ANTONIO", "BOHORQUEZ", "TARRA", "M"]
    ];

    final selected = data[random.nextInt(data.length)];
    return ScannerDocumentModel(
      userDocument: UserDocument.cardId,
      numeroDocumento: selected[0],
      docId: 'doc_${random.nextInt(1000)}',
      primerNombre: selected[1].split(" ")[0],
      segundoNombre: selected[1].split(" ")[1],
      apellidoPaterno: selected[2],
      apellidoMaterno: selected[3],
      genero: selected[4],
      anio: '1990',
      mes: '05',
      dia: '10',
      fechaNacimiento: '1990-05-10',
      municipio: 'Bogotá',
      departamento: 'Cundinamarca',
      tipoSangre: 'O+',
      licenciaDeConducir: '987654321',
      tipoDeLicencia: 'B1',
      tipoVehiculo: 'Particular',
      idPropietario: 'owner_001',
      tipoDeOperacion: 'Servicio Público',
      areaDeOperacion: 'Urbano',
      nit: '802001960',
      fechaInicio: '2024-01-01',
      fechaFin: '2025-01-01',
      numeroLibretaDeOperacion: 'LO-2024-123',
      direccionNotificacion: 'Calle 123 #45-67',
      numeroDePlaca: 'ABC${random.nextInt(900) + 100}',
      area: 'Zona Norte',
      fechaExpedicion: '2024-01-02',
      numeroChasis: 'CHS${random.nextInt(1000000)}',
      numeroTarjetaPropiedad: 'TP-2024-${random.nextInt(999)}',
      tarjetaDactilar: 'TD-${random.nextInt(999999)}',
      codigoAfis: 'AFS-${random.nextInt(99999)}',
      fullDecode: 'Información decodificada completa',
      empresaTransporte: 'AUTOTAXI',
    );
  }
}
