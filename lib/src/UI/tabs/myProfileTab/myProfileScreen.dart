import 'package:bicibici/src/Models/Payment.dart';
import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Presenter/myProfilePresenter.dart';
import 'package:bicibici/src/UI/login/LoginScreen.dart';
import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/material.dart';


class MyProfileScreen extends StatefulWidget {
  @override
  MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  bool _isDataLoading = true;
  bool _isMembershipLoading = true;
  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;

  User auxUser = User();
  Payment payment = Payment();

  var _formNombreKey = GlobalKey<FormFieldState>();
  var _formTelefonoKey = GlobalKey<FormFieldState>();
  var _formDireccionKey = GlobalKey<FormFieldState>();

  var _formOldPasswordKey = GlobalKey<FormFieldState>();
  var _formNewPasswordKey = GlobalKey<FormFieldState>();
  
  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  Future _getUserData() async {
    await presenter.getCurrentUser().then((response){
      auxUser = response;
      setState(() {
        _isDataLoading = false;
      });
      _obtenerMembresiaUsuario();
    });
  }
  
  Future _obtenerMembresiaUsuario() async {
    await presenter.obtenerMembresiaUsuario(auxUser.email).then((response){
      setState(() {
        payment = response;
        _isMembershipLoading = false;
      });

    });
  }
  

  Future _resetPassword(BuildContext scaContext) async {
    if(_formOldPasswordKey.currentState.value.toString().isEmpty || _formNewPasswordKey.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(scaContext,"Debe introducir tu antigua y nueva contraseña");
    }else{
      await presenter.resetPassword(
        _formOldPasswordKey.currentState.value.toString(),
        _formNewPasswordKey.currentState.value.toString()).then((response){
        response
        ?SnackBars.showGreenMessage(scaContext,"Se cambio con éxito la contraseña")
        :SnackBars.showOrangeMessage(scaContext,"No se pudo cambiar la contraseña");
        });
    }
  }

  Future _updateUserData(BuildContext scaContext) async {
    if(
      _formTelefonoKey.currentState.value.toString().isEmpty ||
      _formDireccionKey.currentState.value.toString().isEmpty ||
      _formNombreKey.currentState.value.toString().isEmpty
       ){
      SnackBars.showOrangeMessage(scaContext,"Debe completar todos los campos");
    }else{
      setState(() {
        _isDataLoading = true;
      });
      auxUser.address = _formDireccionKey.currentState.value.toString();
      auxUser.phone = _formTelefonoKey.currentState.value.toString();
      auxUser.name = _formNombreKey.currentState.value.toString();
      await presenter.updateUserData(auxUser.toUserAttributes()).then((response){
        setState(() {
          _isDataLoading = false;
          });
        response
        ?SnackBars.showGreenMessage(scaContext,"Se cambio con éxito los datos del usuario")
        :SnackBars.showOrangeMessage(scaContext,"No se pudo cambiar los datos");
        });
    }
  }

  void _deleteUser() async {
    await presenter.deleteUser().then((response){
      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  void _logOut() async {
    await presenter.logOut().then((response){
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  
  Widget cardMembership(){
    return  Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.green[400],
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 16,
        child: Container(
          height: 180,
          child: Stack(
            children: <Widget>[
              Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40,8,8,4),
                      child: Text("Membresia", textAlign: TextAlign.start,style: TextStyles.mediumWhiteFatText(),),
                    ),
                  )),
                ],
              ),
              _isMembershipLoading
              ?Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,40,8,8),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  ),
                ],
              )
              :payment == null || payment.startDate == null || payment.startDate == ""
              ?Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.cancel, color: Colors.white,size: 40,),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Aún no cuentas con una membresía",textAlign: TextAlign.center,style: TextStyles.mediumWhiteFatText(),),
                    ),
                  )
                ],
              )
              :Column(
                children: <Widget>[
                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Costo ${(payment.cost)} soles", textAlign: TextAlign.start,style: TextStyles.smallWhiteFatText()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Duracion ${(payment.duration)} días", textAlign: TextAlign.start,style: TextStyles.smallWhiteFatText()),
                    )  
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40,8,8,8),
                    child: Text("Inicio ${(payment.startDate)}", textAlign: TextAlign.start,style: TextStyles.smallWhiteFatText(),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40,8,8,8),
                    child: Text("Fin ${(payment.endDate)}", textAlign: TextAlign.start,style: TextStyles.smallWhiteFatText()),
                  ),
                ],
              ) 
                ],
              )
            
              ],
          ),
          if(payment != null && payment.startDate != null && payment.startDate != "")Positioned(
            right: 20,
            bottom: 20,
            child: Icon(Icons.directions_bike, color: Colors.black54,size: 60,))
            ],
          ),
        ));
  }

  Widget cardUserAttributes(){
    return  Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 8,
        child: Column(
          children: <Widget>[
                            ListTile(
                                leading: const Icon(Icons.person),
                                title: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'nombre',
                                      labelText: 'Nombre'),
                                      initialValue: auxUser.name,
                                  keyboardType: TextInputType.text,
                                  key: _formNombreKey,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.home),
                                title: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'dirección',
                                      labelText: 'dirección'),
                                      initialValue: auxUser.address,
                                  keyboardType: TextInputType.text,
                                  key: _formDireccionKey,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'teléfono',
                                      labelText: 'teléfono'),
                                      initialValue: auxUser.phone,
                                  keyboardType: TextInputType.number,
                                  key: _formTelefonoKey,
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
                                              'Guardar',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () => _updateUserData(context),
                                          color: Colors.purple,
                                        )])),
          ]));
  }

  Widget cardPassword(){
    return  Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 8,
        child: Column(
          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.lock),
                              title: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  labelText: 'Contraseña antigua',
                                  suffixIcon: IconButton(
                                  icon: Icon(_oldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                                  color: Colors.purple[200],
                                  ),
                                  onPressed: () {
                                    setState(() {_oldPasswordVisible = !_oldPasswordVisible;});
                                    },
                          ),
                        ),
                        key: _formOldPasswordKey,
                        obscureText: _oldPasswordVisible,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      labelText: 'Contraseña nueva',
                      suffixIcon: IconButton(
                            icon: Icon(
                              _newPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                              color: Colors.purple[200],
                            ),
                            onPressed: () {
                              setState(() {_newPasswordVisible = !_newPasswordVisible;});
                            },
                          ),
                        ),
                        obscureText: _newPasswordVisible,
                        key: _formNewPasswordKey,
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
                                              'Cambiar contraseña',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () =>_resetPassword(context),
                                          color: Colors.purple,
                                        )])),
            
          ]));
  }

  Widget cardLeaveApp(){
    return  Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 8,
        child: Column(
          children: <Widget>[
            Padding(
                                padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        RaisedButton(
                                              shape: StadiumBorder(),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(Icons.cancel, color: Colors.white,),
                                                      SizedBox(width: 8,),
                                                      Text('Cerrar sesión',style: TextStyle(color: Colors.white))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onPressed: () => _logOut(),
                                              color: Colors.purple,
                                            ),
                                      ],
                                    )
                                        ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0,30,20,40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: <Widget>[
                                        Text("Darme de baja ", style:TextStyles.mediumBlackFatText()),
                                        SizedBox(height: 8,),
                                        Text("Eliminar mi cuenta de la aplicación ", style:TextStyles.smallPurpleFatText()),
                                      ],
                                    ),
                                  ),
                                  
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                    padding: const EdgeInsets.fromLTRB(40,8,8,8),
                                    child: FloatingActionButton(
                                      onPressed: ()=> _deleteUser(),
                                      elevation: 0,
                                      backgroundColor: Colors.red,
                                      heroTag: UniqueKey(),
                                      key: UniqueKey(),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ))
                                ],
                              ),
                            )
          ]));
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
                                        title: Text("Mi perfil", style: TextStyles.mediumPurpleFatText()),
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
                            cardMembership(),
                            cardUserAttributes(),
                            cardPassword(),
                            cardLeaveApp()
                            ],
                            ),
                    ),
                  ],
                )
                ));
  }

}