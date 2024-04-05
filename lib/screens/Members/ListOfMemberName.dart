// ignore: duplicate_ignore
// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously
//ignore: avoid_web_libraries_in_flutter
// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class MemberNameList extends StatefulWidget {
  static const id = "/MemberNameList";
  MemberNameList({super.key, required this.society, required this.allRoles, required this.userId});
  String society;
  List<dynamic> allRoles = [];
  String userId;
  @override
  State<MemberNameList> createState() => _MemberNameListState();
}

class _MemberNameListState extends State<MemberNameList> {
  final StreamController<List<List<dynamic>>> _data =
      StreamController<List<List<dynamic>>>();

  Stream<List<List<dynamic>>> get _streamData => _data.stream;
  List<bool> isActive = [];

  // void toggleActivation() {
  //   setState(() {
  //     isActive = !isActive;
  //   });
  // }


  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  List<dynamic> alldata = [];
  bool showTable = false;
  bool isLoading = true;

  @override
  void initState() {
    addData();
    fetchMap(widget.society);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            "All Members of ${widget.society}",
            style: const TextStyle(color: white),
          ),
          backgroundColor: primaryColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : columnName.isEmpty
                ? alertBox()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            height: MediaQuery.of(context).size.height * 0.80,
                            width: MediaQuery.of(context).size.width * 0.99,
                            child: StreamBuilder<List<List<dynamic>>>(
                                stream: _streamData,
                                builder: (context, snapshot) {
                                  return DataTable2(
                                    minWidth: 1900,
                                    border:
                                        TableBorder.all(color: Colors.black),
                                    headingRowColor:
                                        const MaterialStatePropertyAll(primaryColor),
                                    headingTextStyle: const TextStyle(
                                        color: Colors.white, fontSize: 50.0),
                                    columnSpacing: 3.0,
                                    columns: List.generate(columnName.length,
                                        (index) {
                                      return DataColumn2(
                                        fixedWidth: index == 1 ? 500 : 130,
                                        label: Text(
                                          columnName[index],
                                          style: const TextStyle(
                                              // overflow: TextOverflow.ellipsis,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }),
                                    rows: List.generate(
                                      growable: true,
                                      data.length,
                                      (index1) => DataRow2(
                                        cells: List.generate(
                                            growable: true,
                                            data[0].length, (index2) {
                                          return
                                              //  data[index1][index2] !=
                                              //         'Status'
                                              //     ?
                                              DataCell(Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            // child: Text(data[index1][index2]),

                                            child: TextFormField(
                                                readOnly: true,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                // controller: controllers[index1][index2],
                                                onChanged: (value) {
                                                  data[index1][index2] = value;
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3.0),
                                                    // border:
                                                    //     const OutlineInputBorder(),
                                                    hintText: data[index1]
                                                        [index2],
                                                    hintStyle: const TextStyle(
                                                        fontSize: 11.0,
                                                        color: Colors.black))),
                                          ));
                                        }),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
      );

  Future<void> storeEditedData() async {
    List<Map<String, dynamic>> mapdata = [];
    Map<String, dynamic> temp = {};
    for (int i = 0; i < data[0].length; i++) {
      temp[columnName[i]] = columnName[i];
    }
    mapdata.add(temp);

    for (List<dynamic> listData in data) {
      Map<String, dynamic> tempMap = {};
      for (int i = 0; i < listData.length; i++) {
        tempMap[columnName[i]] = listData[i];
      }
      mapdata.add(tempMap);
    }
    // print(mapdata);

    FirebaseFirestore.instance
        .collection('members')
        .doc(widget.society)
        .update({"data": mapdata}).whenComplete(
      () => const ScaffoldMessenger(
        child: SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Data Saved Successfully',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('ladgerBill').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    // print(searchedList.length);
    return searchedList;
  }

  Future<void> fetchMap(String societyName) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(societyName)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data1 = docSnapshot.data() as Map<String, dynamic>;
      List<dynamic> mapData = data1['data'];
      List<List<dynamic>> temp = [];
      for (int i = 0; i < mapData.length; i++) {
        temp.add([
          mapData[i]['Flat No.'] ?? '',
          mapData[i]['Member Name'] ?? '',
          mapData[i]['Area'] ?? '',
          mapData[i]['Mobile No.'] ?? '',
          mapData[i]['Email Id'] ?? '',
          mapData[i]['MC Member'] ?? '',
          mapData[i]['Remarks'] ?? '',
          mapData[i]['Parking No.'] ?? '',
          mapData[i]['Tenant Name And Address'] ?? '',
          // mapData[i]['Status'] ?? '',
          // 'Status'
        ]);
      }
      columnName = temp[0];

      data = temp;
      data.removeAt(0);

      for (int i = 0; i < data.length; i++) {
        isActive.add(true);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  addData() {
    _data.add(data);
  }

  addRow() {
    // ignore: no_leading_underscores_for_local_identifiers
    List<dynamic> _blankRow = List.generate(data[0].length, (_) => '');
    data.add(_blankRow);
    _data.add(data);
  }

  alertBox() {
    return const AlertDialog(
      title: Center(
          child: Text(
        'No Data Found',
        style: TextStyle(fontSize: 20, color: Colors.red),
      )),
    );
  }
}

Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/',
    (route) => false,
  );
}
