import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:app_qr_negocio/src/models/client_model.dart';
import 'package:app_qr_negocio/src/providers/lists_provider.dart';
import 'package:app_qr_negocio/src/providers/login_provider.dart';
import 'package:app_qr_negocio/src/shared_preferences/shared_preferences.dart';

import 'package:app_qr_negocio/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final savedData = SavedData();
  final listProvider = ListsProvider();
  final loginProvider = LoginProvider();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    String idToken = ModalRoute.of(context).settings.arguments;
    Permission.storage.request();
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
          _isLoading ? Stack(children: <Widget>[
            Container(height: double.infinity,width: double.infinity, color: Colors.white24,),
            Center(child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(39, 39, 39, 1.0),
              strokeWidth: 5.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[400])
              )
            )
          ]) : Container()
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
                height: size.height * 0.8,
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
                    _requestButton(context, size, idToken),
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
        height: size.height * 0.3,
        width: size.width * 0.65,
        child: Center(child: Text('Cargar cliente')),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 10.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => _scanHandle(context, idToken)
    );
  }

  _requestButton(BuildContext context, Size size, String idToken){
    return RaisedButton(
      child: Container(
        height: size.height * 0.3,
        width: size.width * 0.65,
        child: Center(child: Text('Pedir lista')),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 10.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed:  () => _requestList(context, idToken)
    );
  }

  _scanHandle(BuildContext context, String idToken) async {

    await utils.scan();

    if (savedData.scanResult != ''){

      String refreshResult = await loginProvider.firebaseAuthRefreshSession();

      if(refreshResult == 'not-refreshed'){
        Navigator.pushReplacementNamed(context, 'scanned', arguments: idToken);
      }else{
        Navigator.pushReplacementNamed(context, 'scanned', arguments: refreshResult);
      }

    }else{
      utils.showScanError(context);
    }
  }

  _requestList(BuildContext context, String idToken) async{

    setState(() {
      _isLoading = true;
    });

    Map date = await _selectDate(context);
    String formattedDate = utils.dateFormatter(date['date']);

    if(!date['ok']){

        String refreshResult = await loginProvider.firebaseAuthRefreshSession();

      if(refreshResult != 'not-refreshed'){
        idToken = refreshResult;
      }

      List<ClientModel> clientList = await listProvider.requestList(formattedDate, idToken);

      setState(() {
        _isLoading = false;
      });

      utils.createPDF(clientList, formattedDate);
    }else{
      
      setState(() {
          _isLoading = false;
      });
    }

    
  }

  // TODO: FIX ME PLS

  Future<Map <String, dynamic>> _selectDate(BuildContext context) async{

    DateTime selectedDate = new DateTime.now();
    bool didSelect = false;

    dynamic picked = await showDatePicker(
      context: context, 
      initialDate: selectedDate,
      firstDate: new DateTime(2020), 
      lastDate: new DateTime(2025),
      locale: Locale('es', 'AR'),
    );



    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        didSelect = true;
    });

    return {'ok': didSelect, 'date': selectedDate};
    // if(picked != null){
    //   return {'ok': true, 'date': picked};
    // }else{
    //   return {'ok': false};
    // }
  }
}