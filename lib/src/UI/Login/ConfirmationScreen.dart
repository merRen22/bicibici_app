import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
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
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isDataLoading = false;
  String confirmationCode;
  User _user = User();
  final _userService = UserService(Constants.userPool);
  
  var _formMailKey = GlobalKey<FormFieldState>();
  var _formConfirmationKey = GlobalKey<FormFieldState>();

  _submit(BuildContext context) async {
    if(_formMailKey.currentState.value.toString().isEmpty  || _formConfirmationKey.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(context, 'Debe de completar todos los campos');
    }else{
    bool accountConfirmed = false;
    String message;
    _user.email = _formMailKey.currentState.value.toString();
    confirmationCode = _formConfirmationKey.currentState.value.toString();
    try {
      setState(() {_isDataLoading = true; });
      accountConfirmed = await _userService.confirmAccount(_user.email, confirmationCode);
      message = 'Cuenta confirmada';
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'CodeMismatchException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        message = 'Hubo un error inesperado';
      }
    } catch (e) {
      message = 'Hubo un error inesperado';
    }

    final snackBar = SnackBar(
      content: Text(message, style: TextStyles.smallWhiteFatText(),),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          if (accountConfirmed) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new LoginScreen(email: _user.email)),
            );
          }
        },
      ),
      backgroundColor: accountConfirmed?Colors.green:Colors.orange,
      duration: Duration(seconds: 30),
    );
    
    setState(() {_isDataLoading = false; });
    Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  _resendConfirmation(BuildContext context) async {
    if(_formMailKey.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(context, 'Debe de poner un correo para enviar el codigo');
    }else{
      setState(() {_isDataLoading = true; });
      try {
        await _userService.resendConfirmationCode(_formMailKey.currentState.value);
        setState(() {_isDataLoading = false; });
        SnackBars.showOrangeMessage(context, 'Codigo de confirmación enviado a ${(_formMailKey.currentState.value)}');
      } on CognitoClientException catch (e) {
        if (e.code == 'LimitExceededException' ||
            e.code == 'InvalidParameterException' ||
            e.code == 'ResourceNotFoundException') {
            setState(() {_isDataLoading = false; });
            SnackBars.showRedMessage(context, "Hubo un error inesperado");
        } else {
          setState(() {_isDataLoading = false; });
          SnackBars.showRedMessage(context, "Hubo un error inesperado");
        }
      } catch (e) {
        print(e);
        setState(() {_isDataLoading = false; });
        SnackBars.showRedMessage(context, "Hubo un error inesperado");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        title: Text('bicibici', style: TextStyles.mediumPurpleFatText()),
      ),
      body: Builder(
          builder: (BuildContext context) => _isDataLoading
          ?UtilityWidget.containerloadingIndicator(context)
          :Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(child: Text("Te enviamos un codigo de verificación a tu cuenta de correo",style: TextStyles.smallBlackFatText(),textAlign: TextAlign.center,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(Icons.email),
                          title: TextFormField(
                            initialValue: widget.email,
                            decoration: InputDecoration(
                                hintText: 'example@bicibici.my',
                                labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            key: _formMailKey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(Icons.lock),
                          title: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Código de confirmación'),
                                key: _formConfirmationKey,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                                shape: StadiumBorder(),
                                color: Colors.purple,
                                child: Text(
                                  'Confirmar',
                                  style: TextStyles.smallWhiteFatText()
                                ),
                                onPressed: ()=>_submit(context),
                              ),
                          ),
                        ],
                      ),
                      Center(
                        child: InkWell(
                          child: Text(
                            'Enviar nuevo código',
                            style: TextStyles.smallPurpleFatText(),
                          ),
                          onTap: () => _resendConfirmation(context),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
