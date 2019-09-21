class Report{
  String uuidBike,uuidUser,description;
  double latitude, longitude;

  Report();
  
  Map<String, dynamic> toJson() => {
        'uuidBike': uuidBike,
        'uuidUser': uuidUser,
        'description': description,
        'latitude': latitude,
        'longitude': longitude
      };
}