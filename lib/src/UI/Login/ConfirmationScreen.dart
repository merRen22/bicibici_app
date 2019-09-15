import 'package:flutter/material.dart';
import '../../Models/User.dart';
import '../../Values/Constants.dart';
import '../../Services/UserService.dart';
import '../../Values/TextStyles.dart';
import './LoginScreen.dart';

import 'package:amazon_cognito_identity_dart/cognito.dart';

class ConfirmationScreen extends StatefulWidget {
  ConfirmationScreen({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _ConfirmationScreenState createState() => new _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String confirmationCode;
  User _user = new User();
  final _userService = new UserService(Constants.userPool);

  _submit(BuildContext context) async {
    _formKey.currentState.save();
    bool accountConfirmed;
    String message;
    try {
      accountConfirmed =
          await _userService.confirmAccount(_user.email, confirmationCode);
      message = 'Account successfully confirmed!';
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'CodeMismatchException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        message = 'Unknown client error occurred';
      }
    } catch (e) {
      message = 'Unknown error occurred';
    }

    final snackBar = new SnackBar(
      content: new Text(message),
      action: new SnackBarAction(
        label: 'OK',
        onPressed: () {
          if (accountConfirmed) {
            Navigator.pop(context);
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new LoginScreen(email: _user.email)),
            );
          }
        },
      ),
      duration: new Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  _resendConfirmation(BuildContext context) async {
    _formKey.currentState.save();
    String message;
    try {
      await _userService.resendConfirmationCode(_user.email);
      message = 'Confirmation code sent to ${_user.email}!';
    } on CognitoClientException catch (e) {
      if (e.code == 'LimitExceededException' ||
          e.code == 'InvalidParameterException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        message = 'Unknown client error occurred';
      }
    } catch (e) {
      message = 'Unknown error occurred';
    }

    final snackBar = new SnackBar(
      content: new Text(message),
      action: new SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
      duration: new Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        title: new Text('bicibici', style: TextStyles.mediumPurpleFatText()),
      ),
      body: Builder(
          builder: (BuildContext context) => new Container(
                child: new Form(
                  key: _formKey,
                  child: new ListView(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.email),
                        title: new TextFormField(
                          initialValue: widget.email,
                          decoration: new InputDecoration(
                              hintText: 'example@bicibici.my',
                              labelText: 'Email'),
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
                              labelText: 'Código de confirmación'),
                          onSaved: (String code) {
                            confirmationCode = code;
                          },
                        ),
                      ),
                      new Container(
                        padding: new EdgeInsets.all(20.0),
                        width: screenSize.width,
                        child: new RaisedButton(
                          shape: StadiumBorder(),
                          color: Colors.purple,
                          child: new Text(
                            'Confirmar',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _submit(context);
                          },
                        ),
                        margin: new EdgeInsets.only(
                          top: 10.0,
                        ),
                      ),
                      new Center(
                        child: new InkWell(
                          child: new Text(
                            'Enviar nuevo código',
                            style: new TextStyle(color: Colors.purple),
                          ),
                          onTap: () {
                            _resendConfirmation(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
