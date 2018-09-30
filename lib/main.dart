import 'package:flutter/material.dart';
import 'package:wordlobby/auth/login/login.dart';
import 'package:wordlobby/splash.dart';

void main() => runApp(new App());

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AppState();
// This widget is the root of your application.

}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
//        '/word-widget': (BuildContext context) =>  Home(),
        '/splash': (BuildContext context) => Splash(),
        '/login': (BuildContext context) => Login(),
        '/store': (BuildContext context) => Login(),
      },
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Login()),
    );
  }
}
