
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordlobby/root/root.dart';
import 'package:wordlobby/util/data/db_handler.dart';
List<DocumentSnapshot> wordList;

class Splash extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, navigationPage,);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/word-widget');
  }

  @override
  void initState() {
    super.initState();
    initData();
  }



  initData() async {
    wordList = await DataBaseHandler().getLiteWords();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Root(wordList)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}