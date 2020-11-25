import 'package:app_qr_negocio/src/providers/lists_provider.dart';
import 'package:app_qr_negocio/src/providers/login_provider.dart';
import 'package:app_qr_negocio/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:app_qr_negocio/src/utils/utils.dart' as utils;
import 'package:app_qr_negocio/src/providers/client_provider.dart';
import 'package:app_qr_negocio/src/models/client_model.dart';



class ScannedDataPage extends StatefulWidget {

  @override
  _ScannedDataPageState createState() => _ScannedDataPageState();
}

class _ScannedDataPageState extends State<ScannedDataPage> {

  final savedData = SavedData();
  final clientProvider = new ClientProvider();
  final loginProvider = LoginProvider();
  final client = new ClientModel();
  final listsProvider = new ListsProvider();
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    String idToken = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          _crearFondo(),
          _datosForm(context, idToken),
          _isLoading ? Stack(children: <Widget>[
            Container(height: double.infinity,width: double.infinity, color: Colors.white24,),
            Center(child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(39, 39, 39, 1.0),
              strokeWidth: 5.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[400])
              )
            )
          ]) : Container()
        ]

        ),

    );
  }

  Widget _crearFondo(){

    return Container(

      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(39, 39, 39, 1.0)
    );
  }

  Widget _datosForm(BuildContext context, String idToken){

    final Future<Map <String, dynamic>> requestedData = clientProvider.requestClient(client, savedData.scanResult, idToken);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(

      child: Column(
        children: <Widget>[
          Center(
            child: SafeArea(
              child: Container(

                width: size.width * 0.85,
                height: size.height * 0.75,
                margin: EdgeInsets.symmetric(vertical: 30.0),
                padding: EdgeInsets.only(top: 50.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0
                    )
                  ],
                ),

                child: _form(requestedData, size)
              ),
            ),
          ),
        ],
      ),
    );
  }

  _form(Future<Map <String, dynamic>> requestedData, Size size){

    return Form(
      child: FutureBuilder(
        future: requestedData,
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<Map <String, dynamic>> snapshot){
          if(snapshot.hasData){
            if(snapshot.data != null){
              return Column(
                children: <Widget>[
                  Text('Datos del cliente', style: TextStyle(fontSize: 20.0),),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data['client'].dni.toString(), 'DNI'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data['client'].nombre, 'Nombre'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data['client'].apellido, 'Apellido'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data['client'].direccion, 'Dirección'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data['client'].telefono.toString(), 'Telefono'),
                  SizedBox(height: 35.0),
                  Row(
                    children: <Widget>[
                    SizedBox(width: 15.0),
                    _cancelButton(context, size),
                    Expanded(child: Container(),),
                    _submitButton(context, size, snapshot.data['client'], snapshot.data['id']),
                    SizedBox(width: 15.0)
                    ],
                  )
                ]
              );
            }
          }else{
            return Center(child: CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(39, 39, 39, 1.0),
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[400])
              ),
            );
          }
        }
      ),
    );
  }

  _cancelButton(BuildContext context, Size size){
    return RaisedButton(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.3,
        child: Center(child: Text('Cancelar')),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      textColor: Colors.white,
      color: Colors.grey,
      onPressed: () => Navigator.pushReplacementNamed(context, 'home')
    );
  }

  _submitButton(BuildContext context, Size size, ClientModel clientModel, String id){
    return RaisedButton(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.3,
        child: Center(child: Text('Enviar')),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      textColor: Colors.white,
      color: Colors.purple,
      onPressed: () => _submit(context, clientModel, id)
    );
  }

  _submit(BuildContext context, ClientModel clientModel, String idToken)async{
    
    setState(() {
      _isLoading = true;
    });

    if(idToken != null){

      String refreshResult = await loginProvider.firebaseAuthRefreshSession();

      if(refreshResult == 'not-refreshed'){
        listsProvider.addUser(clientModel, idToken);
      }else{
        listsProvider.addUser(clientModel, refreshResult);
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(context, 'home');
    }
  }
}