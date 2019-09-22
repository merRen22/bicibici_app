import 'package:bicibici/src/Values/SnackBars.dart';
import 'package:bicibici/src/Values/UtilityWidgets.dart';
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
  User _user = User();
  bool passwordVisible = true;
  bool _isDataLoading = false;
  final userService = UserService(Constants.userPool);
  
  var _formMailKey = GlobalKey<FormFieldState>();
  var _formPasswordKey = GlobalKey<FormFieldState>();
  var _formNameKey = GlobalKey<FormFieldState>();
  var _formAddressKey = GlobalKey<FormFieldState>();
  var _formPhoneKey = GlobalKey<FormFieldState>();

  void submit(BuildContext context) async {
    if(
      _formMailKey.currentState.value.toString().isEmpty ||
      _formPasswordKey.currentState.value.toString().isEmpty ||
      _formNameKey.currentState.value.toString().isEmpty ||
      _formAddressKey.currentState.value.toString().isEmpty ||
      _formPhoneKey.currentState.value.toString().isEmpty
    ){
      SnackBars.showOrangeMessage(context, "Debe completar todos los campos");
    }else{ 
      if(!_formMailKey.currentState.value.toString().contains("@")){
        SnackBars.showOrangeMessage(context, "Tu numero de telefono no cuenta con los digitos necesarios");
      }else{
      if(_formPhoneKey.currentState.value.toString().length<9){
        SnackBars.showOrangeMessage(context, "Tu numero de telefono no cuenta con los digitos necesarios");
      }else{
      if(_formPasswordKey.currentState.value.toString().length<8){
        SnackBars.showOrangeMessage(context, "Tu contraseña debe tener 8 caracteres como mínimo");
      }else{
        _user.email = _formMailKey.currentState.value.toString();
        _user.password = _formPasswordKey.currentState.value.toString();
        _user.name = _formNameKey.currentState.value.toString();
        _user.address = _formAddressKey.currentState.value.toString();
        _user.phone = "+51" +  _formPhoneKey.currentState.value.toString();
        setState(() {
         _isDataLoading = true; 
        });
        try {
          _user = await userService.signUp(_user);
          Navigator.push(context,MaterialPageRoute(builder: (context) => ConfirmationScreen(email: _user.email)),);
          setState(() {_isDataLoading = false; });
        } on CognitoClientException catch (e) {
          setState(() {_isDataLoading = false; });
          if (e.code == 'UsernameExistsException' ||
              e.code == 'InvalidParameterException' ||
              e.code == 'ResourceNotFoundException') {
            SnackBars.showOrangeMessage(context, e.message);//"No se encuentro al usuario en el sistema");
          } else {
            SnackBars.showOrangeMessage(context, 'Los campos no cumplen con las condiciones necesarias');
          }
        } catch (e) {
        setState(() {
         _isDataLoading = false; 
        });
          SnackBars.showRedMessage(context, "Hubo un error inesperado");
        }

      }
    }}}
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
        builder: (BuildContext context) {
          return _isDataLoading
              ?UtilityWidget.containerloadingIndicator(context)
              :ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: 'ejemplo@bicibici.com', labelText: 'Email'),
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
                      key: _formPasswordKey,
                    ),
                  ),
                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'nombre',
                                    labelText: 'Nombre'),
                                keyboardType: TextInputType.text,
                                key: _formNameKey,
                              ),
                            ),
                          ),
                
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.home),
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'dirección',
                                    labelText: 'dirección'),
                                keyboardType: TextInputType.text,
                                key: _formAddressKey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.phone),
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'teléfono',
                                    labelText: 'teléfono'),
                                keyboardType: TextInputType.number,
                                maxLength: 9,
                                key: _formPhoneKey,
                              ),
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
                            style: TextStyles.smallWhiteFatText(),
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
          );
        },
      ),
    );
  }
}
