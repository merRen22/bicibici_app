import 'dart:convert';

import 'package:bicibici/src/Models/Payment.dart';
import 'package:bicibici/src/Models/Plan.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:http/http.dart' as Client;
import 'package:bicibici/src/Services/Configuration.dart';

class PaymentService {

  Future<User> obtenerDataUsuario(String uuidUser)async {
    User usuario = User();
    var dataJson = json.encode({'uuidUser': uuidUser});

    try {
      await Client.post(Configuration.obtenerDataUsuario,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);

          if(parsedJson['sucess']){
            usuario = User.fromJson(parsedJson['user']);
          }
          
        }
      });
    } catch (error) {
      usuario = User();
    }
    return usuario;
  }

  Future<Payment> obtenerMembresiaUsuario(String uuidUser)async {
    Payment payment = Payment();
    var dataJson = json.encode({'uuidUser': uuidUser});

    try {
      await Client.post(Configuration.obtenerDataUsuario,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          if(parsedJson['sucess']){
            payment = Payment.fromJson(parsedJson['user']['payments']);
          }
        }
      });
    } catch (error) {
      payment = Payment();
    }
    return payment;
  }

  Future<User> obtenerMembresiaUsuarioUsuario(String uuidUser)async {
    User usuario = User();
    var dataJson = json.encode({'uuidUser': uuidUser});

    try {
      await Client.post(Configuration.obtenerDataUsuario,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);

          if(parsedJson['sucess']){
            usuario = User.fromJson(parsedJson['user']);
          }
          
        }
      });
    } catch (error) {
      usuario = User();
    }
    return usuario;
  }
  
  Future<List<Plan>> obtenerPlanes()async {
    List<Plan> planes = List<Plan>();

    try {
      await Client.get(Configuration.obtenerPlanesDisponibles,headers: Configuration.headerRequest).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);

          if(parsedJson['sucess']){
            (parsedJson['plans'] as List).forEach(
              (element){planes.add(Plan.fromJson(element));}
              );
          }
          
        }
      });
    } catch (error) {
      planes = List<Plan>();
    }
    return planes;
  }
  
  Future<bool> registrarPago(Plan plan,String uuidUser)async {
    bool resp = false;
    var dataJson = json.encode({
      'uuidUser': uuidUser,
      'Duration': plan.duration,
      'Amount': plan.cost,
      });

    try {
      await Client.post(Configuration.registrarPagoUsuario,headers: Configuration.headerRequest, body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          resp = parsedJson['message'] == "Se registro el pago";
        }
      });
    } catch (error) {
      resp = false;
    }
    return resp;
  }

}

