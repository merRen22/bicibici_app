import 'dart:convert';

import 'package:http/http.dart' as Client;
import 'package:bicibici/src/Models/Station.dart';
import 'package:bicibici/src/Services/Configuration.dart';

class Stationsservice {

    Future<List<Station>> getNearStations(double latitude, double longitude)async {
    List<Station> estaciones = List<Station>();
    var dataJson = json.encode({
      'latitude': latitude,
      'longitude': longitude
    });

    try {
      await Client.post(Configuration.obtenerEstacionesCercanas,headers: Configuration.headerRequest,body: dataJson).then((Client.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = json.decode(response.body);
          
          if(parsedJson['sucess']){
            (parsedJson['Stations'] as List).forEach((e){estaciones.add(Station.fromJson(e));});
          }
        }
      });
    } catch (error) {
      estaciones = List<Station>();
    }
    return estaciones;
  }

}
