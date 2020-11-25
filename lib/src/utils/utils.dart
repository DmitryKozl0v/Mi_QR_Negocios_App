import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart' show DateFormat;

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:barcode_scan/barcode_scan.dart';

import 'package:app_qr_negocio/src/models/client_model.dart';
import 'package:app_qr_negocio/src/shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';

Future scan() async{

  final savedData = SavedData();
  ScanResult futureString;
  
  try {
    futureString = await BarcodeScanner.scan();
  }catch(e){
    futureString.rawContent=e.toString();
  }


  if (futureString != null){
    savedData.scanResult = futureString.rawContent;
  }
}

Widget createTextField(String initialValue, String labelText){

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: TextFormField(
      initialValue: initialValue,
      enabled: false,
      decoration: InputDecoration(
        icon: Icon(Icons.crop_landscape, color: Colors.deepPurple),
        labelText: labelText,
      ),
    ),
  );
}

void showScanError(BuildContext context){

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('El scan ha fallado'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    },
  );
}

void showErrorAlert(BuildContext context, String msg){

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    },
  );
}

createPDF(List<ClientModel> clientList, String date) async{

  final pdf = pw.Document();
  final font = await rootBundle.load("fonts/OpenSans-Regular.ttf");
  final ttf = pw.Font.ttf(font);
  final pw.ThemeData theme = pw.ThemeData.withFont(base: ttf);

  Future _savePDF() async{
    final documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File('$documentPath/lista_clientes_$date.pdf');
    file.writeAsBytesSync(pdf.save());
    await Printing.sharePdf(bytes: pdf.save(), filename: 'lista_clientes_$date.pdf');
  }

  pdf.addPage(
    pw.MultiPage(

      theme: theme,
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(vertical: 45.0, horizontal: 35.0),

      build: (pw.Context context){
        return <pw.Widget>[
          pw.Table.fromTextArray(data:<List<String>>[
            <String>['Apellido', 'Nombre', 'DNI', 'Telefono', 'Direccion'],
            for(var client in clientList)
              <String>[
                client.apellido,
                client.nombre,
                client.dni.toString(),
                client.telefono.toString(),
                client.direccion
              ]
          ]),
        ];
      },
    )
  );

  _savePDF();
}

String dateFormatter(DateTime date){

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formattedDate = formatter.format(date);

  return formattedDate;
}