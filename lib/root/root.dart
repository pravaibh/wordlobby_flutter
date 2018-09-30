import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordlobby/collection/collection.dart';
import 'package:wordlobby/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordlobby/store/store.dart';
import 'package:wordlobby/transactions/transactions.dart';

List<DocumentSnapshot> wordList;

class Root extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RootState();
  Root(List<DocumentSnapshot> wl) {
    wordList = wl;
  }
}

class RootState extends State<Root> {
  bool dragOverTarget = false;
  int cardsCounter = 0;
  int _currentIndex;
  List<Widget> body = new List<Widget>();

  @override
  void initState() {
    super.initState();
    body.add(Store());
    body.add(Collection());
    body.add(Home(wordList));
    body.add(Transactions());
    _currentIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
//      iconSize: 24.0,// new
        currentIndex: _currentIndex,
        fixedColor: Colors.greenAccent,
//      type: BottomNavigationBarType.fixed,// new
        items: [
          new BottomNavigationBarItem(
              icon: Icon(
                Icons.store,
              ),
              title: Text(''),
              backgroundColor: Colors.amber),
          new BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              title: Text(''),
              backgroundColor: Colors.redAccent),
          new BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text(''),
              backgroundColor: Colors.green),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet,
            ),
            title: Text(''),
            backgroundColor: Colors.amber,
          ),
          new BottomNavigationBarItem(
              icon: Icon(
                Icons.exit_to_app,
              ),
              backgroundColor: Colors.black,
              title: Text(''))
        ],
      ),
      body: body[_currentIndex]
    );
  }

  void onTabTapped(int value) {
    if (value == 4) {
      FirebaseAuth.instance.signOut().then((onVal) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Logged out successfully')));
        Navigator.popUntil(context, (a) => a.isFirst);
      });
    }
    if (value == 3) {
      _currentIndex = 3;
    }
    if (value == 2) {
      _currentIndex = 2;
    }
    if (value == 1) {
      _currentIndex = 1;
    }
    if (value == 0) {
      _currentIndex = 0;
    }
    setState(() => _currentIndex);
  }
}
