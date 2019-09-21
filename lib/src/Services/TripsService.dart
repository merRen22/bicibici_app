import 'dart:convert';

import 'package:bicibici/src/Models/Report.dart';
import 'package:bicibici/src/Models/Trip.dart';
import 'package:http/http.dart' as Client;
import 'package:bicibici/src/Services/Configuration.dart';

class TripsService {

  Future<List<Trip>> obtenerViajesUsuario(String uuidUser)async {
    List<Trip> trips = List<Trip>();
    var dataJson = json.encode({'uuidUser': uuidUser});

    try {
      await Client.post(Configuration.obtenerDataUsuario,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          if(parsedJson['sucess']){
            (parsedJson['user']['trips'] as Map).forEach((key,element)=>trips.add(Trip.fromJson(key,element)));
          }
        }
      });
    } catch (error) {
      trips = List<Trip>();
    }
    return trips;
  }

  
  Future<bool> unlockBike(Trip trip)async {
    bool result = false;
    var dataJson = json.encode({
      "uuidUser":trip.uuidUser,
      "uuidBike":trip.uuidBike,
      "uuidStation":trip.uuidStation,
      "originLatitude":trip.originLatitude,
      "originLongitude":trip.originLongitude
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
      "destinationLatitude":trip.destinationLatitude,
      "destinationLongitude":trip.destinationLongitude
    });

    try {
      await Client.post(Configuration.bloquearBicicleta,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
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

  

}

