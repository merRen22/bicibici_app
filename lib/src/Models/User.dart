import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:bicibici/src/Models/Payment.dart';
import 'package:bicibici/src/Models/Trip.dart';

class User {
  String email, uuidBike;
  String name;
  String codigo;
  String password;
  String address;
  String phone;
  int activo;

  String oldPassword;
  String newPassword;

  List<Trip> viajes;
  Payment pago;
  String contactoEmergencia;
  double puntaje;

  bool confirmed = false;
  bool hasAccess = false;

  User({this.email, this.name, this.password,this.address,this.phone});

  factory User.fromUserAttributes(List<CognitoUserAttribute> attributes) {
    final user = User();
    attributes.forEach((attribute) {
      switch (attribute.getName()) {
        case 'email':
          user.email = attribute.getValue();
          break;
        case 'name':
          user.name = attribute.getValue();
          break;
        case 'address':
          user.address = attribute.getValue();
          break;
        case 'phone_number':
          user.phone = attribute.getValue();
          break;
      }
    });
    return user;
  }
  
  factory User.fromJson(parsedJson) {
    final user = User();
    user.activo = parsedJson['activo'];
    user.contactoEmergencia = parsedJson['emergencyContact'];
    user.uuidBike = parsedJson['uuidBike'];
    return user;
  }


  List<CognitoUserAttribute>  toUserAttributes() {
    return [
    CognitoUserAttribute(name: 'name', value: name),
    CognitoUserAttribute(name: 'address', value: address),
    CognitoUserAttribute(name: 'phone_number', value: phone)
    ];
  }

}