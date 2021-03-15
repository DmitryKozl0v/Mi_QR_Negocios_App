import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_qr_negocio/src/shared_preferences/shared_preferences.dart';

class DisclaimerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String idToken = ModalRoute.of(context).settings.arguments;
    final savedData = new SavedData();

    return Scaffold(
      body: Stack(

        children: <Widget>[
          _crearFondo(),
          _crearDisclaimer(context, savedData, idToken),
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

  Widget _crearDisclaimer(BuildContext context, SavedData savedData, String idToken){

    final titleStyle   = TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold
    );
    final parrafoStyle = TextStyle(
      fontSize: 20
    );

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Center(
          child: Container(
          width: size.width*0.9,
          height: size.height*0.7,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
            ]
          ),
          child: ListView(
            children: <Widget>[
              Text('ATENCION:', style: titleStyle, textAlign: TextAlign.center,),
              SizedBox(height: 30.0,),
              Text('Aceptando los siguientes términos y condiciones;', style: parrafoStyle,),
              SizedBox(height: 10.0,),
              Text('El usuario ACEPTA que: La app MiQR, sirve como un mero INTERMEDIARIO entre clientes y comercios, para facilitar y estimular el ingreso a dichos establecimientos.', 
                    style: parrafoStyle, 
                    textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0,),
              Text('El usuario asume completa responsabilidad sobre la veracidad de los datos ingresados y cargados en los formularios de la aplicacion MiQR. También se le recuerda que los datos ingresados pueden ser verificados requiriendo la respectiva documentación por parte de quien escanea el código QR.', 
                    style: parrafoStyle, 
                    textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0,),
              Text('Bajo ningun concepto "MiQR", ni sus creadores se hacen RESPONSABLES de un MAL USO de los formularios por parte de usuarios, ya que "MiQR" NO EFECTUA CONTROL ALGUNO DE LOS DATOS INGRESADOS resultando ser unicamente un INTERMEDIARIO. Solo almacena los datos que efectivamente los usuarios ingresan, para permitir una facil identificación y comunicación entre usuario y comerciante.', 
                    style: parrafoStyle, 
                    textAlign: TextAlign.center,
              ),
              Expanded(child: Container(),),
              SizedBox(height: 20.0,),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                    _botonNo(size),
                    Expanded(child: Container()),
                    _botonSi(context, savedData, size, idToken),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _botonNo(Size size){
    return RaisedButton(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.3,
        child: Center(child: Text('No acepto')),
      ),
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
      ),
      textColor: Colors.white,
      color: Colors.grey,
      onPressed: () => SystemNavigator.pop(),
    );
  }

  Widget _botonSi(BuildContext context, SavedData savedData, Size size, String idToken){
    return RaisedButton(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.3,
        child: Center(child: Text('Si, acepto')),
      ),
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
      ),
      textColor: Colors.white,
      color: Colors.deepPurple,
      onPressed: (){

        savedData.hasAcceptedDisclaimer = true;
        Navigator.pushReplacementNamed(context, 'home', arguments: idToken);

      } 
    );
  }

}