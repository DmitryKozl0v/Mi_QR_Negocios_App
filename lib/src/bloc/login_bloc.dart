import 'package:rxdart/rxdart.dart';

import 'package:app_qr_negocio/src/bloc/validators.dart';


class LoginBloc with Validators{


  final _emailController          = BehaviorSubject<String>();
  final _passwordController       = BehaviorSubject<String>();
  final _loginPasswordController  = BehaviorSubject<String>();
  

  // Recuperar los datos del Stream
  Stream<String> get emailStream    => _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform<String>(validatePassword);
  Stream<String> get loginPasswordStream => _passwordController.stream;

  Stream<bool> get loginValidStream => 
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);



  // Insertar valores al Stream
  Function(String) get changeEmail         => _emailController.sink.add;
  Function(String) get changePassword      => _passwordController.sink.add;
  Function(String) get changeLoginPassword => _loginPasswordController.sink.add;


  // Obtener el último valor ingresado a los streams
  String get email         => _emailController.value;
  String get password      => _passwordController.value;
  String get loginPassword => _loginPasswordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _loginPasswordController?.close();
  }

}