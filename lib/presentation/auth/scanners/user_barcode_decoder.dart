import 'dart:convert';

import 'package:avanzza/presentation/auth/scanners/escanner_document_model.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

///Obtiene los datos del usuario a partir de los bites del codigo de barra de la cedula de identidad
class UserDecoder {
  UserDecoder();

  printData(List<int> list) {
    List<int> listCopy = [];

    for (var i = 0; i < list.length; i++) {
      if (list[i] != 0) {
        listCopy.add(list[i]);
      } else {
        if (listCopy.isNotEmpty) {
          print("Dato: ${latin1.decode(listCopy)}");
        }
        listCopy = [];
      }
    }
  }

  String quitarCerosAlinicio(String texto) {
    if (texto.isNotEmpty) {
      if (texto[0] == "0") {
        bool sw = true;
        int i = 0;
        while (sw && i < texto.length) {
          if (texto[i] == "0") {
            i++;
          } else {
            sw = false;
          }
        }
        return texto.substring(i, texto.length);
      }
    }
    return texto;
  }

  ScannerDocumentModel getUserCiCode(Uint8List scannerBitesResult) {
    String codigoCompleto = latin1.decode(scannerBitesResult);
    // printData(scannerBitesResult);
    if (kDebugMode) {
      print(codigoCompleto.length);
    }
    try {
      String codigoAfis =
          latin1.decode(scannerBitesResult.getRange(2, 10).toList());
      String tarjetaDactilar =
          latin1.decode(scannerBitesResult.getRange(40, 48).toList());
      String numeroDocumento =
          latin1.decode(scannerBitesResult.getRange(48, 58).toList()).trim();
      numeroDocumento = quitarCerosAlinicio(numeroDocumento);
      String apellidoPaterno =
          latin1.decode(scannerBitesResult.getRange(58, 80).toList()).trim();
      String segundoApellido =
          latin1.decode(scannerBitesResult.getRange(81, 104).toList()).trim();
      String primerNombre =
          latin1.decode(scannerBitesResult.getRange(104, 127).toList()).trim();
      String segundoNombre =
          latin1.decode(scannerBitesResult.getRange(127, 150).toList()).trim();
      String genero =
          latin1.decode(scannerBitesResult.getRange(151, 152).toList());
      String fechaNacimiento =
          latin1.decode(scannerBitesResult.getRange(152, 160).toList());
      String anio =
          latin1.decode(scannerBitesResult.getRange(152, 156).toList());
      String mes =
          latin1.decode(scannerBitesResult.getRange(156, 158).toList());
      String dia =
          latin1.decode(scannerBitesResult.getRange(158, 160).toList());
      String departamento =
          latin1.decode(scannerBitesResult.getRange(160, 162).toList());
      String municipio =
          latin1.decode(scannerBitesResult.getRange(162, 165).toList());

      String tipoSangre =
          latin1.decode(scannerBitesResult.getRange(166, 168).toList());

      ScannerDocumentModel usuario = ScannerDocumentModel(
          userDocument: UserDocument.cardId,
          codigoAfis: codigoAfis,
          tarjetaDactilar: tarjetaDactilar,
          numeroDocumento: numeroDocumento,
          apellidoPaterno: apellidoPaterno,
          apellidoMaterno: segundoApellido,
          primerNombre: primerNombre,
          segundoNombre: segundoNombre,
          genero: genero,
          fechaNacimiento: fechaNacimiento,
          anio: anio,
          mes: mes,
          dia: dia,
          municipio: municipio,
          departamento: departamento,
          tipoSangre: tipoSangre);

      if (int.tryParse(anio) == null ||
          int.tryParse(mes) == null ||
          int.tryParse(dia) == null) {
        throw "Documento no válido - no tiene fecha de nacimiento";
      }

      return usuario;
    } catch (e) {
      throw "Codigo no valido, intentalo nuevamente";
    }
  }

  //-----------------------LICENCIA DE CONDUCIR ---------------------------------------//

  ///Obtiene los datos del usuario a partir de los bites del codigo de barra de la licencia de conducir
  ScannerDocumentModel getUserDeBarcodeLicenciaDeConducir(
      Uint8List scannerBitesResult) {
    String codigoCompleto = latin1.decode(scannerBitesResult);
    if (kDebugMode) {
      print(codigoCompleto);
    }
    try {
      String liceniaDeConducir = latin1
          .decode(scannerBitesResult.getRange(1, 13).toList())
          .replaceAll("0", "")
          .trim();
      String primerNombre =
          latin1.decode(scannerBitesResult.getRange(81, 106).toList()).trim();
      // String segundoNombre =
      //     latin1.decode(scannerBitesResult.getRange(81, 106).toList());
      String tipoDeLicencia = latin1
          .decode(scannerBitesResult.getRange(13, 18).toList())
          .replaceAll("\n", ",");
      String apellidoPaterno =
          latin1.decode(scannerBitesResult.getRange(31, 56).toList()).trim();
      String apellidoMaterno =
          latin1.decode(scannerBitesResult.getRange(56, 80).toList()).trim();
      String fechaInicio =
          latin1.decode(scannerBitesResult.getRange(56, 180).toList());
      String fechaFin =
          latin1.decode(scannerBitesResult.getRange(140, 280).toList());

      ScannerDocumentModel usuario = ScannerDocumentModel(
        userDocument: UserDocument.drivingLicense,
        licenciaDeConducir: liceniaDeConducir,
        tipoDeLicencia: tipoDeLicencia,
        primerNombre: primerNombre,
        //segundoNombre: segundoNombre,
        apellidoPaterno: apellidoPaterno,
        apellidoMaterno: apellidoMaterno,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
      return usuario;
    } catch (e) {
      throw "Codigo no valido, intentalo nuevamente";
    }
  }

  //-----------------------LICENCIA DE CONDUCIR ---------------------------------------//

  ///Obtiene los datos del usuario leyendolos de una imagen de la libreta de conducir
  Future<ScannerDocumentModel> getUserDeScaneoLicenciaDeConducir(
      InputImage imagenFrontal, InputImage imagenDorsal) async {
    ScannerDocumentModel scannerDocumentModel = ScannerDocumentModel(
      userDocument: UserDocument.drivingLicense,
    );

    //CLASE PARA RECONOCER TEXTOS
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    //PROCESAMOS LA IMAGEN CON EL RECONOCIMIENTO DE TEXTO
    final RecognizedText recognizedTextFrontal =
        await textRecognizer.processImage(imagenFrontal);
    final RecognizedText recognizedTextDorsal =
        await textRecognizer.processImage(imagenDorsal);
    //CADA BLOCK TIENE UN TEXTO DE LA IMAGEN
    List<TextBlock> blocksFrontal = recognizedTextFrontal.blocks;
    List<TextBlock> blocksDorsal = recognizedTextDorsal.blocks;

//ORDENAMOS DE ARRIBA A ABAJO
    blocksFrontal.sort(
      (a, b) => a.boundingBox.top.compareTo(b.boundingBox.top),
    );
    List<String> textosFrontal = blocksFrontal.map((e) => e.text).toList();
    List<String> textosDorsal = blocksDorsal.map((e) => e.text).toList();

    //BUSCAMOS LA FEHCA DE NACIMIENTO Y EXPEDICION
    List<DateTime> fechas = [];

    try {
      for (var element in textosFrontal) {
        DateTime? fecha = DateTime.tryParse(element.split('-').reversed.join());
        if (fecha != null) {
          fechas.add(fecha);
        }
      }
      fechas.sort();

      DateTime fechaNacimiento = fechas.first;
      DateTime fechaExpedicion = fechas.last;
      //USUALMENTE EL NOMBRE ESTA DESPUES DEL BLOCK NOMBRE
      String nombre = textosFrontal[textosFrontal.indexOf("NOMBRE") + 1];
      List<String> nombres = nombre.split(" ");
      String primerNombre = "";
      String segundoNombre = "";
      String primerApellido = "";
      String segundoApellido = "";

//SE SUBREN VARIOS CASOS POSIBLES DEPENDIENDO DE CUANTOS NOMBRES Y APELLIDOS TENGA
//PODRIAN DARCE CASOS PARTICULARES DONDE EL USUARIO DEBE MODIFICAR LOS DATOS
      if (nombres.length == 2) {
        primerNombre = nombres.first;
        primerApellido = nombres[1];
      } else if (nombres.length == 3) {
        primerNombre = nombres.first;
        segundoNombre = nombres[1];
        primerApellido = nombres[2];
      } else if (nombres.length == 4) {
        primerNombre = nombres.first;
        segundoNombre = nombres[1];
        primerApellido = nombres[2];
        segundoApellido = nombres[3];
      }

      //EN EL CASO DE LA LICENCIA LO RECONOCEMOS POR SER EL QUE EMPIEZA CON NO.
      String numeroLicencia = textosFrontal
          .firstWhere((element) => element.startsWith("No."), orElse: () => "")
          .substring(3);

      //EN EL CASO DEL TIPO DE SANGRE POR SER EL UNICO CON SOLO DOS LETRAS
      String tipoSangre = textosFrontal.firstWhere(
          (element) => element.length == 2 || element.length == 3,
          orElse: () => "");

      //EN EL REVERSO EXTRAEMOS LOS TIPOS DE LICENCIA
      String tipoLicencia = textosDorsal
          .where((element) => element.length == 2)
          .toList()
          .join(",");

      scannerDocumentModel = ScannerDocumentModel(
          userDocument: UserDocument.drivingLicense,
          primerNombre: primerNombre,
          segundoNombre: segundoNombre,
          apellidoPaterno: primerApellido,
          apellidoMaterno: segundoApellido,
          licenciaDeConducir: numeroLicencia,
          tipoSangre: tipoSangre,
          anio: fechaNacimiento.year.toString(),
          mes: fechaNacimiento.month.toString(),
          dia: fechaNacimiento.day.toString(),
          fechaExpedicion: fechaExpedicion.toString(),
          tipoDeLicencia: tipoLicencia);
    } catch (e) {
      throw "Error al leer los datos, intente nuevamente";
    }
    return scannerDocumentModel;
  }

  //-----------------------TARJETA DE OPERACIÓN VEHÍCULO ---------------------------------------//

  ///Obtiene los datos del usuario a partir de los bites del codigo de barra de la tarjeta de operacion
  ScannerDocumentModel getUserFromTarjetaOperacionCode(
      Uint8List scannerBitesResult) {
    String codigoCompleto = latin1.decode(scannerBitesResult);
    if (kDebugMode) {
      print(codigoCompleto);
    }
    try {
      String numeroLibreta =
          latin1.decode(scannerBitesResult.getRange(20, 30).toList()).trim();
      String numeroDePlaca = latin1
          .decode(scannerBitesResult.getRange(30, 38).toList())
          .replaceAll("0", "")
          .trim();

      String tipoVehiculo = latin1
          .decode(scannerBitesResult.getRange(38, 59).toList())
          .replaceAll("0", "")
          .trim();
      String tipoDeOperacion = latin1
          .decode(scannerBitesResult.getRange(60, 80).toList())
          .replaceAll("0", "")
          .trim();
      String areaDeOperacion = latin1
          .decode(scannerBitesResult.getRange(80, 109).toList())
          .replaceAll("\n", ",")
          .replaceAll("0", "")
          .trim();
      // String tipoDeOperacion =
      //     latin1.decode(scannerBitesResult.getRange(60, 130).toList());
      String nit =
          latin1.decode(scannerBitesResult.getRange(109, 118).toList());
      String fechaInicio =
          latin1.decode(scannerBitesResult.getRange(118, 128).toList());
      String fechaFin =
          latin1.decode(scannerBitesResult.getRange(128, 138).toList());

      String area =
          latin1.decode(scannerBitesResult.getRange(138, 172).toList());

      ScannerDocumentModel usuario = ScannerDocumentModel(
        userDocument: UserDocument.operationCard,
        tipoVehiculo: tipoVehiculo,
        tipoDeOperacion: tipoDeOperacion,
        areaDeOperacion: areaDeOperacion,
        nit: nit,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        area: area,
        numeroLibretaDeOperacion: numeroLibreta,
        numeroDePlaca: numeroDePlaca,
      );
      return usuario;
    } catch (e) {
      throw "Codigo no valido, intentalo nuevamente";
    }
  }

  //-----------------------TARJETA DE PROPIEDAD VEHÍCULO ---------------------------------------//

  ///Obtiene los datos del usuario a partir de los bites del codigo de barra de la tarjeta de propiedad
  ScannerDocumentModel getUserFromTarjetaPropiedadCode(
      Uint8List scannerBitesResult) {
    String codigoCompleto = latin1.decode(scannerBitesResult);
    if (kDebugMode) {
      print(codigoCompleto);
    }
    try {
      String numeroTarjetaPropiedad =
          latin1.decode(scannerBitesResult.getRange(2, 13).toList()).trim();
      String numeroDePlaca = latin1
          .decode(scannerBitesResult.getRange(186, 204).toList())
          .replaceAll("0", "")
          .trim();
      String chasis =
          latin1.decode(scannerBitesResult.getRange(204, 221).toList()).trim();
      String primerNombre =
          latin1.decode(scannerBitesResult.getRange(76, 99).toList()).trim();
      String segundoNombre =
          latin1.decode(scannerBitesResult.getRange(99, 109).toList()).trim();
      String apellidoPaterno =
          latin1.decode(scannerBitesResult.getRange(30, 53).toList()).trim();
      String apellidoMaterno =
          latin1.decode(scannerBitesResult.getRange(53, 76).toList()).trim();

      String tipoDeOperacion = latin1
          .decode(scannerBitesResult.getRange(60, 109).toList())
          .replaceAll("\n", ",")
          .replaceAll("0", "")
          .trim();
      String tipoDocumento = latin1
          .decode(scannerBitesResult.getRange(17, 18).toList())
          .replaceAll("0", "")
          .trim();
      String numeroDocumento = latin1
          .decode(scannerBitesResult.getRange(18, 30).toList())
          .replaceAll("0", "")
          .trim();

      String direccionNotificacion =
          latin1.decode(scannerBitesResult.getRange(122, 155).toList()).trim();
      String fechaFin =
          latin1.decode(scannerBitesResult.getRange(139, 170).toList());

      String area =
          latin1.decode(scannerBitesResult.getRange(161, 175).toList());
      print("tipoDocumento $tipoDocumento");
      ScannerDocumentModel usuario = ScannerDocumentModel(
        userDocument: UserDocument.operationCard,
        tipoDeOperacion: tipoDeOperacion,
        primerNombre: primerNombre,
        segundoNombre: segundoNombre,
        apellidoPaterno: apellidoPaterno,
        apellidoMaterno: apellidoMaterno,
        direccionNotificacion: direccionNotificacion,
        fechaFin: fechaFin,
        area: area,
        numeroDocumento: numeroDocumento,
        numeroTarjetaPropiedad: numeroTarjetaPropiedad,
        numeroDePlaca: numeroDePlaca,
        numeroChasis: chasis,
      );
      return usuario;
    } catch (e) {
      throw "Codigo no valido, intentalo nuevamente";
    }
  }
}
