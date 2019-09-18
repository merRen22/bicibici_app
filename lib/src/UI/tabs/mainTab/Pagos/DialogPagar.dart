import 'package:bicibici/src/Models/Plan.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Presenter/mainTabPresenter.dart';
import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/material.dart';

class DialogPagar extends StatefulWidget {
  final Plan plan;

  DialogPagar({Key key, this.plan}): super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogPagarState();
}

class _DialogPagarState extends State<DialogPagar> {
  DateTime selectedDate = DateTime.now();
  bool isDataLoading = false;
  int _selectedItem = -1;

  _makePayment(BuildContext scaContext) async {
    User userAux = await presenter.getCurrentUser();
    await presenter.registrarPago(widget.plan, userAux.email).then((response){
      if(response){
        Navigator.of(context).pop("success");
      }else{
        SnackBars.showRedMessage(scaContext, "Hubo un problema en la red no se pudo registrar el pago");
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 8,
          iconTheme: IconThemeData(color: Colors.purple),
          title: Text("bicibici", style: TextStyles.smallPurpleFatText()),
        ),
        body: Builder(
      builder: (sCaContext) => isDataLoading
            ?Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: UtilityWidget.containerloadingIndicator(context),
                    ),
              )
              : ListView(
                children: <Widget>[
                  ListTile(
                        leading: const Icon(Icons.card_membership),
                        title: TextFormField(
                          decoration: InputDecoration(
                              hintText: '#### #### #### ####',
                              labelText: 'numero de tarjeta'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                          
                  ListTile(
                        leading: const Icon(Icons.lock),
                        title: TextFormField(
                          decoration: InputDecoration(
                              hintText: '123',
                              labelText: 'cvv'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      
                  ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'MM/YY',
                              labelText: 'Fecha'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 80,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: FlatButton(
                                          color: Colors.purple,
                                          onPressed: ()=>_makePayment(sCaContext),
                                          shape: StadiumBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Realizar pago", style: TextStyles.smallWhiteFatText(),),
                                          ),
                                        ),
                          ),
                        ],
                      )
                ],
              )));
  }
}
