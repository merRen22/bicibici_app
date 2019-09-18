class Trip{
  String uuidStation,uuidBike,uuidUser,startDate,endDate;
  double originLatitude,originLongitude,destinationLatitude,destinationLongitude;
  Trip();

  static Trip fromJson(String key,parsedJson) {
    Trip trip = Trip();
    trip.startDate = key;
    trip.endDate = parsedJson[1];
    trip.originLatitude = double.parse(parsedJson[2].toString());
    trip.originLongitude = double.parse(parsedJson[3].toString());
    trip.destinationLatitude = double.parse(parsedJson[4].toString());
    trip.destinationLongitude = double.parse(parsedJson[5].toString());
    return trip;
  }

}