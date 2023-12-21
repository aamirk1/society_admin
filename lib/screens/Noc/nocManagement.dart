import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NocManagement extends StatefulWidget {
  const NocManagement({super.key});

  @override
  State<NocManagement> createState() => _NocManagementState();
}

class _NocManagementState extends State<NocManagement> {
  dynamic dataList = [];
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('NOC Management \n Module'),
    ));
  }

  Future<void> getFlatNum(String selectedSociety) async {
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('nocApplications')
        .doc(selectedSociety)
        .collection('flatno')
        .get();

    List allFlat = flatNumQuerySnapshot.docs.map((e) => e.data()).toList();

    // ignore: unused_local_variable
    List<dynamic> dataList = allFlat;
  }
}
