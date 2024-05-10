import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';

int counter = 0;

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

    getTableDataForGatePass(
            widget.society, rangeStartDate ?? currentDate, rangeEndDate ?? '')
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    getTableDataForComplaint(
            widget.society, rangeStartDate ?? currentDate, rangeEndDate ?? '')
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    getTableDataForNoc(
            widget.society, rangeStartDate ?? currentDate, rangeEndDate ?? '')
        .whenComplete(() {
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

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2020, 01, 01),
    end: DateTime(2025, 01, 01),
  );

  String? rangeStartDate;
  String? rangeEndDate;
  final currentDate = DateFormat('dd-MM-yyyy ').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Daily Report'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: buttonColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            '${start.day}/${start.month}/${start.year}',
                          ),
                          onPressed: () {
                            pickDateRange();
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: Text('${end.day}/${end.month}/${end.year}'),
                          onPressed: () {
                            pickDateRange();

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () async {
                  //             final DateTime? picked = await showDatePicker(
                  //               context: context,
                  //               initialDate: startDate as DateTime,
                  //               firstDate: DateTime(2000),
                  //               lastDate: DateTime(2101),
                  //             );
                  //             if (picked != null) {
                  //               setState(() {
                  //                 startDate = picked as String;
                  //               });
                  //             }
                  //           },
                  //           child: Text(
                  //             startDate.isNull
                  //                 ? 'Select start date'
                  //                 : startDate.toString(),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(width: 10),
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () async {
                  //             final DateTime? picked = await showDatePicker(
                  //               context: context,
                  //               initialDate: endDate as DateTime,
                  //               firstDate: DateTime(2000),
                  //               lastDate: DateTime(2101),
                  //             );
                  //             if (picked != null) {
                  //               setState(() {
                  //                 endDate = picked as String;
                  //               });
                  //             }
                  //           },
                  //           child: Text(
                  //             endDate.isNull
                  //                 ? 'Select end date'
                  //                 : endDate.toString(),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      height: MediaQuery.of(context).size.height * 0.60,
                      width: MediaQuery.of(context).size.width * 0.99,
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
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                          rows: List.generate(
                            growable: true,
                            allData.length, //change column name to row data
                            (index1) => DataRow2(
                              cells: List.generate(growable: true, 6, (index2) {
                                //change column name to row data
                                return
                                    //  allData[index1][index2] !=
                                    //         'Status'
                                    //     ?
                                    DataCell(Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      allData[index1][index2].toString(),
                                      style: const TextStyle(color: textColor),
                                    ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          print('hello world');
        },
        child: const Icon(Icons.print, color: Colors.white),
      ),
    );
  }

  Future<void> getTableDataForComplaint(
      String selectedSociety, String startDate, String endDate) async {
    // int counter = 0;
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
  Future<void> getTableDataForNoc(
      String selectedSociety, String startDate, String endDate) async {
    // int counter = 0;
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

  Future<void> getTableDataForGatePass(
      String selectedSociety, String startDate, String endDate) async {
    // int counter = 0;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection('gatePassApplications')
        .doc(selectedSociety)
        .collection('flatno');

    //Fetching flat no list
    QuerySnapshot flatNoQuery = await collectionReference.get();
    List<dynamic> flatNoList = flatNoQuery.docs.map((e) => e.id).toList();

    // fetching Type of Complaints
    for (int i = 0; i < flatNoList.length; i++) {
      QuerySnapshot complaintTypequery = await collectionReference
          .doc(flatNoList[i])
          .collection('gatePassType')
          .get();
      List<dynamic> complaintTypeList =
          complaintTypequery.docs.map((e) => e.id).toList();

      // fetching Date of Complaint
      for (int j = 0; j < complaintTypeList.length; j++) {
        QuerySnapshot complaintDateQuery = await collectionReference
            .doc(flatNoList[i])
            .collection('gatePassType')
            .doc(complaintTypeList[j])
            .collection('dateOfGatePass')
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
            'GatePass',
            complaintTypeList[j],
            dateDataList[k]['isApproved'].toString().isNotEmpty
                ? "Closed"
                : "Open",
          ]);
        }
      }
    }
  }

  Future<void> pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (newDateRange == null) return;
    print('newDateRange2 $newDateRange');
    setState(() {
      dateRange = newDateRange;
      rangeStartDate =
          '${dateRange.start.day}-${dateRange.start.month}-${dateRange.start.year}';
      rangeEndDate =
          '${dateRange.end.day}-${dateRange.end.month}-${dateRange.end.year}';
      print('rangeStartDate $rangeStartDate');
      print('rangeEndDate $rangeEndDate');
    });
  }
}
