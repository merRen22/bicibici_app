import 'package:bicibici/src/Models/Plan.dart';
import 'package:bicibici/src/Presenter/mainTabPresenter.dart';
import 'package:bicibici/src/UI/tabs/mainTab/Pagos/DialogPagar.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/material.dart';

class DialogSeleccionarPago extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DialogSeleccionarPagoState();
}

class _DialogSeleccionarPagoState extends State<DialogSeleccionarPago> {
  DateTime selectedDate = DateTime.now();
  List<Plan> planes;
  bool isDataLoading = true;
  int _selectedItem = -1;

  _fetchUserPlans() async {
    await presenter.obtenerPlanes().then((response){
      planes = response;
      setState(() {
        isDataLoading = false;
      });
    });
  }

  Widget card(Plan plan, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.all(2),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      elevation: 2,
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[Center(
                    child: Text(
                      plan.cost.toString() + " PEN",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 15,
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w700),
                ),
              ),Center(
                    child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    plan.duration.toString() + " dias",
                    style: TextStyles.mediumBlackFatText(),
                    maxLines: 1,
                  ),
                )),
            ],
          )),
    );
  }

  @override
  void initState() {
    _fetchUserPlans();
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
          title: Text("Obtén una membresía", style: TextStyles.smallPurpleFatText()),
        ),
        body: Builder(
      builder: (sCaContext) => isDataLoading
            ?Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: UtilityWidget.containerloadingIndicator(context),
                    ),
              )
              : ListView.builder(
                itemCount: planes.length,
                itemBuilder: (BuildContext contextListEjercicioPorDia,int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(
                        builder: (context) => DialogPagar(plan: planes[index],)),
                        ).then((response){
                          if(response == "success"){
                            Navigator.of(context).pop("success");
                          }
                        });
                    },
                    child: card(planes[index], index),);
            })));
  }
}
