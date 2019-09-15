import 'package:bicibici/src/Presenter/mainTabPresenter.dart';
import 'package:bicibici/src/Services/StationsService.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:bicibici/src/utils/MapCustomDialogs.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _stationService = Stationsservice();
  bool _isDataLoading = true;
  Position userPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  

  @override
  void initState() {
    _getUserPosition();
    _getNearStations();
    super.initState();
  }

  //Stationsservice _counterService;
  //AwsSigV4Client _awsSigV4Client;
  //User _user = new User();
  //Counter _counter = new Counter(0);
  //bool _isAuthenticated = false;



  void initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(request.latitude, request.longitude),
        onTap: () async {
          //MapCustomDialogs.progressDialog(context: context, message: 'Fetching');
          //await _fetchrequestName(requestId);
          Navigator.pop(context);
          return showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 180.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              child: Text(
                                request.address,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                              radius: 30.0,
                              backgroundColor:
                                  Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "gaaaaaaaaaa",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black87),
                              ),
                              Text(
                                "espacios totales: " + request.totalSlots.toString(),
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black87),
                              ),
                              Text(
                                "espacios disponibles: " + request.availableSlots.toString(),
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.red),
                              ),
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

  Future _getUserPosition() async {
      userPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
3
      setState(() {
        _isDataLoading = false;
      });
  }

  Future _getNearStations() async {
      await presenter.getNearStations(-12.113944,-77.036759).then((response){
        response.forEach((element)=>initMarker(element,element.uuidStation));
      });

      setState(() {
        _isDataLoading = false;
      });
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
                body: _isDataLoading
                ?UtilityWidget.containerloadingIndicator(context)
                :Stack(
                  children: <Widget>[
                    GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(-12.113944,-77.036759),//userPosition.latitude,userPosition.longitude),
                        zoom: 14.0,
                      ),
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(markers.values),
                    ),
                    Positioned(
                        top: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: 
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Elije un destino",
                                          style: TextStyles.smallWhiteFatText()),
                                    ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ))));
  }

  Future<void> _goToTheLake() async {
    /*
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));




              floatingActionButton: FloatingActionButton.extended(
                onPressed: _goToTheLake,
                label: Text('To the lake!'),
                icon: Icon(Icons.directions_boat),

    */
  }
}


/*

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  //Stationsservice _counterService;
  //AwsSigV4Client _awsSigV4Client;
  //User _user = new User();
  //Counter _counter = new Counter(0);
  //bool _isAuthenticated = false;

  Future _getValues() async {
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      await _userService.init();
      _isAuthenticated = await _userService.checkAuthenticated();
      if (_isAuthenticated) {
        // get user attributes from cognito
        _user = await _userService.getCurrentUser();

        // get session credentials
        final credentials = await _userService.getCredentials();
        _awsSigV4Client = new AwsSigV4Client(
            credentials.accessKeyId, credentials.secretAccessKey, Constants.stationsEndPoint,
            region: Constants.region, sessionToken: credentials.sessionToken);

        // get previous count
        _counterService = Stationsservice(_awsSigV4Client);
        _counter = await _counterService.getStations();
      }
      return _userService;
    } on CognitoClientException catch (e) {
      if (e.code == 'NotAuthorizedException') {
        await _userService.signOut();
        Navigator.pop(context);
      }
    }
  }

    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId("uniqueKey"),
      position: LatLng(45.521563, -122.677433),
      infoWindow: InfoWindow(
        title: 'Estacionamiento',
        snippet: '3 libres\n4 ocupados',
      ),
      onTap: () {},
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    ));

 */