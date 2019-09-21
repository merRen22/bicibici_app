import 'dart:async';

import 'package:bicibici/src/Models/Plan.dart';
import 'package:bicibici/src/Models/Report.dart';
import 'package:bicibici/src/Models/Station.dart';
import 'package:bicibici/src/Models/Trip.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Services/PaymentService.dart';
import 'package:bicibici/src/Services/StationsService.dart';
import 'package:bicibici/src/Services/TripsService.dart';
import 'package:bicibici/src/Services/UserService.dart';
import 'package:bicibici/src/Values/Constants.dart';

class MainTabPresenter {
  final Stationsservice _stationsservice = Stationsservice();
  final PaymentService _paymentService = PaymentService();
  final TripsService _tripsService = TripsService();
  final UserService _userService = UserService(Constants.userPool);
  
 
  Future<List<Station>> getNearStations(double latitude, double longitude) async {
    return await _stationsservice.getNearStations(latitude,longitude);
  }
  
  Future<bool> desbloquearBicicleta(Trip trip) async {
    return await _tripsService.unlockBike(trip);
  }
  
  Future<bool> bloquearBicicleta(Trip trip) async {
    return await _tripsService.lockBike(trip);
  }
  
  Future<User> obtenerDataUsuario(String uuidUser) async {
    return await _paymentService.obtenerDataUsuario(uuidUser);
  }
  
  Future<User> getCurrentUser() async {
    await _userService.init();
    return await _userService.getCurrentUser();
  }

  Future<List<Plan>> obtenerPlanes() async {
    return await _paymentService.obtenerPlanes();
  }

  Future<bool> registrarPago(Plan plan,String uuidUser) async {
    return await _paymentService.registrarPago(plan,uuidUser);
  }
  
  Future<bool> iniciarViaje(Plan plan,String uuidUser) async {
    return await _paymentService.registrarPago(plan,uuidUser);
  }

  Future<bool> finalizarViaje(Plan plan,String uuidUser) async {
    return await _paymentService.registrarPago(plan,uuidUser);
  }
  
  Future<bool> reportBike(Report report) async {
    return await _tripsService.reportBike(report);
  }

}

final presenter = MainTabPresenter();