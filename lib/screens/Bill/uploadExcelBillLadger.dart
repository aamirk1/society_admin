// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/upload_ledger_provider.dart';
import 'package:society_admin/authScreen/common.dart';

// import '../excel/uploadExcel.dart';

class UpExcelBillLadger extends StatefulWidget {
  static const String id = "/UpExcelBillLadger";
  const UpExcelBillLadger({super.key, required this.societyName});
  final String societyName;

  @override
  State<UpExcelBillLadger> createState() => _UpExcelBillLadgerState();
}

class _UpExcelBillLadgerState extends State<UpExcelBillLadger> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  String url = '';
  List<List<dynamic>> data = [];

  List<Map<String, dynamic>> newData = [];
  List<Map<String, dynamic>> dataMap1 = [];
  List<dynamic> listofdata = [];
  // ignore: prefer_collection_literals
  List<Map<String, dynamic>> dataMap = [];
  Map<String, dynamic> mapExcelData = {};
  List<dynamic> alldata = [];
  // String monthyear = 'February 2024';
  String monthyear = DateFormat('yyyy').format(DateTime.now());

  bool showTable = false;

  @override
  void initState() {
    setMonthlyBoolean();
    super.initState();
    downloadCsv();
  }

  List<String> monthList = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  List<String> selectedMonths = [];

  String monthAndYear = '';
  List<bool> buttonBoolList = [];
  @override
  void dispose() {
    super.dispose();
    _societyNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UploadLedgerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Upload Bill of ${widget.societyName}",
          style: const TextStyle(color: white),
        ),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
               color:primaryColor)),
        actions: const [
          // Padding(
          //   padding: const EdgeInsets.only(right: 8.0),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 200,
          //         child: Padding(
          //           padding: const EdgeInsets.all(10.0),
          //           child: TypeAheadField(
          //             textFieldConfiguration: TextFieldConfiguration(
          //                 controller: _societyNameController,
          //                 style: const TextStyle(color: Colors.white),
          //                 decoration: const InputDecoration(
          //                     labelText: 'Search Society',
          //                     labelStyle: TextStyle(color: Colors.white),
          //                     border: OutlineInputBorder())),
          //             suggestionsCallback: (pattern) async {
          //               return await getUserdata(pattern);
          //             },
          //             itemBuilder: (context, suggestion) {
          //               return ListTile(
          //                 title: Text(suggestion.toString()),
          //               );
          //             },
          //             onSuggestionSelected: (suggestion) {
          //               _societyNameController.text = suggestion.toString();
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => customSocietySide(
          //                       societyNames: suggestion.toString()),
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       IconButton(
          //         icon: Icon(
          //           Icons.logout_rounded,
          //           color: AppBarColor,
          //         ),
          //         onPressed: () {
          //           signOut(context);
          //         },
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ListView.builder(
                  itemCount: monthList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Checkbox(
                          value: buttonBoolList[index],
                          onChanged: (value) {
                            setState(() {
                              buttonBoolList[index] = value!;
                              if (buttonBoolList[index]) {
                                if (!selectedMonths
                                    .contains(monthList[index])) {
                                  selectedMonths.add(monthList[index]);
                                }
                              } else {
                                selectedMonths.remove(monthList[index]);
                              }
                            });
                          },
                        ),
                        Container(
                          width: 70,
                          height: 40,
                          margin: const EdgeInsets.only(right: 2.0, top: 2),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              // minimumSize: MaterialStateProperty.all(
                              //   const Size(40, 15), // Adjust button size
                              // ),
                              backgroundColor: WidgetStatePropertyAll(
                                buttonBoolList[index]
                                    ? const Color.fromARGB(255, 1, 19, 124)
                                    : primaryColor,
                              ),
                            ),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  buttonBoolList[index] =
                                      !buttonBoolList[index];
                                  if (buttonBoolList[index]) {
                                    if (!selectedMonths
                                        .contains(monthList[index])) {
                                      selectedMonths.add(monthList[index]);
                                    }
                                  } else {
                                    selectedMonths.remove(monthList[index]);
                                  }
                                });
                              }
                            },
                            child: Center(
                              child: Text(
                                monthList[index],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              showTable
                  ? Container(
                      padding: const EdgeInsets.all(2.0),
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width * 0.99,
                      child: DataTable2(
                        minWidth: 1700,
                        border: TableBorder.all(color: Colors.black),
                        headingRowColor:
                            const WidgetStatePropertyAll(primaryColor),
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          wordSpacing: 5,
                        ),
                        columnSpacing: 5.0,
                        columns: columnName
                            .map((e) => DataColumn2(
                                  label: Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                        rows: List.generate(
                          growable: true,
                          data.length,
                          (index1) => DataRow2(
                            cells: List.generate(
                              growable: true,
                              data[0].length,
                              (index2) {
                                return DataCell(
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      data[index1][index2].toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(primaryColor),
                        ),
                        onPressed: () async {
                          if (selectedMonths.isNotEmpty) {
                            monthAndYear =
                                "${selectedMonths.join(", ")} $monthyear";
                            selectExcelFile();
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(5),
                                  icon: const Icon(
                                    Icons.warning_amber,
                                    size: 60,
                                    color: Color.fromARGB(255, 212, 194, 25),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    )
                                  ],
                                  title: const Text(
                                    'Please Select At Least One Month!',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          "Upload CSV",
                          style: TextStyle(color: white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(primaryColor),
                        ),
                        onPressed: () {
                          openPdf(url);
                        },
                        child: const Text(
                          "Download CSV",
                          style: TextStyle(color: white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () async {
            // for (int i = 0; i < mapExcelData.length; i++) {
            DocumentReference docRef = FirebaseFirestore.instance
                .collection('ladgerBill')
                .doc(widget.societyName)
                .collection('month')
                .doc(monthAndYear);
            // .set(indexdata, SetOptions(merge: true)

            //     // newData,
            //     )

            await docRef.set({'data': newData}).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Center(
                    child: Text(
                      'Bill Uploaded Successfully!',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              );
            });

            FirebaseFirestore.instance
                .collection('ladgerBill')
                .doc(widget.societyName)
                .set({'name': widget.societyName});
            //       }
            // Perform desired action with the form data

            _societyNameController.clear();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  setMonthlyBoolean() {
    List<bool> boolList = [];
    for (int i = 0; i < monthList.length; i++) {
      boolList.add(false);
    }
    buttonBoolList = boolList;
  }

  setButtonBoolean(int exceptIndex) {
    List<bool> boolList = [];
    for (int i = 0; i < monthList.length; i++) {
      if (i == exceptIndex) {
        boolList.add(true);
      } else {
        boolList.add(false);
      }
    }
    buttonBoolList = boolList;
  }

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    // print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    // print(searchedList.length);
    return searchedList;
  }

  Future<List<List<dynamic>>> selectExcelFile() async {
    final input = FileUploadInputElement()..accept = '.csv';
    input.click();

    await input.onChange.first;
    final files = input.files;
    print('filesssssss- ${files!.first.name}');
    if (files.length == 1) {
      // final myData = await rootBundle.loadString('${files.first.name}');
      final reader = FileReader();
      reader.readAsText(files[0]);
      await reader.onLoad.first;
      final myData = reader.result as String;

      List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
      print(csvTable);
      data = csvTable;
      print('dataaaaaa- $data');
      //   final sheet = excel.tables[table];
      // if (columnName.isEmpty) {
      //   for (var cells in data[0]) {
      //     columnName.add(cells!.toString());
      //   }
      // }

      for (var a in data[0]) {
        columnName.add(a.toString().trim());
      }
      for (var rows in data) {
        Map<String, dynamic> tempMap = {};

        print('columnname - $columnName');

        List<dynamic> rowData = [];
        for (var cell in rows) {
          rowData.add(cell?.toString() ?? '');
        }
        for (int i = 0; i < columnName.length; i++) {
          tempMap[columnName[i]] = rowData[i];
        }
        alldata.add(rowData);

        newData.add(tempMap);
        print('alldata $newData');
        // print('alldata - $alldata');

        tempMap = {};
      }

      alldata.removeAt(0);
      print('aaaa - $newData');

      data.removeAt(0);
      showTable = true;
      setState(() {});
    }
    return data;
  }

  getdat() async {
    for (int i = 0; i < data.length; i++) {
      FirebaseFirestore.instance
          .collection('ladgerBill')
          .doc(widget.societyName)
          .collection('tableData')
          .doc('$i')
          .set({
        'societyName': widget.societyName,
        '$i': data[i],
      }).then((value) {
        // ignore: avoid_print
        print('Done!');
      });
    }
  }

  Future<String> downloadCsv() async {
    final storage = FirebaseStorage.instance;
    final Reference ref = storage.ref('template');
    ListResult allFiles = await ref.listAll();
    url = await allFiles.items[1].getDownloadURL();
    print('url - $url');
    return url.toString();
  }

  openPdf(String url) {
    if (kIsWeb) {
      html.window.open(url, '_blank');
      final encodedUrl = Uri.encodeFull(url);
      html.Url.revokeObjectUrl(encodedUrl);
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
  }
}
