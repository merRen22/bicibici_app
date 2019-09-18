import 'dart:core';

class Payment{
  String startDate,endDate;
  int cost,duration;

  Payment();
  
  factory Payment.fromJson(parsedJson){
    Payment payment;
    if(parsedJson.length != 0){
      payment = Payment();
      payment.startDate = parsedJson.keys.first;
      payment.duration = int.parse(parsedJson[payment.startDate][0].toString());
      payment.cost = int.parse(parsedJson[payment.startDate][1].toString());
      payment.endDate = parsedJson[payment.startDate][2];
    }
    return payment;
 }
}