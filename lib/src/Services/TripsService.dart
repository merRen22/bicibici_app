import 'dart:convert';

import 'package:bicibici/src/Models/Report.dart';
import 'package:bicibici/src/Models/Trip.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:http/http.dart' as Client;
import 'package:bicibici/src/Services/Configuration.dart';

class TripsService {

  Future<User> obtenerViajesUsuario(String uuidUser)async {
    User auxUser = User();
    var dataJson = json.encode({'uuidUser': uuidUser});

    try {
      await Client.post(Configuration.obtenerDataUsuario,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          if(parsedJson['sucess']){
            auxUser.viajes = List<Trip>();
            auxUser.puntaje = double.parse(parsedJson['user']['experience'].toString());
            (parsedJson['user']['trips'] as Map).forEach((key,element)=>auxUser.viajes.add(Trip.fromJson(key,element)));
          }
        }
      });
    } catch (error) {
      print(error);
    }
    return auxUser;
  }

  
  Future<bool> unlockBike(Trip trip)async {
    bool result = false;
    var dataJson = json.encode({
      "uuidUser":trip.uuidUser,
      "uuidBike":trip.uuidBike,
      "uuidStation":trip.uuidStation,
      "originLatitude":trip.originLatitude,
      "originLongitude":trip.originLongitude,
      "destinationLatitude":trip.destinationLatitude,
      "destinationLongitude":trip.destinationLongitude
    });

    try {
      await Client.post(Configuration.desbloquearBicicleta,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          result = true;          
        }
      });
    } catch (error) {
      result = false;          
    }
    return result;
  }

  Future<bool> lockBike(Trip trip)async {
    bool result = false;
    var dataJson = json.encode({
      "uuidUser":trip.uuidUser,
      "uuidBike":trip.uuidBike,
      "latitude":trip.destinationLatitude,
      "longitude":trip.destinationLongitude
    });

    try {
      await Client.post(Configuration.bloquearBicicleta,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          if(parsedJson['message'] == "No se encuentra en el estacionamiento"){
            result = false;          
          }else{
            result = true;          
          }
        }
      });
    } catch (error) {
      result = false;          
    }
    return result;
  }
  
  Future<bool> reportBike(Report report)async {
    bool result = false;
    var dataJson = json.encode(report.toJson());

    try {
      await Client.post(Configuration.reportarBicicleta,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          result = true;          
        }
      });
    } catch (error) {
      result = false;          
    }
    return result;
  }
  
  Future<bool> registerEmergencyContact(User user)async {
    bool result = false;
    var dataJson = json.encode({
      "uuidUser":user.email,
      "emergencyContact":user.contactoEmergencia
    });

    try {
      await Client.post(Configuration.registrarContactoEmeregencia,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          result = true;          
        }
      });
    } catch (error) {
      result = false;          
    }
    return result;
  }
}

