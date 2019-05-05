import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/UI/Login/LoginScreen.dart';
import '../src/UI/HomeScreen.dart';

mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class App extends StatelessWidget with PortraitModeMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: Colors.purple,
      ),
      home: Scaffold(
        body: LoginScreen(),
      ),
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => new HomeScreen()
      },
    );
  }
}