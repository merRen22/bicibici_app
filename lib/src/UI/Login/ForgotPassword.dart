import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Services/UserService.dart';
import 'package:bicibici/src/UI/login/SingUpScreen.dart';
import 'package:bicibici/src/UI/tabs/HomeScreen.dart';
import 'package:bicibici/src/Values/Constants.dart';
import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:bicibici/src/app.dart';
import 'package:flutter/material.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _userService = UserService(Constants.userPool);
  User _user = User();
  bool _isDataLoading = false;
  bool _isAuthenticated = false;
  bool _passwordVisible = true;
  
  var _formMailKey = GlobalKey<FormFieldState>();
  var _formPasswordKey = GlobalKey<FormFieldState>();
  var _formCodeKey = GlobalKey<FormFieldState>();
  
  Future<UserService> _getValues() async {
    await _userService.init();
    _isAuthenticated = await _userService.checkAuthenticated();
    return _userService;
  }

  forgotPassword(BuildContext context) async {
    if(_formMailKey.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(context, "Debe introducir un correo para poder generar una nueva contraseña");
    }else{
      setState(() {
        _isDataLoading = true;
      });
      _user.email = _formMailKey.currentState.value.toString();
    try {
      String data = await _userService.forgotPassword(_user.email);
      setState(() {
        _isDataLoading = false;
      });
      SnackBars.showGreenMessage(context, "Se envió un código a ${_user.email}");
    } catch (e) {
      setState(() {
        _isDataLoading = false;
      });
      SnackBars.showRedMessage(context, "Hubo un error inesperado");
    }
    }
  }
  
  newPassword(BuildContext context) async {
    if(
      _formPasswordKey.currentState.value.toString().isEmpty || 
      _formCodeKey.currentState.value.toString().isEmpty ||
      _formMailKey.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(context, "Debe introducir una contraseña nueva, un codigo y una correo");
    }else{   
      if(_formPasswordKey.currentState.value.toString().length < 8){
        SnackBars.showOrangeMessage(context, "La contraseña debe tener una longitud minima de 8");
      }else{
        setState(() {
          _isDataLoading = true;
        });
        _user.password = _formPasswordKey.currentState.value.toString();
        _user.codigo = _formCodeKey.currentState.value.toString();
        _user.email = _formMailKey.currentState.value.toString();
      try {
        bool changed = await _userService.newPassword(_user);
        setState(() {
          _isDataLoading = false;
        });
        changed
        ?SnackBars.showGreenMessage(context, "Tu contraseña fue cambiada")
        :SnackBars.showOrangeMessage(context, "No se pudo cambiar tu contraseña");
      } catch (e) {
        setState(() {
          _isDataLoading = false;
        });
        SnackBars.showRedMessage(context, "Hubo un error inesperado");
      }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getValues(),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                      centerTitle: true,
                      primary: true,
                      elevation: 8,
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.purple),
              ),
              body: Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: _isDataLoading
                    ?UtilityWidget.containerloadingIndicator(context)
                    :ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(60),
                            child: 
                          Text('bicibici',textAlign: TextAlign.center,style: TextStyles.extralargePurpleFatText(),),
                          ),
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: TextFormField(
                              initialValue: "",
                              decoration: InputDecoration(
                                  hintText: 'example@bicibici.com',
                                  labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              key: _formMailKey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[RaisedButton(
                                    shape: StadiumBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Solicitar codigo',
                                        style: TextStyles.smallWhiteFatText(),
                                      ),
                                    ),
                                    onPressed: () => forgotPassword(context),
                                    color: Colors.purple,
                                  ),
                              ],
                            ),
                          ),
                          
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'codigo',
                                labelText: 'Codigo',
                                ),
                              keyboardType: TextInputType.text,
                              key: _formCodeKey,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'nueva contraseña',
                                labelText: 'Contraseña',
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                                  color: Colors.purple[200],
                                  ),
                                  onPressed: () {
                                    setState(() {_passwordVisible = !_passwordVisible;});
                                    },
                          ),
                                ),
                              keyboardType: TextInputType.visiblePassword,
                              key: _formPasswordKey,
                              obscureText: _passwordVisible,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12,12,12,12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[RaisedButton(
                                    shape: StadiumBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '   Cambiar contraseña   ',
                                        style: TextStyles.smallWhiteFatText(),
                                      ),
                                    ),
                                    onPressed: () => newPassword(context),
                                    color: Colors.purple,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  );
                  },
              ),
            );
          }
          return Scaffold(
            body: UtilityWidget.containerloadingIndicator(context),
          );
        });
  }
}