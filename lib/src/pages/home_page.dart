import 'package:app_qr_negocio/src/models/client_model.dart';
import 'package:app_qr_negocio/src/providers/lists_provider.dart';
import 'package:app_qr_negocio/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:app_qr_negocio/src/utils/utils.dart' as utils;

class HomePage extends StatelessWidget {

  final savedData = SavedData();
  final listProvider = ListsProvider();

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
          _menuFondo(context, idToken),
        ],
      )
    );
  }

  Widget _crearFondo(){

    return Container(

      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(39, 39, 39, 1.0)
    );
  }

  Widget _menuFondo(BuildContext context, String idToken){

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(

      child: Column(
        children: <Widget>[
          Center(
            child: SafeArea(
              child: Container(

                width: size.width * 0.85,
                height: size.height * 0.7,
                margin: EdgeInsets.symmetric(vertical: 30.0),
                padding: EdgeInsets.symmetric(vertical: 50.0),
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

                child: Column( 
                  children: <Widget>[
                    Expanded(child: Container()),
                    _scanButton(context, size, idToken),
                    SizedBox(height: 45.0),
                    _requestButton(context, size),
                    Expanded(child: Container())
                  ]
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  _scanButton(BuildContext context, Size size, String idToken){
    return RaisedButton(
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.65,
        child: Center(child: Text('Cargar cliente')),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => _scanHandle(context, idToken)
    );
  }

  _requestButton(BuildContext context, Size size){
    return RaisedButton(
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.65,
        child: Center(child: Text('Pedir lista')),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed:  () => _requestList(context)
    );
  }

  _scanHandle(BuildContext context, String idToken) async {

    await utils.scan();

    if (savedData.scanResult != ''){
      Navigator.pushReplacementNamed(context, 'scanned', arguments: idToken);
    }else{
      utils.showScanError(context);
    }
  }

  _requestList(BuildContext context) async{

    DateTime date = await _selectDate(context);
    String formattedDate = utils.dateFormatter(date);

    List<ClientModel> clientList = await listProvider.requestList(formattedDate);

    utils.createPDF(clientList, formattedDate);
  }

  Future<DateTime> _selectDate(BuildContext context) async{

    DateTime picked = await showDatePicker(
      context: context, 
      initialDate: new DateTime.now(), 
      firstDate: new DateTime(2020), 
      lastDate: new DateTime(2025),
      locale: Locale('es', 'AR'),
    );

    return picked;
  }
}