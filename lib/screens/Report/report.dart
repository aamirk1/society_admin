import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});
  String society;
  List<dynamic> allRoles = [];
  String userId;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  initState() {
    super.initState();
    getTableData(widget.society).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  // List<dynamic> listOfFlatNo = [];
  // List<dynamic> listOfDate = [];
  // List<dynamic> listOfComplaintType = [];
  List<dynamic> allData = [];
  List<String> columnName = [
    'Sr. No.',
    'Date',
    'Unit No.',
    'Category',
    'particulars',
    'Status'
  ];
  bool isLoading = true;
  DateTime startDate = DateTime.now();
  DateTime currentDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Daily Report'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder<List<List<dynamic>>>(
                            builder: (context, snapshot) {
                          return DataTable2(
                            minWidth: 4500,
                            border: TableBorder.all(color: Colors.black),
                            headingRowColor:
                                const MaterialStatePropertyAll(primaryColor),
                            headingTextStyle: const TextStyle(
                                color: Colors.white, fontSize: 50.0),
                            columnSpacing: 3.0,
                            columns: List.generate(columnName.length, (index) {
                              return DataColumn2(
                                fixedWidth: index == 4 ? 500 : 110,
                                label: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    columnName[index],
                                    style: const TextStyle(
                                        // overflow: TextOverflow.ellipsis,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }),
                            rows: List.generate(
                              growable: true,
                              allData.length, //change column name to row data
                              (index1) => DataRow2(
                                cells:
                                    List.generate(growable: true, 6, (index2) {
                                  //change column name to row data
                                  return
                                      //  allData[index1][index2] !=
                                      //         'Status'
                                      //     ?
                                      DataCell(Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Text(
                                      allData[index1][index2].toString(),
                                      style: const TextStyle(color: textColor),
                                    ),
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
      ),
    );
  }

  Future<void> getTableData(String selectedSociety) async {
    int counter = 0;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection('complaints')
        .doc(selectedSociety)
        .collection('flatno');

    //Fetching flat no list
    QuerySnapshot flatNoQuery = await collectionReference.get();
    List<dynamic> flatNoList = flatNoQuery.docs.map((e) => e.id).toList();

    // fetching Type of Complaints
    for (int i = 0; i < flatNoList.length; i++) {
      QuerySnapshot complaintTypequery = await collectionReference
          .doc(flatNoList[i])
          .collection('typeofcomplaints')
          .get();
      List<dynamic> complaintTypeList =
          complaintTypequery.docs.map((e) => e.id).toList();

      // fetching Date of Complaint
      for (int j = 0; j < complaintTypeList.length; j++) {
        QuerySnapshot complaintDateQuery = await collectionReference
            .doc(flatNoList[i])
            .collection('typeofcomplaints')
            .doc(complaintTypeList[j])
            .collection('dateOfComplaint')
            .get();
        List<dynamic> dateList =
            complaintDateQuery.docs.map((e) => e.id).toList();

        List<dynamic> dateDataList =
            complaintDateQuery.docs.map((e) => e.data()).toList();
        // FETCHING COMPLAINT DATA

        for (int k = 0; k < dateList.length; k++) {
          counter = counter + 1;
          allData.add([
            counter,
            dateList[k],
            flatNoList[i],
            'Complaint',
            complaintTypeList[j],
            dateDataList[k]['response'].toString().isNotEmpty
                ? "Closed"
                : "Open",
          ]);
        }
      }
    }
    print('allData--- $allData');
  }

  // funtion for noc management
  Future<void> getTableDataForNoc(String selectedSociety) async {
    int counter = 0;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection('nocApplications')
        .doc(selectedSociety)
        .collection('flatno');

    //Fetching flat no list
    QuerySnapshot flatNoQuery = await collectionReference.get();
    List<dynamic> flatNoList = flatNoQuery.docs.map((e) => e.id).toList();

    // fetching Type of nocs
    for (int i = 0; i < flatNoList.length; i++) {
      QuerySnapshot nocTypequery = await collectionReference
          .doc(flatNoList[i])
          .collection('typeofNoc')
          .get();
      List<dynamic> nocTypeList = nocTypequery.docs.map((e) => e.id).toList();

      // fetching Date of noc
      for (int j = 0; j < nocTypeList.length; j++) {
        QuerySnapshot nocDateQuery = await collectionReference
            .doc(flatNoList[i])
            .collection('typeofNoc')
            .doc(nocTypeList[j])
            .collection('dateOfNoc')
            .get();
        List<dynamic> dateList = nocDateQuery.docs.map((e) => e.id).toList();

        List<dynamic> dateDataList =
            nocDateQuery.docs.map((e) => e.data()).toList();
        // FETCHING noc DATA

        for (int k = 0; k < dateList.length; k++) {
          counter = counter + 1;
          allData.add([
            counter,
            dateList[k],
            flatNoList[i],
            'NOC',
            nocTypeList[j],
            dateDataList[k]['response'].toString().isNotEmpty
                ? "Closed"
                : "Open",
          ]);
        }
      }
    }
    print('allData--- $allData');
  }
}
