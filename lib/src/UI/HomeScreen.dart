import 'package:flutter/material.dart';
import './Login/LoginScreen.dart';
import '../Models/User.dart';
import 'dart:async';
import '../Models/Counter.dart';
import '../Services/UserService.dart';
import '../Values/Constants.dart';

import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userService = new UserService(Constants.userPool);
  final Set<Marker> _markers = {};
  Position position;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId("uniqueKey"),
      position: LatLng(45.521563, -122.677433),
      infoWindow: InfoWindow(
        title: 'Estacionamiento',
        snippet: '3 libres\n4 ocupados',
      ),
      onTap: (){},
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    ));
  }
  
  //CounterService _counterService;
  AwsSigV4Client _awsSigV4Client;
  User _user = new User();
  Counter _counter = new Counter(0);
  bool _isAuthenticated = false;

/*
  void _incrementCounter() async {
    final counter = await _counterService.incrementCounter();
    setState(() {
      _counter = counter;
    });
  }
  */
  

  Future<UserService> _getValues(BuildContext context) async {
    try {
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      await _userService.init();
      _isAuthenticated = await _userService.checkAuthenticated();
      if (_isAuthenticated) {
        // get user attributes from cognito
        _user = await _userService.getCurrentUser();

        // get session credentials
        /*
        final credentials = await _userService.getCredentials();
        _awsSigV4Client = new AwsSigV4Client(
            credentials.accessKeyId, credentials.secretAccessKey, Constants.endpoint,
            region: Constants.region, sessionToken: credentials.sessionToken);
*/

        // get previous count
        //_counterService = new CounterService(_awsSigV4Client);
        // _counter = await _counterService.getCounter();
      }
      return _userService;
    } on CognitoClientException catch (e) {
      if (e.code == 'NotAuthorizedException') {
        await _userService.signOut();
        Navigator.pop(context);
      }
      throw e;
    }
  }


  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static const LatLng _center = const LatLng(45.521563, -122.677433);


  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: _getValues(context),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          if (snapshot.hasData) {
            if (!_isAuthenticated) {
              return new LoginScreen();
            }
            return new Scaffold(
              appBar: new AppBar(
                title: new Text('bicibici',style: 
                          TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),),
              ),
              body: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 19.0,
                  ),
                  //_kGooglePlex,
                  mapType: MapType.normal,
                  markers: _markers,
                  
                  onMapCreated: _onMapCreated),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _goToTheLake,
                label: Text('To the lake!'),
                icon: Icon(Icons.directions_boat),
              ),
            );
          }
          return new Scaffold(
              appBar: new AppBar(title: new Text('Loading...')));
        });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }



}
