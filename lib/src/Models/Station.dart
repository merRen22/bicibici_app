class Station{
  String uuidStation,address;
  int availableSlots,totalSlots;
  double latitude, longitude;

  Station();

 factory Station.fromJson(Map<String,dynamic> parsedJson){
   Station obj = Station();
   obj.uuidStation = parsedJson['uuidStation'];
   obj.latitude = parsedJson['latitude'];
   obj.longitude = parsedJson['longitude'];
   obj.address = parsedJson['address'];
   obj.totalSlots = parsedJson['totalSlots'];
   obj.availableSlots = int.parse(parsedJson['availableSlots'].toString()) ;
   return obj;
 }
}