import 'package:bicibici/src/Models/Station.dart';
import 'package:bicibici/src/Models/Trip.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Presenter/mainTabPresenter.dart';
import 'package:bicibici/src/UI/tabs/mainTab/Pagos/DialogSeleccionarPago.dart';
import 'package:bicibici/src/UI/tabs/mainTab/reportScreen.dart';
import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:bicibici/src/utils/MapCustomDialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{
  ///User state
  ///1 -> user needs to scan QR
  ///2 -> user needs to select a destination
  ///3 -> user needs to 
  int userState = 0;
  bool _isDataLoading = true;
  bool _isMapLoading = true;
  bool _locationError = false;
  User userAux;
  Trip auxTrip;
  Position userPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController _controller;
  @override
  void initState() {
    auxTrip = Trip();
    _obtenerDataUsuario();
    _getUserPosition();
    super.initState();
  }

  Future <BitmapDescriptor> _createMarkerImageFromAsset(String iconPath) async {
    BitmapDescriptor bitmapImage;
    ImageConfiguration configuration = ImageConfiguration(size: Size(30, 30),devicePixelRatio: 3);
     bitmapImage = await BitmapDescriptor.fromAssetImage(configuration,iconPath);

    return bitmapImage;
  }

  void initMarker(request, requestId) async {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
      icon: await _createMarkerImageFromAsset('images/bikeparking.png'),
        position: LatLng(request.latitude, request.longitude),
        onTap: () async {
          return showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 170.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                request.address,
                                style: TextStyles.mediumBlackFatText(),
                              ),
                              Text(
                                (request.totalSlots - request.availableSlots).toString() + " bicicletas disponibles",
                                style: TextStyles.smallPurpleFatText(),
                              ),
                              Text(
                                request.availableSlots.toString() + " espacios disponibles",
                                style: TextStyles.smallPurpleFatText(),
                              ),
                              if(userState == 2)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  if(calculateDistance(userPosition.latitude, userPosition.longitude,request.latitude,request.longitude)>0.01)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: request.totalSlots - request.availableSlots < 0
                                    ?Text("No hay espacios disponibles", style: TextStyles.smallPurpleFatText(),)
                                    :FlatButton(
                                      color: Colors.purple,
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        auxTrip.uuidStation = request.uuidStation;
                                        auxTrip.destinationLatitude = request.latitude;
                                        auxTrip.destinationLongitude = request.longitude;
                                        showModalUserUsage(request);
                                        userState = 3; 
                                      },
                                      shape: StadiumBorder(),
                                      child: Text("Reservar espacio", style: TextStyles.smallWhiteFatText(),),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        });

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
      print(markerId);
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  void showModalUserUsage(Station selectedStation){
    showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 300.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                "Recorreras una distancia de",
                                style: TextStyles.smallBlackFatText(),
                              )),
                              Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                calculateDistance(userPosition.latitude, userPosition.longitude,selectedStation.latitude,selectedStation.longitude).toStringAsFixed(2) + "km",
                                style: TextStyles.mediumGreenFatText(),
                              )),

                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "No generaras ${(calculateCO2(calculateDistance(userPosition.latitude, userPosition.longitude,selectedStation.latitude,selectedStation.longitude)).toStringAsFixed(2))} g CO2",
                                        style: TextStyles.smallBlackFatText(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Ahorraras 2 soles",
                                        style: TextStyles.smallBlackFatText(),
                                      ),
                                    ),
                                  ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Ganaras ${(calculateDistance(userPosition.latitude, userPosition.longitude,selectedStation.latitude,selectedStation.longitude).round()/10)} puntos de XP 😊",
                                    style: TextStyles.smallBlackFatText(),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      color: Colors.purple,
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        showModalUserEmergencyContact();
                                        setState(() {});
                                      },
                                      shape: StadiumBorder(),
                                      child: Text("Aceptar", style: TextStyles.smallWhiteFatText(),),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
  }

  void showModalUserEmergencyContact(){
    showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext contextDialog) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                title: Text("contacto de emerrgencia",style: TextStyles.mediumPurpleFatText(),textAlign: TextAlign.center,),
                content: Container(
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      userAux.contactoEmergencia == "none"?"Aún no haz incluido un contacto de emergencia":userAux.contactoEmergencia,
                                      style: TextStyles.smallBlackFatText(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      color: Colors.purple,
                                      onPressed: () async {
                                        MapCustomDialogs.progressDialog(context: context,message: "Preparamos tu viaje");
                                        await presenter.desbloquearBicicleta(auxTrip).then((response){                             
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          if(response){
                                            userState = 3;
                                            //cambio arrrelgar numeor de estaiconamientos
                                            _getNearStations();
                                          }else{
                                            userState = 1;
                                            setState(() {});
                                            SnackBars.showRedMessage(context, "Debes encontrarte cerca de la bicicleta para poder usarla");
                                          }
                                        });           
                                      },
                                      shape: StadiumBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text("Iniciar viaje", style: TextStyles.smallWhiteFatText(),),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
          onTap: (){
            userState = 1;
            setState(() {});
            Navigator.of(context).pop();
          },
          child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30.0),
                ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,8,20,8),
                  child: Icon(Icons.cancel,color: Colors.white),
                  )))
                                  )],
                              )
                            ],
                          ),
                    ],
                  ),
                ));});
  }

  Future _obtenerDataUsuario() async {
    userAux = await presenter.getCurrentUser();
    auxTrip.uuidUser = userAux.email;
    await presenter.obtenerDataUsuario(userAux.email).then((response){
      userState = response.activo == 0?0:1;
      userAux.contactoEmergencia = response.contactoEmergencia;
      userAux.activo = response.activo;
      userAux.uuidBike = response.uuidBike;
      if(response.uuidBike != "none"){
        auxTrip.uuidBike = response.uuidBike;
        userState = 3;
      }
    });
      setState(() {
        _isDataLoading = false;
      });
  }

  Future _getUserPosition() async {
      userPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(
        userPosition == null || 
        userPosition.latitude == null  || 
        userPosition.longitude == null || 
        userPosition.latitude == 0.0  || 
        userPosition.longitude == 0.0
        ){
        setState(() {
         _locationError = true; 
        });
      }else{
        auxTrip.originLatitude = userPosition.latitude;
        auxTrip.originLongitude = userPosition.longitude; 
        auxTrip.destinationLatitude = userPosition.latitude;
        auxTrip.destinationLongitude = userPosition.longitude; 
        _getNearStations();
        setState(() {
          _isMapLoading = false;
        });
      }
  }

  Future _getUserEndPosition() async {
      userPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(userPosition == null || userPosition.latitude == null){
        setState(() {
         _locationError = true; 
        });
      }else{
        auxTrip.destinationLatitude = userPosition.latitude;
        auxTrip.destinationLongitude = userPosition.longitude; 
      }
  }

  Future _getNearStations() async {
      await presenter.getNearStations(userPosition.latitude,userPosition.longitude).then((response){
        markers = <MarkerId, Marker>{};
        response.forEach((element)=>initMarker(element,element.uuidStation));
      });
  }

  startBarcodeScanStream() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancelar", true);
    if(barcodeScanRes != ""){
      auxTrip.uuidBike = barcodeScanRes;
      setState(() {
        userState = 2; 
        });
    }
  }

  showUserPlans() async {
    Navigator.push(context,MaterialPageRoute(
      builder: (context) => DialogSeleccionarPago()),
    ).then((response){
      if(response == "success"){
        setState(() {
         userState = 1; 
        });
      }
    });
  }

  Widget getUserState(){
    Widget aux;
     switch (userState) {
       case 0: aux = userState0(); break;
       case 1: aux = userState1(); break;
       case 2: aux = userState2(); break;
       case 3: aux = userState3(); break;
    }
     return aux;
  }
  
  Widget userState0(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
                              onTap: ()=> showUserPlans(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 80.0,
                                width: MediaQuery.of(context).size.width - 100,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: 
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(20,8,20,8),
                                        child: Container(child: Text("Aún no cuenta con una membresia adquiere una aquí",
                                              style: TextStyles.smallWhiteFatText(),
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              )),
                                      ),
                                ),
                              )))
                          ]
                        );
  }

  Widget userState1(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[                            
        GestureDetector(
          onTap: ()=> startBarcodeScanStream(),
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20,8,20,8),
                child: Text("Escanear QR Bici",
                style: TextStyles.smallWhiteFatText(),
                textAlign: TextAlign.center
                ),
              )
            )))]);
  }

  Widget userState2(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(30.0),
              ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20,8,20,8),
                child: Text("Selecciona una estación",
                style: TextStyles.smallWhiteFatText(),
                textAlign: TextAlign.center,
                )))),
        SizedBox(width: 10,),
        GestureDetector(
          onTap: (){
            userState = 1;
            setState(() {});
          },
          child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30.0),
                ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,8,20,8),
                  child: Icon(Icons.cancel,color: Colors.white),
                  ))),
        )
                          ],
                        );
  }
  
  Widget userState3(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            MapCustomDialogs.progressDialog(context: context,message: "Cerramos tu viaje");
            await _getUserEndPosition();
            bool response  = await presenter.bloquearBicicleta(auxTrip);
            Navigator.of(context).pop();
            !response
            ?SnackBars.showRedMessage(context, "No pudimos dar por finalizado tu viaje, intentalo nuevamente")
            :setState(() {
             userState = 1; 
            });
          },
          child: Container(
            height: 50.0,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30.0),
                ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,8,20,8),
                  child: Text("Finaliza viaje",
                  style: TextStyles.smallWhiteFatText(),
                  textAlign: TextAlign.center,
                  )))))]);
  }
  
  Widget containerPostionError(BuildContext context) {
    return Container(
            height: (MediaQuery.of(context).size).height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Estamos obteniendo tu ubicación",style: TextStyles.mediumBlackFatText(),),
                    ),
                    SizedBox(height: 15,),
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.purple),
                        strokeWidth: 5.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => DefaultTabController(
            length: 2,
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[];
                },
                body: _locationError || (_isDataLoading == true && userPosition == null) || _isMapLoading
                ?containerPostionError(context)
                :_isDataLoading
                ?UtilityWidget.containerloadingIndicator(context)
                :Stack(
                  children: <Widget>[
                    GoogleMap(
                      mapToolbarEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(userPosition.latitude,userPosition.longitude),
                        zoom: 14.0,
                      ),
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(markers.values),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        },

                    ),
                    Positioned(
                        bottom: 20,
                        width: MediaQuery.of(context).size.width,
                        child: getUserState()),
                    if(userState> 0)
                    Positioned(
                        top: 50,
                        right: 20,
                        child: FloatingActionButton(
                          key: UniqueKey(),
                          heroTag: UniqueKey(),
                          onPressed: (){
                            Navigator.push(context,MaterialPageRoute(
                              builder: (context) => ReportScreen(
                                userEmail: userAux.email,
                                latitude: userPosition.latitude,
                                longitude: userPosition.longitude
                              )),
                              ).then((response){});
                          },
                          child: Icon(Icons.error_outline,color: Colors.white,),
                          backgroundColor: Colors.red,

                        ))
                  ],
                ))));
  }
  
  double calculateCO2(double distance){
    return 171.7*distance;
  }

}
