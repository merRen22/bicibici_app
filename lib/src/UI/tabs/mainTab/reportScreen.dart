import 'package:bicibici/src/Models/Report.dart';
import 'package:bicibici/src/Presenter/mainTabPresenter.dart';
import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  bool _codeScanned = false;
  Report report = Report();

  var _formDescripcionKey = GlobalKey<FormFieldState>();
  
  @override
  void initState() {
    super.initState();
  }
  
  startBarcodeScanStream() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancelar", true);
    if(barcodeScanRes != ""){
      setState(() {
       _codeScanned = true; 
      });
      report.uuidBike = barcodeScanRes;
    }
  }

  Future _reportBike(BuildContext contextSca) async {
    if(
      _formDescripcionKey.currentState.value.toString() == ""
      ){
        SnackBars.showOrangeMessage(contextSca, "Debes incluir una descripción en tu reporte");
      }else{
        report.uuidBike??="";
        report.description = _formDescripcionKey.currentState.value.toString();
        report.uuidUser = widget.userEmail;
        report.longitude = widget.longitude;
        report.latitude = widget.latitude;
        setState(() {
        _isDataLoading = true; 
        });
        await presenter.reportBike(report).then((response){
          setState(() {
          _isDataLoading = false; 
          });
          response
          ?SnackBars.showGreenMessage(contextSca, "Gracias por tu reporte")
          :SnackBars.showRedMessage(contextSca, "Hubo un problema inesperado");
        });
      }
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Descripción',
                labelText: 'Descripción'),
              keyboardType: TextInputType.text,
              key: _formDescripcionKey
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _codeScanned
                ?RaisedButton(
                  shape: StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('codigo listo',
                    style: TextStyle(color: Colors.white))
                    ),
                    onPressed: () => startBarcodeScanStream(),
                    color: Colors.purple
                )
                :RaisedButton(
                  shape: StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('escanear QR',
                    style: TextStyle(color: Colors.white))
                    ),
                    onPressed: () => startBarcodeScanStream(),
                    color: Colors.purple
                )])),
          ]));
  }

  Widget cardInteraction(BuildContext contextSca){
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
            child: Text("Ganararás 5 puntos por este reporte 😊",style: TextStyles.smallPurpleFatText())
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
                      style: TextStyle(color: Colors.white)
                    )),
                  onPressed: () => _reportBike(contextSca),
                  color: Colors.purple)]))
          ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Builder(
        builder: (contextSca) => NestedScrollView(
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
                            cardInteraction(contextSca),
                            ],
                            ),
                    ),
                  ],
                )
                )));
  }

}