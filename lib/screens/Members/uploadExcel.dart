// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Members/custom_textfield.dart';

// import '../excel/uploadExcel.dart';

class UpExcel extends StatefulWidget {
  static const String id = "/UpExcel";
  const UpExcel({super.key, required this.societyName});
  final String societyName;

  @override
  State<UpExcel> createState() => _UpExcelState();
}

class _UpExcelState extends State<UpExcel> {
  String url = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  Map<String, dynamic> fieldMap = {};
  List<dynamic> fielddata = [];

  bool showTable = false;

  @override
  void initState() {
    super.initState();
    downloadCsv();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Add Member in ${widget.societyName}",
          style: const TextStyle(color: white),
        ),
        backgroundColor: primaryColor,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              showTable
                  ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        height: 398,
                        width: MediaQuery.of(context).size.width,
                        child: DataTable2(
                          minWidth: 1700,
                          // border: const TableBorder(
                          //     horizontalInside: BorderSide(
                          //   color: Colors.black,
                          // )),
                          border: TableBorder.all(color: Colors.black),
                          headingRowColor:
                              const WidgetStatePropertyAll(Colors.blue),
                          headingTextStyle: const TextStyle(
                              color: Colors.white,
                              // fontSize: 24,
                              wordSpacing: 5),
                          columnSpacing: 5.0,
                          columns: columnName
                              .map((e) => DataColumn2(
                                    label: Text(
                                      e,
                                      // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          // overflow: TextOverflow.ellipsis,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              .toList(),
                          rows: List.generate(
                            growable: true,
                            data.length,
                            (index1) => DataRow2(
                              cells: List.generate(
                                  growable: true, data[0].length, (index2) {
                                return DataCell(Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(data[index1][index2]),
                                ));
                              }),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              // SizedBox(height: 10),
              // Column(children: [
              //   Table(
              // children: [getdat()],
              //   ),
              // ]),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: selectExcelFile,
                        child: const Text(
                          "Upload Excel",
                        )),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () {
                          openPdf(url);
                        },
                        child: const Text(
                          "Download CSV",
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // fieldMap['Flat No.: '] = s_flatNo.text;
          // fieldMap['Member Name: '] = s_name.text;
          // fieldMap['Area: '] = s_area.text;
          // fieldMap['Status: '] = s_status.text;
          // fieldMap['Mobile No.: '] = s_mobile.text;
          // fieldMap['Email Id: '] = s_email.text;
          // fieldMap['MC Member: '] = s_mc.text;
          // fieldMap['Remarks: '] = s_remarks.text;
          // fieldMap['Parking No: '] = s_parking.text;
          // fieldMap['Tenant Name And Address: '] = s_tenant.text;
          // fielddata.add(alldata);
          // fielddata.add(fieldMap);
          // // for (int i = 0; i < mapExcelData.length; i++) {
          // alldata.length != 0
          FirebaseFirestore.instance
              .collection('members')
              .doc(_societyNameController.text)
              .set({
            'data': alldata,
          }).then((value) {
            const ScaffoldMessenger(
                child: SnackBar(
              content: Text('Successfully Uploaded'),
            ));
          });
        },
        child: const Icon(Icons.check),
      ));

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

    if (files?.length == 1) {
      final file = files?[0];
      final reader = FileReader();

      reader.readAsArrayBuffer(file!);

      await reader.onLoadEnd.first;

      final excel = Excel.decodeBytes(reader.result as List<int>);

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];

        for (var rows in sheet!.rows.skip(0)) {
          Map<String, dynamic> tempMap = {};
          if (columnName.isEmpty) {
            for (var cells in sheet.rows[0]) {
              columnName.add(cells!.value.toString());
            }
          }

          List<dynamic> rowData = [];
          for (var cell in rows) {
            rowData.add(cell?.value.toString() ?? '');
          }

          data.add(rowData);

          for (int i = 0; i < columnName.length; i++) {
            tempMap[columnName[i]] = rowData[i];
          }
          // mapExcelData.add(tempMap);
          alldata.add(tempMap);
          tempMap = {};
        }
        //   mapExcelData.removeAt(0);
        // print(alldata);
      }

      data.removeAt(0);
      showTable = true;
      setState(() {});
    }
    return data;
  }

  // ignore: non_constant_identifier_names
  OverviewField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            width: 250,
            child: CustomTextField(
              readonly: false,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> downloadCsv() async {
    final storage = FirebaseStorage.instance;
    final Reference ref = storage.ref('template');
    ListResult allFiles = await ref.listAll();
    url = await allFiles.items[0].getDownloadURL();
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
