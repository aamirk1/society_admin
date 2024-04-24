import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';

class MemberBillReceipt extends StatefulWidget {
  static const id = "/MemberB                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       illReceipt";
  MemberBillReceipt(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});
  String society;
  List<dynamic> allRoles = [];
  String userId;
  @override
  State<MemberBillReceipt> createState() => _MemberBillReceiptState();
}

class _MemberBillReceiptState extends State<MemberBillReceipt> {
  final TextEditingController monthyears = TextEditingController();

  final TextEditingController _societyNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<String> dateList = [];
  List<List<dynamic>> data = [];

  List<dynamic> headers = [];
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  bool showTable = false;
  List<dynamic> newRow = [];

  // String monthyear = DateFormat('yyyy').format(DateTime.now());
  String fetch = DateFormat('MMMM yyyy').format(DateTime.now());
  @override
  void initState() {
    fetchMap(widget.society, monthyears.text).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _societyNameController.dispose();
    monthyears.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: buttonColor),
          title: Text(
            "All Members Receipt of ${widget.society}",
            style: const TextStyle(color: buttonTextColor),
          ),
          backgroundColor: buttonColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 150, right: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: const TextStyle(color: Colors.white),
                            controller: monthyears,
                            decoration: const InputDecoration(
                                labelText: 'Selcet Month',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder())),
                        suggestionsCallback: (pattern) async {
                          return await getMonthReceipt(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            textColor: Colors.black,
                            title: Text(suggestion.toString()),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          monthyears.text = suggestion.toString();
                          fetchMap(widget.society, monthyears.text);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ListOfMemberBill(
                          //             societyName: suggestion.toString(),
                          //           )),
                          // );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: buttonColor,
                    ),
                    onPressed: () {
                      signOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: monthyears.text.isEmpty
            ? alertBox()
            : isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          height: MediaQuery.of(context).size.height * 0.82,
                          width: MediaQuery.of(context).size.width,
                          child: columnName.isEmpty
                              ? alertBox()
                              : DataTable2(
                                  minWidth: 1500,
                                  border: TableBorder.all(color: Colors.black),
                                  headingRowColor:
                                      const MaterialStatePropertyAll(
                                    buttonColor,
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 50.0,
                                  ),
                                  columnSpacing: 3.0,
                                  columns:
                                      List.generate(columnName.length, (index) {
                                    return DataColumn2(
                                      fixedWidth:
                                          headers[index] == 'Member Name'
                                              ? 500
                                              : 85,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          columnName[index],
                                          style: const TextStyle(
                                              // overflow: TextOverflow.ellipsis,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
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
                                        return data[index1][index2] != 'Status'
                                            ? DataCell(Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2.0),
                                                // child: Text(data[index1][index2]),

                                                child: TextFormField(
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                    textAlign: TextAlign.center,
                                                    // controller: controllers[index1][index2],
                                                    onChanged: (value) {
                                                      data[index1][index2] =
                                                          value;
                                                    },
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        hintText: data[index1]
                                                            [index2],
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 11.0,
                                                                color: Colors
                                                                    .black))),
                                              ))
                                            : DataCell(ElevatedButton(
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            buttonColor)),
                                                onPressed: () {
                                                  // print("Paid");
                                                },
                                                child: const Text('Pay')));
                                      }),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 15.0, top: 5),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       SizedBox(
                      //         height: 40,
                      //         width: 40,
                      //         child: FloatingActionButton(
                      //           backgroundColor: Colors.green,
                      //           onPressed: storeEditedData,
                      //           child: const Icon(Icons.check),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
      );

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('ladgerReceipt').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    // print(' $tempList');

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    // print(searchedList.length);
    return searchedList;
  }

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
        .collection('ladgerReceipt')
        .doc(widget.society)
        .collection('month')
        .doc(monthyears.text)
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

  Future<void> fetchMap(String societyName, monthyear) async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(societyName)
        .collection('month')
        .doc(monthyear)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data1 = docSnapshot.data() as Map<String, dynamic>;
      List<dynamic> mapData = data1['data'];
      List<List<dynamic>> temp = [];
      headers = mapData.first.keys.toList();
      headers.sort();
      for (int i = 0; i < mapData.length; i++) {
        List<dynamic> rowData = [];
        for (int j = 0; j < headers.length; j++) {
          rowData.add(
            mapData[i][headers[j]],
          );
        }
        temp.add(rowData);
      }
      columnName = headers;
      data = temp;
      data.removeAt(0);

      print('dataaaaa - $data');
      // Use the data map as needed
    }

    // if (docSnapshot.exists) {
    //   Map<String, dynamic> data1 = docSnapshot.data() as Map<String, dynamic>;
    //   List<dynamic> mapData = data1['data'];
    //   List<List<dynamic>> temp = [];
    //   for (int i = 0; i < mapData.length; i++) {
    //     temp.add([
    //       mapData[i]['Flat No.'] ?? '',
    //       mapData[i]['Receipt Date'] ?? '',
    //       mapData[i]['Member Name'] ?? '',
    //       mapData[i]['Amount'] ?? '',
    //       mapData[i]['ChqNo'] ?? '',
    //       mapData[i]['ChqDate'] ?? '',
    //       mapData[i]['Bank Name'] ?? '',
    //     ]);
    //   }
    //   columnName = temp[0];
    //   data = temp;
    //   // print(data);
    //   data.removeAt(0);

    //   // Use the data map as needed
    // }
    setState(() {
      isLoading = false;
    });
  }

  getMonthReceipt(String pattern) async {
    dateList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(widget.society)
        .collection('month')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        dateList.add(tempList[i]);
      } else {
        // dateList.add('Not Availabel');
      }
    }
    // print(searchedList.length);
    return dateList;
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  alertBox() {
    return const AlertDialog(
      title: Center(
          child: Text(
        'Data Not Found! Please Select Month',
        style: TextStyle(fontSize: 20, color: Colors.red),
      )),
    );
  }
}
