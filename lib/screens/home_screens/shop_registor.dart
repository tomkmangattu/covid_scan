import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_scan/models/visits.dart';
import 'package:covid_scan/screens/home_screens/user_details.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';

class ShopRegistor extends StatefulWidget {
  @override
  _ShopRegistorState createState() => _ShopRegistorState();
}

class _ShopRegistorState extends State<ShopRegistor> {
  final List<DataColumn> _columns = [
    DataColumn(label: Text('Time')),
    DataColumn(label: Text('Cust. Name')),
  ];

  final CollectionReference _ref =
      fireStoreRef.doc('ShopRegistor').collection('ShopRegistor');
  DateTime _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: kAppPrimColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () {
              _chooseDate(context);
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Choose Date'),
                  Text(visitsdateFormator.format(_now))
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: _loadTravelData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Visits>> snapShot) {
              if (snapShot.connectionState == ConnectionState.done) {
                final data = snapShot.data;
                return Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: _columns,
                        rows: data.map((Visits v) {
                          return DataRow(
                              cells: [
                                DataCell(Text(
                                    visitstimeFormator.format(v.dateTime))),
                                DataCell(Text(v.shopName)),
                              ],
                              onSelectChanged: (bool selected) {
                                if (selected) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CustomerDetails(
                                        userId: v.shopId,
                                      ),
                                    ),
                                  );
                                }
                              });
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }
              if (snapShot.connectionState == ConnectionState.none) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outlined, size: 60),
                      Text('Sorry Error loading Data')
                    ],
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Please wait loading Data...',
                    textAlign: TextAlign.center,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _chooseDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _now,
        firstDate: DateTime(_now.year - 5),
        lastDate: DateTime(_now.year + 5));
    if (picked != null) if (picked != _now) {
      setState(() {
        _now = picked;
      });
    }
  }

  Future<List<Visits>> _loadTravelData() async {
    List<Visits> userVisit = [];
    final CollectionReference ref = _ref
        .doc(visitsdateFormator.format(_now))
        .collection(visitsdateFormator.format(_now));
    final QuerySnapshot snapshot = await ref.get();
    for (QueryDocumentSnapshot<Object> document in snapshot.docs) {
      // print(document.data());
      userVisit.add(
        Visits(
          shopName: document['custName'] ?? '',
          dateTime: document['DateTime'].toDate(),
          shopId: document['userId'],
        ),
      );
    }
    return userVisit;
  }
}
