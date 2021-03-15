
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app_qr_negocio/src/models/client_model.dart';
import 'package:app_qr_negocio/src/utils/utils.dart' as utils;
import 'package:app_qr_negocio/src/shared_preferences/shared_preferences.dart';

class ListsProvider{

  final String _url = 'https://qr-app-cliente.firebaseio.com';
  final _savedData = SavedData();
  static final DateTime _today = DateTime.now();
  final String _formattedDate = utils.dateFormatter(_today);

  

  getViewerData(String idToken, String uid) async{

    final url = '$_url/viewers/$uid.json?auth=$idToken';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    _savedData.businessName = decodedResp['negocio'];
  }
  
  Future<bool> addUser(ClientModel client, String id, String idToken) async{

    final url = '$_url/negocios/${_savedData.businessName}/lists/$_formattedDate/$id.json?auth=$idToken';

    final resp = await http.put(
      url, 
      body: clientModelToJson(client)  
    );

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if(decodedData.containsKey('apellido')){
      return true;
    }else{
      return false;
    }
  }

  Future <List<ClientModel>> requestList(String date, String idToken) async{    

    List<ClientModel> list = [];

    final url = '$_url/negocios/${_savedData.businessName}/lists/$date.json?auth=$idToken';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    print(decodedData);

    decodedData.forEach((key, value) {
      
      ClientModel tempClient = new ClientModel();

      tempClient.apellido   = value['apellido'];
      tempClient.direccion  = value['direccion'];
      tempClient.telefono   = num.parse(value['telefono'].toString());
      tempClient.nombre     = value['nombre'];
      tempClient.dni        = value['dni'];

      list.add(tempClient);
    });

    return list;
  }
}