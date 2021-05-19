import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_scan/models/visits.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';

class UserVisits extends StatelessWidget {
  final List<DataColumn> columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('Time')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: kAppPrimColor,
      ),
      body: FutureBuilder(
        future: _loadTravelData(),
        builder: (BuildContext context, AsyncSnapshot<List<Visits>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            return SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: columns,
                  rows: snapShot.data.map((Visits v) {
                    return DataRow(
                        cells: [
                          DataCell(Text(v.shopName)),
                          DataCell(Text(visitsdateFormator.format(v.dateTime))),
                          DataCell(Text(visitstimeFormator.format(v.dateTime))),
                        ],
                        onSelectChanged: (bool selected) {
                          if (selected) {
                            print(v.dateTime.toString());
                          }
                        });
                  }).toList(),
                ),
              ),
            );
          }
          if (snapShot.connectionState == ConnectionState.none) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 60),
                  Text('Sorry Error loading Data')
                ],
              ),
            );
          }
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Please wait loading Data...',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<Visits>> _loadTravelData() async {
    List<Visits> userVisit = [];
    final CollectionReference ref =
        fireStoreRef.doc('custRegistor').collection('custRegistor');
    final QuerySnapshot snapshot = await ref.get();
    for (QueryDocumentSnapshot<Object> document in snapshot.docs) {
      userVisit.add(
        Visits(
          shopName: document['shopName'] ?? '',
          dateTime: document['DateTime'].toDate(),
          shopId: document['shopId'],
        ),
      );
    }
    return userVisit;
  }
}
