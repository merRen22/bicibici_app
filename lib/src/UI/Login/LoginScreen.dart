import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Services/UserService.dart';
import 'package:bicibici/src/UI/login/ConfirmationScreen.dart';
import 'package:bicibici/src/UI/login/SingUpScreen.dart';
import 'package:bicibici/src/UI/tabs/HomeScreen.dart';
import 'package:bicibici/src/Values/Constants.dart';
import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
import 'package:flutter/material.dart';

import 'package:amazon_cognito_identity_dart/cognito.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userService = UserService(Constants.userPool);
  User _user = User();
  bool _isAuthenticated = false;
  bool _passwordVisible = true;
  
  var _formMailKey = GlobalKey<FormFieldState>();
  var _formPasswordKey = GlobalKey<FormFieldState>();

  Future<UserService> _getValues() async {
    await _userService.init();
    _isAuthenticated = await _userService.checkAuthenticated();
    return _userService;
  }

  submit(BuildContext context) async {
    if(_formMailKey.currentState.value.toString().isEmpty || _formPasswordKey.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(context, "Debe completar todos los campos");
    }else{
      _user.email = _formMailKey.currentState.value.toString();
      _user.password = _formPasswordKey.currentState.value.toString();
    try {
      _user = await _userService.login(_user.email, _user.password);
      if (!_user.confirmed) {
        Navigator.push(context,MaterialPageRoute(builder: (context) => ConfirmationScreen(email: _user.email)),);
      }else{
        Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        SnackBars.showOrangeMessage(context, "No se encuentro al usuario en el sistema");
      } else {
        //client error
        SnackBars.showRedMessage(context, "Hubo un error inesperado");
      }
    } catch (e) {
      //server side error
      Navigator.push(context,MaterialPageRoute(builder: (context) => ConfirmationScreen(email: _user.email)),);
      //SnackBars.showRedMessage(context, e.code);
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getValues(),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          if (snapshot.hasData) {
            return _isAuthenticated
            ?HomeScreen()
            :Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(60),
                            child: 
                          Text('bicibici',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.purple),),
                          ),
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: TextFormField(
                              initialValue: widget.email,
                              decoration: InputDecoration(
                                  hintText: 'example@bicibici.com',
                                  labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              key: _formMailKey,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'password',
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
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[RaisedButton(
                                    shape: StadiumBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Iniciar sesión',
                                        style: TextStyles.smallWhiteFatText(),
                                      ),
                                    ),
                                    onPressed: () => submit(context),
                                    color: Colors.purple,
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12,0,12,12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[RaisedButton(
                                    shape: StadiumBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '   Regístrate   ',
                                        style: TextStyles.smallWhiteFatText(),
                                      ),
                                    ),
                                    onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpScreen()),),
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