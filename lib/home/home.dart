import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordlobby/util/custom_fab.dart';
import 'package:wordlobby/util/swipable_card.dart';

List<DocumentSnapshot> wordList;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState()  => HomeState();
  Home(List<DocumentSnapshot> wl) {
    wordList = wl;
  }
}

class HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login/loginbg.jpg'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.color)),
      ),
      child: Column(
        children: <Widget>[
          SwipableCard(context, wordList),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FancyFab(
                  onPressed: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}