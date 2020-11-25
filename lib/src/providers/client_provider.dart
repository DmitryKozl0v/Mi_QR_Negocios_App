import 'dart:convert';
import 'package:app_qr_negocio/src/providers/login_provider.dart';
import 'package:http/http.dart' as http;

import 'package:app_qr_negocio/src/models/client_model.dart';


class ClientProvider{

  final String _url = 'https://qr-app-cliente.firebaseio.com';
  final loginProvider = LoginProvider();

  Future<Map<String,dynamic >> requestClient (ClientModel client, String scannedID, String idToken) async{

    final url = '$_url/cliente/$scannedID.json?auth=$idToken';

    final resp = await http.get(url);

    final client = clientModelFromJson(resp.body);

    return {'client': client, 'id': scannedID};
  }

  Future<bool> isOnViewerList(String idToken, String email) async{



    final url = '$_url/viewers.json?auth=$idToken';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    bool isviewer = false;

    decodedResp.forEach((key, value) {
      if(value == email){
        isviewer = true;
      }
    });

    return isviewer;
  }
}