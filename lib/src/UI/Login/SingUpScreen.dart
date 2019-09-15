import 'package:flutter/material.dart';
import '../../Models/User.dart';
import '../../Values/Constants.dart';
import '../../Services/UserService.dart';
import './ConfirmationScreen.dart';
import '../../Values/TextStyles.dart';

import 'package:amazon_cognito_identity_dart/cognito.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  User _user = new User();
  bool passwordVisible = true;
  final userService = new UserService(Constants.userPool);

  void submit(BuildContext context) async {
    _formKey.currentState.save();

    String message;
    bool signUpSuccess = false;
    try {
      _user = await userService.signUp(_user);
      signUpSuccess = true;
      message = 'Se registró la cuenta 😊';
    } on CognitoClientException catch (e) {
      if (e.code == 'UsernameExistsException' ||
          e.code == 'InvalidParameterException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        message = 'Los campos no cumplen con las condiciones necesarias';
      }
    } catch (e) {
      message = 'Hubo un problema en la conexión 😢';
    }

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: message=="Se registró la cuenta 😊"?Colors.green:Colors.red,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          if (signUpSuccess) {
            Navigator.pop(context);
            if (!_user.confirmed) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(email: _user.email)),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        title: Text('bicibici', style: TextStyles.mediumPurpleFatText()),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.email),
                  title: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'ejemplo@bicibici.com', labelText: 'Email'),
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
                      hintText: 'Password!',
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.purple[200],
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: passwordVisible,
                    onSaved: (String password) {
                      _user.password = password;
                    },
                  ),
                ),
                
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'nombre',
                                  labelText: 'Nombre'),
                              keyboardType: TextInputType.text,
                              onSaved: (String name) {
                                _user.name = name;
                              },
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.home),
                            title: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'dirección',
                                  labelText: 'dirección'),
                              keyboardType: TextInputType.text,
                              onSaved: (String address) {
                                _user.address = address;
                              },
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'teléfono',
                                  labelText: 'teléfono'),
                              keyboardType: TextInputType.number,
                              onSaved: (String phone) {
                                _user.phone = phone;
                              },
                            ),
                          ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Registrarme',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          submit(context);
                        },
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
