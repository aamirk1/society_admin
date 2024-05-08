// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/gatePassProvider.dart';

int globalSelectedIndexForGatePass = 0;

// ignore: must_be_immutable
class TypeOfGatePass extends StatefulWidget {
  TypeOfGatePass(
      {super.key,
      required this.society,
      required this.flatNo,
      required this.passType});
  String society;
  String flatNo;
  List<dynamic> passType = [];

  @override
  State<TypeOfGatePass> createState() => _TypeOfGatePassState();
}

class _TypeOfGatePassState extends State<TypeOfGatePass> {
  bool? isApproved;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // getTypeOfGatePass(widget.society, widget.flatNo);
  }

  List<dynamic> colors = [
    Color.fromARGB(255, 233, 87, 76),
    const Color.fromARGB(255, 102, 174, 233),
    Color.fromARGB(255, 7, 141, 12),
    Color.fromARGB(255, 216, 109, 235),
    const Color.fromARGB(255, 243, 103, 150),
    Color.fromARGB(255, 167, 92, 49),
    Color.fromARGB(255, 23, 48, 163),
    Color.fromARGB(255, 82, 72, 212),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Type of Gate Pass'),
        //   backgroundColor: primaryColor,
        // ),
        body: SingleChildScrollView(
      child: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.passType.length,
          itemBuilder: (context, index) {
            return Card(
              color: colors[index % colors.length],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  minVerticalPadding: 0.3,
                  title: Text(
                    widget.passType[index]['gatePassType'],
                    style: TextStyle(color: Colors.white),
                  ),
                  // subtitle: Text(data.docs[index]['city']),
                  onTap: () async {
                    final provider =
                        Provider.of<GatePassProvider>(context, listen: false);
                    provider.setSelectedPass(
                        widget.passType[index]['gatePassType']);
                    globalSelectedIndexForGatePass = index;
                    // await getpassforApproved(
                    //         widget.flatNo, provider.selectedPass)

                    provider.getFetchDateOfGatePass().whenComplete(() => provider.setLoadWidget(true));
            

                    // NocManagementProvider();
                  },
                ),
              ),
            );
          },
        ),
      ]),
    ));
  }

  // Future<void> getpassforApproved(String flatNo, String gatePassType) async {
  //   final provider = Provider.of<GatePassProvider>(context, listen: false);
  //   DocumentSnapshot documentSnapshot = await firestore
  //       .collection('gatePassApplications')
  //       .doc(widget.society)
  //       .collection('flatno')
  //       .doc(flatNo)
  //       .collection('gatePassType')
  //       .doc(gatePassType)
  //       .get();

  //   if (documentSnapshot.exists) {
  //     Map<String, dynamic> mapData =
  //         documentSnapshot.data() as Map<String, dynamic>;
  //     isApproved = mapData['isApproved'];
  //     provider.setIsApproved(isApproved);
  //   }
  //   print("isApproved - $isApproved");
  // }
}
