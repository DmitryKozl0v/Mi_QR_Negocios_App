import 'package:flutter/material.dart';

import 'package:app_qr_negocio/src/bloc/login_bloc.dart';



class Provider extends InheritedWidget{

  final _loginBloc  = LoginBloc();


  static Provider _instancia;

  factory Provider({Key key, Widget child}){

    if(_instancia == null ){
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }


  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc loginBloc (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

}