import 'dart:async';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Services/PaymentService.dart';
import 'package:bicibici/src/Services/TripsService.dart';
import 'package:bicibici/src/Services/UserService.dart';
import 'package:bicibici/src/Values/Constants.dart';

class MyProfilePresenter {
  final UserService _userService = UserService(Constants.userPool);
  final PaymentService _paymentService = PaymentService();
  final TripsService _tripService = TripsService();
 
  Future<User> getCurrentUser() async {
    await _userService.init();
    return await _userService.getCurrentUser();
  }

  Future<bool> resetPassword(String oldPassword, String newPassword) async {
    return await _userService.resetPassword(oldPassword,newPassword);
  }

  Future<bool> logOut() async {
    return await _userService.signOut();
  }

  Future<bool> deleteUser() async {
    return await _userService.deleteUser();
  }

  Future<bool> updateUserData(List<CognitoUserAttribute> attributes) async {
    return await _userService.updateUserData(attributes);
  }
  
  Future<User> obtenerMembresiaUsuario(String uuidUser) async {
    return await _paymentService.obtenerMembresiaUsuario(uuidUser);
  }
  
  Future<bool> registerEmergencyContact(User user) async {
    return await _tripService.registerEmergencyContact(user);
  }

}

final presenter = MyProfilePresenter();
