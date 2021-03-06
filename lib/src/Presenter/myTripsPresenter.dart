import 'dart:async';

import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Services/TripsService.dart';

class MyTripsPresenter {
  final TripsService _tripsService = TripsService();
 
  Future<User> obtenerViajesUsuario(String uuid) async {
    return await _tripsService.obtenerViajesUsuario(uuid);
  }
}

final presenter = MyTripsPresenter();
