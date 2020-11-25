import 'dart:convert';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel{
    ClientModel({
        this.key             ='',
        this.dni             = 0,
        this.nombre          = '',
        this.apellido        = '',
        this.direccion       = '',
        this.telefono        = 0,
    });

    String key; 
    int dni;
    String nombre;
    String apellido;
    String direccion;
    int telefono;

    factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        key           : json["key"],
        dni           : json["dni"],
        nombre        : json["nombre"],
        apellido      : json["apellido"],
        direccion     : json["direccion"],
        telefono      : json["telefono"],
    );

    Map<String, dynamic> toJson() => {
        "dni"             : dni,
        "nombre"          : nombre,
        "apellido"        : apellido,
        "direccion"       : direccion,
        "telefono"        : telefono,
    };
}