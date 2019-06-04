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
      _user = await userService.signUp(_user.email, _user.password, _user.name);
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

    final snackBar = new SnackBar(
      content: new Text(message),
      backgroundColor: message=="Se registró la cuenta 😊"?Colors.green:Colors.red,
      action: new SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          if (signUpSuccess) {
            Navigator.pop(context);
            if (!_user.confirmed) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new ConfirmationScreen(email: _user.email)),
              );
            }
          }
        },
      ),
      duration: new Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        title: new Text('bicibici', style: TextStyles.appBarTitle()),
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return new Form(
            key: _formKey,
            child: new ListView(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.email),
                  title: new TextFormField(
                    decoration: new InputDecoration(
                        hintText: 'ejemplo@bicibici.com', labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (String email) {
                      _user.email = email;
                    },
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.lock),
                  title: new TextFormField(
                    decoration: new InputDecoration(
                      hintText: 'Password!',
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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new RaisedButton(
                    shape: StadiumBorder(),
                    child: new Text(
                      'Registrarme',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      submit(context);
                    },
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
