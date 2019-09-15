import 'dart:async';

import 'package:bicibici/src/Models/Station.dart';
import 'package:bicibici/src/Services/StationsService.dart';

class MainTabPresenter {
  final Stationsservice _stationsservice = Stationsservice();
 
  Future<List<Station>> getNearStations(double latitude, double longitude) async {
    return await _stationsservice.getNearStations(latitude,longitude);
  }

}

final presenter = MainTabPresenter();