// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/GatePass/addGatePass.dart';

// ignore: must_be_immutable
class TypeOfGatePass extends StatefulWidget {
  TypeOfGatePass({super.key, required this.society, required this.flatNo});
  String society;
  String flatNo;

  @override
  State<TypeOfGatePass> createState() => _TypeOfGatePassState();
}

class _TypeOfGatePassState extends State<TypeOfGatePass> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getTypeOfGatePass(widget.society, widget.flatNo);
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
        appBar: AppBar(
          title: const Text('Type of Gate Pass'),
          backgroundColor: primaryColor,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3.0,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: colors[index % colors.length],
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          minVerticalPadding: 0.3,
                          title: Text(
                            dataList[index]['gatePassType'],
                            style: TextStyle(color: Colors.white),
                          ),
                          // subtitle: Text(data.docs[index]['city']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return AddGatePass(
                                  gatePassType: dataList[index]['gatePassType'],
                                  text: dataList[index]['text'],
                                  society: widget.society,
                                  flatNo: widget.flatNo,
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ]));
  }

  Future<void> getTypeOfGatePass(society, flatNo) async {
    isLoading = true;
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('gatePassApplications')
        .doc(society)
        .collection('flatno')
        .doc(flatNo)
        .collection('gatePassType')
        .get();

    List<dynamic> allNocType =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();

    // ignore: unused_local_variable
    dataList = allNocType;
    setState(() {
      isLoading = false;
    });
  }
}
