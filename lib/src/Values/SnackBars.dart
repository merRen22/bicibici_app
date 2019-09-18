import 'package:flutter/material.dart';

class SnackBars {
  static void showConnectionErrorMessage(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: const Text(
          "Hubo un problema en la conexión 😢",
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
            label: 'Ok',
            onPressed: scaffold.hideCurrentSnackBar,
            textColor: Colors.white),
      ),
    );
  }
  
  static void showRedMessage(BuildContext context,String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
            label: 'Ok',
            onPressed: scaffold.hideCurrentSnackBar,
            textColor: Colors.white),
      ),
    );
  }

  static void showOrangeMessage(BuildContext context,String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        content: Text(
          msg,
          maxLines: 2,
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
            label: 'Ok',
            onPressed: scaffold.hideCurrentSnackBar,
            textColor: Colors.white),
      ),
    );
  }
  
  static void showGreenMessage(BuildContext context,String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 4),
        backgroundColor: Colors.green,
        content: Text(
          msg,
          maxLines: 2,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  
}
