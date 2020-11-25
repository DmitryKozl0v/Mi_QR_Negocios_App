import 'dart:async';



class Validators {


  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ) {


      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp   = new RegExp(pattern);

      if (email.length > 40){
        sink.addError('Email es demasiado largo');
      }else if (!regExp.hasMatch( email )){
        sink.addError('Email no es correcto');
      }else{
        sink.add( email );
      }

    }
  );


  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {

      Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
      RegExp regExp   = new RegExp(pattern);

      if (password.length > 32){
        sink.addError('Menos de 32 caracteres por favor');
      }else if(!regExp.hasMatch(password)){
        sink.addError('Su contraseña no contiene los caracteres pedidos');
      }else{
        sink.add( password );
      }

    }
  );
}