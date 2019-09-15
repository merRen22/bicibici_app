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
  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;

  User auxUser = User();



  final _formKey = GlobalKey<FormState>();
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
                :ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Mi perfil", style: TextStyles.mediumPurpleFatText()),
                            ),
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


                              Padding(
                                padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
                                          shape: StadiumBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Cerrar sesión',style: TextStyle(color: Colors.white),),
                                          ),
                                          onPressed: () => _logOut(),
                                          color: Colors.purple,
                                        )
                                        ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0,30,20,40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Darme de baja ", style:TextStyles.mediumBlackFatText()),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(40,8,8,8),
                                    child: FloatingActionButton(
                                      onPressed: ()=> _deleteUser(),
                                      elevation: 0,
                                      backgroundColor: Colors.red,
                                      heroTag: UniqueKey(),
                                      key: UniqueKey(),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  )
                                ],
                              ),
                            )
                            ],
                            ),
                    ),
                  ],
                )
                )));
  }

}