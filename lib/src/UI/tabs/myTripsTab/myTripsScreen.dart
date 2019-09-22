import 'package:bicibici/src/Models/Trip.dart';
import 'package:bicibici/src/Presenter/myTripsPresenter.dart';
import 'package:bicibici/src/Presenter/myProfilePresenter.dart' as userPresenter;
import 'package:bicibici/src/UI/tabs/myTripsTab/DialogTrip.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'dart:math' show cos, sqrt, asin;

class MyTripsScreen extends StatefulWidget {
  @override
  MyTripsScreenState createState() => MyTripsScreenState();
}

class MyTripsScreenState extends State<MyTripsScreen> {
  bool _isDataLoading = true;
  List trips;
  double totalDistance = 0.0;
  double totalPoints = 0.0;

  Widget userExperience(){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
          elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child:LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 140,
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2500,
                  percent: totalPoints/300*100/100,
                  center: Text( totalPoints.toString() + "/300 puntos",style: TextStyles.smallPurpleFatText() ,),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.greenAccent[400],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4,8,0,8),
              child: FloatingActionButton(
                mini: true,
                elevation: 0,
                child: Icon(Icons.flag, color: Colors.white),
                backgroundColor: Colors.black87,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () =>showModalUserDiscount(),
              ),
            ),
          ],
        ));
  }
  
  Widget totalTrips(){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
          elevation: 4,
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                            Row(
                      children: <Widget>[
                        
                    Expanded(
                    child:Container(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyles.smallBlackFatText(),
                                children: [
                                  TextSpan(text: "${totalDistance.toStringAsFixed(2)}",style: TextStyles.largeGreenFatText(),),
                                  TextSpan(text: " km recorridos en bicibici"),
                                ]
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                    
                             Divider(
                               thickness: 4,
                               indent: 6,
                               endIndent: 6,
            color: Colors.purple,
          ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
            
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      style: TextStyles.smallBlackFatText(),
                                      children: [
                                        TextSpan(text: "${(calculateCO2().toStringAsFixed(2))}",style: TextStyles.smallPurpleFatText(),),
                                        TextSpan(text: " g de CO2 ahorrados"),
                                      ]
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: false,
                          child:Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    style: TextStyles.smallBlackFatText(),
                                    children: [
                                      TextSpan(text: "${(500)}",style: TextStyles.smallPurpleFatText(),),
                                      TextSpan(text: " Klcal  quemadas"),
                                    ]
                                  ),
                                ),
                              ),
                            ],
                          )),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    style: TextStyles.smallBlackFatText(),
                                    children: [
                                      TextSpan(text: "${(calculateCost(totalDistance).toStringAsFixed(2))}",style: TextStyles.smallPurpleFatText(),),
                                      TextSpan(text: " soles ahorrados"),
                                    ]
                                  ),
                                ),
                              ),
                            ],
                          )
                      
                            ],
                          ),
                        )],
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.directions_bike,color: Colors.purple,size: 48,),
                )
                  ],
                ),
              ],
            ));
  }

  Widget tripCard(Trip trip){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(
                  builder: (context) => DialogTrip(viaje: trip)),
            );
      },
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
          color: Colors.white,
          margin: EdgeInsets.all(12),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          semanticContainer: true,
          elevation: 4,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20,8,8,8),
                    child: Text("Fecha ${(trip.startDate.substring(0,trip.startDate.indexOf("|")))}",style: TextStyles.smallPurpleFatText(),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20,8,8,8),
                    child: Text("${(calculateCO2byTrip(trip).toStringAsFixed(2))} gr",style: TextStyles.mediumGreenFatText(),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("de CO2 Ahorrado ",style: TextStyles.smallBlackFatText(),),
                  ),
                ],
              )
            ],
          )
      ),
    );
  }

  @override
  void initState() {
      _obtenerViajesUsuario();
    super.initState();
  }
  
  Future _obtenerViajesUsuario() async {
    String uuid = (await userPresenter.presenter.getCurrentUser()).email;
    await presenter.obtenerViajesUsuario(uuid).then((response){
      trips = response.viajes;
      totalDistance = getTotalDistance();
      totalPoints = double.parse((totalDistance/10).round().toString()) + response.puntaje;
      setState(() {
        _isDataLoading = false;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => NestedScrollView(
          headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      floating: true,
                      pinned: false,
                      snap: false,
                      primary: true,
                      elevation: 8,
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.white),
                      title: Text("Mi uso", style: TextStyles.mediumPurpleFatText()),
                      )];
                                        },
                body: _isDataLoading
                ?UtilityWidget.containerloadingIndicator(context)
                :ListView.builder(
                  itemCount: trips.length + 2,
                  itemBuilder: (listContext,index){
                    return index == 0
                    ?userExperience()
                    :index==1
                    ?totalTrips()
                    :tripCard(trips[index-2]);
                  },
                )
                ));
  }
  
  double getTotalDistance(){
    double total = 0.0;
    trips.forEach((trip)=>total +=  calculateDistance(trip.originLatitude,trip.originLongitude,trip.destinationLatitude,trip.destinationLongitude));
    return total;
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  
  double calculateCO2(){
    return 171.7*totalDistance;
  }
  
  double calculateCost(double distance){
    return 0.2479*distance;
  }

  double calculateCO2byTrip(Trip trip){
    return 171.7*calculateDistance(trip.originLatitude,trip.originLongitude,trip.destinationLatitude,trip.destinationLongitude);
  }

  void showModalUserDiscount(){
    showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 250.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Descuento bicibici",
                                  style: TextStyles.mediumPurpleFatText(),
                                ),
                              ),
                              Expanded(child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "Al llegar a los 300 puntos dentro de este mes puedes obtener un descuento del 3% en tu proxima membresia 😊",
                                            style: TextStyles.smallBlackFatText(),
                                          ),
                                        ),
                                      ),
                                ],
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FlatButton(
                                      color: Colors.purple,
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      shape: StadiumBorder(),
                                      child: Text("Ok", style: TextStyles.smallWhiteFatText(),),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                );
              });
  }


}