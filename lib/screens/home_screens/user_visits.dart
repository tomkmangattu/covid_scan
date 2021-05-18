import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_scan/models/visits.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';

class UserVisits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: kAppPrimColor,
      ),
      body: FutureBuilder(
        future: _loadTravelData(),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          return Container();
        },
      ),
    );
  }

  Future<QuerySnapshot<Object>> _loadTravelData() async {
    List<Visits> userVisit = [];
    final CollectionReference ref =
        fireStoreRef.doc('custRegistor').collection('custRegistor');
    final QuerySnapshot snapshot = await ref.get();
    for (QueryDocumentSnapshot<Object> document in snapshot.docs) {
      print(document['shopName']);
      userVisit.add(
        Visits(
          shopName: document['shopName'] ?? '',
          dateTime: document['DateTime'].toDate(),
          shopId: document['shopId'],
        ),
      );
    }
  }
}
