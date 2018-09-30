import 'package:flutter/material.dart';

class Collection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CollectionState();
}

class CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login/loginbg.jpg'),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
