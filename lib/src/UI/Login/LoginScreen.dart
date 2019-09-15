import 'package:bicibici/src/Models/User.dart';
import 'package:bicibici/src/Services/UserService.dart';
import 'package:bicibici/src/UI/login/ConfirmationScreen.dart';
import 'package:bicibici/src/UI/login/SingUpScreen.dart';
import 'package:bicibici/src/UI/tabs/HomeScreen.dart';
import 'package:bicibici/src/Values/Constants.dart';
import 'package:flutter/material.dart';

import 'package:amazon_cognito_identity_dart/cognito.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userService = UserService(Constants.userPool);
  User _user = User();
  bool _isAuthenticated = false;

  Future<UserService> _getValues() async {
    await _userService.init();
    _isAuthenticated = await _userService.checkAuthenticated();
    return _userService;
  }

  submit(BuildContext context) async {
    _formKey.currentState.save();
    String message;
    try {
      _user = await _userService.login(_user.email, _user.password);
      message = 'User sucessfully logged in!';
      if (!_user.confirmed) {
        message = 'Please confirm user account';
      }
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        message = 'An unknown client error occured';
      }
    } catch (e) {
      message = 'An unknown error occurred';
    }
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () async {
          if (_user.hasAccess) {
            Navigator.pop(context);
            if (!_user.confirmed) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfirmationScreen(email: _user.email)),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
              );
            }
          }
        },
      ),
      duration: Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getValues(),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          if (snapshot.hasData) {
            if (_isAuthenticated) {
              return HomeScreen();
            }
            final Size screenSize = MediaQuery.of(context).size;
            return Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: Form(
                      key: _formKey,
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
                              onSaved: (String email) {
                                _user.email = email;
                              },
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'password',labelText: 'Contraseña'),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              onSaved: (String password) {
                                _user.password = password;
                              },
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                                      submit(context);
                                    },
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpScreen()),
                  );
                                    },
                                    color: Colors.purple,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  },
              ),
            );
          }
          return new Scaffold(
              appBar: new AppBar(title: new Text('Loading...')));
        });
  }
}