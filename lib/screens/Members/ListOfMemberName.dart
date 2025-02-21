// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Members/uploadExcel.dart';

// ignore: must_be_immutable
class MemberNameList extends StatefulWidget {
  static const id = "/MemberNameList";
  MemberNameList(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});
  final String society;
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

  final _formKey = GlobalKey<FormState>();

  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  List<dynamic> alldata = [];
  bool showTable = false;
  bool isLoading = true;

  @override
  void initState() {
    addData();
    fetchMap(widget.society).whenComplete(() {
      showTable = true;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          title: InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return societyDetails(
              //     societyNames: widget.society,
              //   );
              // }));
            },
            child: Text(
              "All Members of ${widget.society}",
              style: const TextStyle(color: white),
            ),
          ),
          backgroundColor: primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return UpExcel(societyName: widget.society);
                        }),
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Center(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: showTable == false
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text('Collecting Data...')
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(2.0),
                                  height: MediaQuery.of(context).size.height * 0.80,
                                  width:
                                      MediaQuery.of(context).size.width * 0.99,
                                  child: StreamBuilder<List<List<dynamic>>>(
                                      stream: _streamData,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        return columnName.isEmpty
                                            ? Container(
                                                child: alertBox(),
                                              )
                                            : DataTable2(
                                                minWidth: 1900,
                                                border: TableBorder.all(
                                                    color: Colors.black),
                                                headingRowColor:
                                                    const WidgetStatePropertyAll(
                                                        primaryColor),
                                                headingTextStyle:
                                                    const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 50.0),
                                                columnSpacing: 3.0,
                                                columns: List.generate(
                                                    columnName.length, (index) {
                                                  return DataColumn2(
                                                    fixedWidth:
                                                        index == 1 ? 500 : 130,
                                                    label: Text(
                                                      columnName[index],
                                                      style: const TextStyle(
                                                          // overflow: TextOverflow.ellipsis,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  );
                                                }),
                                                rows: List.generate(
                                                  growable: true,
                                                  data.length,
                                                  (index1) => DataRow2(
                                                    cells: List.generate(
                                                        growable: true,
                                                        data[0].length,
                                                        (index2) {
                                                      return
                                                          //  data[index1][index2] !=
                                                          //         'Status'
                                                          //     ?
                                                          DataCell(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 2.0),
                                                        // child: Text(data[index1][index2]),

                                                        child: TextFormField(
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                            // controller: controllers[index1][index2],
                                                            onChanged: (value) {
                                                              data[index1]
                                                                      [index2] =
                                                                  value;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                                    contentPadding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            3.0,
                                                                        right:
                                                                            3.0),
                                                                    // border:
                                                                    //     const OutlineInputBorder(),
                                                                    hintText: data[
                                                                            index1]
                                                                        [
                                                                        index2],
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        color: Colors
                                                                            .black))),
                                                      ));
                                                      // : DataCell(
                                                      //     Padding(
                                                      //       padding:
                                                      //           const EdgeInsets
                                                      //                   .only(
                                                      //               left: 8.0),
                                                      //       child: ElevatedButton(
                                                      //         onPressed: () {
                                                      //           setState(() {
                                                      //             isActive[
                                                      //                     index1] =
                                                      //                 !isActive[
                                                      //                     index1];
                                                      //           });
                                                      //         },
                                                      //         style:
                                                      //             ElevatedButton
                                                      //                 .styleFrom(
                                                      //           backgroundColor:
                                                      //               isActive[
                                                      //                       index1]
                                                      //                   ? Colors
                                                      //                       .red
                                                      //                   : Colors
                                                      //                       .green,
                                                      //         ),
                                                      //         child: Text(
                                                      //           isActive[index1]
                                                      //               ? 'Deactivate'
                                                      //               : 'Activate',
                                                      //           style:
                                                      //               const TextStyle(
                                                      //             fontSize: 18.0,
                                                      //             color: Colors
                                                      //                 .white,
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   );
                                                    }),
                                                  ),
                                                ),
                                              );
                                      }),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 5),
                            //   child: FloatingActionButton(
                            //     heroTag: 'add',
                            //     onPressed: () {
                            //       addRow();
                            //     },
                            //     child: const Icon(Icons.add),
                            //   ),
                            // ),
                            FloatingActionButton(
                              backgroundColor: primaryColor,
                              heroTag: 'save',
                              onPressed: storeEditedData,
                              child: const Icon(Icons.check),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      );

  Future<void> storeEditedData() async {
    List<Map<String, dynamic>> mapdata = [];
    Map<String, dynamic> temp = {};
    // print("data - $data");
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

  Future<void> fetchMap(String societyName) async {
    isLoading = true;

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
          mapData[i]['Flat No.'].toString(),
          mapData[i]['Member Name'].toString(),
          mapData[i]['Area'].toString(),
          mapData[i]['Mobile No.'].toString(),
          mapData[i]['Email Id'].toString(),
          mapData[i]['MC Member'].toString(),
          mapData[i]['Remarks'].toString(),
          mapData[i]['Parking No.'].toString(),
          mapData[i]['Tenant Name And Address'].toString(),
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

  // addRow() {
  //   // ignore: no_leading_underscores_for_local_identifiers
  //   List<dynamic> _blankRow = List.generate(data[0].length, (_) => '');
  //   data.add(_blankRow);
  //   _data.add(data);
  // }

  alertBox() async {
    await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('No Data Found'),
          );
        });
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }
}
