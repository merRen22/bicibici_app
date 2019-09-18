import 'package:bicibici/src/Models/Trip.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' show cos, sqrt, asin;

class DialogTrip extends StatefulWidget {
  final Trip viaje;
  
  DialogTrip({Key key, this.viaje}): super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogTripState();
}

class _DialogTripState extends State<DialogTrip> {
  bool isDataLoading = false;

  @override
  Widget build(BuildContext mainContext) {
    return Builder(
        builder: (context) => DefaultTabController(
            length: 1,
            child: Scaffold(
                appBar: AppBar(
                      automaticallyImplyLeading: true,
                      centerTitle: true,
                      primary: true,
                      elevation: 8,
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.purple),
                      title: Text("Viaje", style: TextStyles.mediumPurpleFatText()),
                      ),
                body: Builder(
                    builder: (scaffoldContext) => isDataLoading
                        ? UtilityWidget.containerloadingIndicator(context)
                        : ListView(children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20,8,8,8),
                                  child: Text("${(calculateCO2().toStringAsFixed(2))} gr",style: TextStyles.mediumPurpleFatText(),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("de CO2 Ahorrado ",style: TextStyles.smallBlackFatText(),),
                                ),
                              ],
                            ),
                             Divider(
                               thickness: 4,
                               indent: 6,
                               endIndent: 6,
            color: Colors.purple,
          ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20,8,8,8),
                                  child: Text("Fecha ${(widget.viaje.startDate.substring(0,widget.viaje.startDate.indexOf("|")))}",style: TextStyles.smallBlackFatText(),),
                                ),
                              ],
                            ),             
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20,8,8,8),
                                  child: Text("Hora de inicio ${(widget.viaje.startDate.substring(widget.viaje.startDate.indexOf("|")+1,widget.viaje.startDate.length-1))}",style: TextStyles.smallBlackFatText(),),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20,8,8,8),
                                  child: Text("Hora de fin ${(widget.viaje.endDate.substring(widget.viaje.endDate.indexOf("|")+1,widget.viaje.startDate.length-1))}",style: TextStyles.smallBlackFatText(),),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20,8,8,8),
                                  child: Text("Distancia recorrida ${(calculateDistance(widget.viaje.originLatitude,widget.viaje.originLongitude,widget.viaje.destinationLatitude,widget.viaje.destinationLongitude).toStringAsFixed(2))} Km",style: TextStyles.smallBlackFatText(),),
                                  ),
                              ],
                            ),
                            
                              ],
                            ),
                          ))])))));
  }

  double calculateCO2(){
    return 171.7*calculateDistance(widget.viaje.originLatitude,widget.viaje.originLongitude,widget.viaje.destinationLatitude,widget.viaje.destinationLongitude);
  }
  
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  }
