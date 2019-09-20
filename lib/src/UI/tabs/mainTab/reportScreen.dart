import 'package:bicibici/src/Models/Payment.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Presenter/myProfilePresenter.dart';
import 'package:bicibici/src/UI/login/LoginScreen.dart';
import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  final String userEmail;
  final double latitude;
  final double longitude;

  const ReportScreen({Key key, this.userEmail, this.latitude, this.longitude}): super(key: key);

  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  bool _isDataLoading = false;

  var _formDescripcionKey = GlobalKey<FormFieldState>();
  
  @override
  void initState() {
    super.initState();
  }

  Widget cardFields(){
    return  Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 4,
        child: Column(
          children: <Widget>[
                            ListTile(
                                title: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'Descripción',
                                      labelText: 'Descripción'),
                                  keyboardType: TextInputType.text,
                                  key: _formDescripcionKey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    RaisedButton(
                                          shape: StadiumBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Escanear QR',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () {},
                                          color: Colors.purple,
                                        )])),
          ]));
  }

  Widget cardInteraction(){
    return  Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Ganararás 3 puntos por este reporte 😊",style: TextStyles.smallPurpleFatText()),
            ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
                                          shape: StadiumBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'enviar',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () {},
                                          color: Colors.purple,
                                        )])),
            
          ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Builder(
        builder: (context) => NestedScrollView(
          headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: true,
                      centerTitle: true,
                      floating: true,
                      pinned: false,
                      snap: false,
                      primary: true,
                      elevation: 8,
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.purple),
                      title: Text("Reporte", style: TextStyles.mediumPurpleFatText()),
                    )];
                },
                body: _isDataLoading
                ?UtilityWidget.containerloadingIndicator(context)
                :ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            cardFields(),
                            cardInteraction(),
                            ],
                            ),
                    ),
                  ],
                )
                )));
  }

}