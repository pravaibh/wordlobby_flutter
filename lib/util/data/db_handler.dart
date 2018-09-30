import 'dart:async';
import 'entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseHandler {

  final firestoreInstance = Firestore.instance;

  Future<List<DocumentSnapshot>> getLiteWords() async {

    QuerySnapshot qs = await firestoreInstance.collection('lite_wordlist').getDocuments();
    print('-------------++++++++++++++++++++++--------------+++++++++++');
    print(qs.documents.toString());
    print('-------------++++++++++++++++++++++--------------+++++++++++');
    return qs.documents;
  }
  
}