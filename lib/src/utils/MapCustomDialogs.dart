import 'package:bicibici/src/Values/TextStyles.dart';
import 'package:flutter/material.dart';
class MapCustomDialogs {
  static void alertDialog(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  static void progressDialog(
      {@required BuildContext context, @required String message}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.purple),)),
                    SizedBox(width: 10.0),
                    Text(message,style: TextStyles.smallPurpleFatText(),)
                  ],
                )),
          );
        });
  }
}