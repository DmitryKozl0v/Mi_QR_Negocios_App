
import 'package:firebase_database/firebase_database.dart';

import 'package:app_qr_negocio/src/models/client_model.dart';
import 'package:app_qr_negocio/src/utils/utils.dart' as utils;

class ListsProvider{

  final _databaseRef = FirebaseDatabase.instance.reference();
  static final DateTime _today = DateTime.now();
  final String _formattedDate = utils.dateFormatter(_today);

  List<ClientModel> _list = [];
  
  addUser(ClientModel client, String id){

    _databaseRef.child('Negocio/Lists/$_formattedDate/$id').update(client.toJson());
  }

  Future <List<ClientModel>> requestList(String date) async{    

    // TODO: not a great implementation, pls fix me

    

    await _databaseRef.child('Negocio/Lists/$date').once().then((DataSnapshot snapshot) {
      
      dynamic resp = snapshot.value;

      resp.forEach((key, value) {
        
        ClientModel tempClient = new ClientModel();

        tempClient.apellido   = value['apellido'];
        tempClient.direccion  = value['direccion'];
        tempClient.telefono   = num.parse(value['telefono'].toString());
        tempClient.nombre     = value['nombre'];
        tempClient.dni        = value['dni'];

        _list.add(tempClient);
      });

      // _list.forEach((element) {
      //   print('========================');
      //   print(element.apellido);
      //   print(element.direccion);
      //   print(element.telefono);
      //   print(element.nombre);
      //   print(element.dni);
      // });

    });

    return _list;
  }
}