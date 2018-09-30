import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransactionState();

}

class TransactionState extends State<Transactions>{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login/loginbg.jpg'),
            fit: BoxFit.fitHeight,),
      ),
    );
  }
}