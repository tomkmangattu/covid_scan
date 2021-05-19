import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomerDetails extends StatelessWidget {
  final String userId;
  CustomerDetails({this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        backgroundColor: kAppPrimColor,
      ),
      body: FutureBuilder(
        future: _getCustData(),
        builder: (context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            final data = snapShot.data;
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepPurpleAccent)),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _userFields('User Name', data['userName']),
                  _userFields('PinCode', data['pinCode']),
                  _userFields('Phone Number', data['phoneNo']),
                ],
              ),
            );
          }
          if (snapShot.connectionState == ConnectionState.none) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.error_outlined),
                  const SizedBox(height: 16),
                  Text('Error Loading Data')
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator()),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading Data..',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Padding _userFields(String fieldName, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fieldName),
          Text(value),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getCustData() async {
    final CollectionReference ref = FirebaseFirestore.instance
        .collection('covin_scan')
        .doc(userId)
        .collection(userId)
        .doc('userInfo')
        .collection('userInfo');
    final snapshot = await ref.get();
    return snapshot.docs.first.data();
  }
}
