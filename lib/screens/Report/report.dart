import 'dart:convert';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
  int counter = 0;

  @override
  initState() {
    super.initState();
    getTableDataForGatePass(widget.society, rangeStartDate, rangeEndDate!)
        .whenComplete(() async {
      await getTableDataForNoc(widget.society, rangeStartDate, rangeEndDate!);
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

  DateTime rangeStartDate = DateTime.now();
  DateTime? rangeEndDate = DateTime.now();
  // final currentDate = DateFormat('dd-MM-yyyy ').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
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
                            '${rangeStartDate.day}/${rangeStartDate.month}/${rangeStartDate.year}',
                          ),
                          onPressed: () {
                            counter = 0;
                            pickDateRange().whenComplete(() async {
                              await getTableDataForGatePass(widget.society,
                                  rangeStartDate, rangeEndDate!);
                              await getTableDataForNoc(widget.society,
                                  rangeStartDate, rangeEndDate!);
                              await getTableDataForComplaint(widget.society,
                                  rangeStartDate, rangeEndDate!);
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: Text(
                              '${rangeEndDate!.day}/${rangeEndDate!.month}/${rangeEndDate!.year}'),
                          onPressed: () {
                            pickDateRange();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
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
          _generatePDF();
        },
        child: const Icon(Icons.print, color: Colors.white),
      ),
    );
  }

  Future<void> _generatePDF() async {
    setState(() {
      isLoading = true;
    });

    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 = await rootBundle.load('fonts/IBMPlexSans-Medium.ttf');
    final fontData2 = await rootBundle.load('fonts/IBMPlexSans-Bold.ttf');

    const cellStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 14,
    );

    List<pw.TableRow> rows = [];

    rows.add(pw.TableRow(children: [
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Sr No',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding:
              const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: pw.Center(
              child: pw.Text('Date',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Unit No',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Category',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('particulars',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Status',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      // pw.Container(
      //     padding: const pw.EdgeInsets.all(2.0),
      //     child: pw.Center(
      //         child: pw.Text('Image1',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      //   pw.Container(
      //       padding: const pw.EdgeInsets.all(2.0),
      //       child: pw.Center(
      //           child: pw.Text('Image2',
      //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
    ]));

    if (allData.isNotEmpty) {
      // for (int i = 0; i < chosenDateList.length; i++){
      // for (int j = 0; j < availableUserId.length; j++){
      // final currentUserId = availableUserId[j];
      for (int i = 0; i < allData.length; i++) {
        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text('${i + 1}',
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(allData[i][1].toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(allData[i][2].toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(allData[i][3].toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(allData[i][4].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(allData[i][5].toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
        ]));
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1600, 1000,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Report Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                    ]),
              ]));
        },
        // footer: (pw.Context context) {
        //   return pw.Container(
        //       alignment: pw.Alignment.centerRight,
        //       margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        //       child: pw.Text('User ID - $user_id',
        //           // 'Page ${context.pageNumber} of ${context.pagesCount}',
        //           style: pw.Theme.of(context)
        //               .defaultTextStyle
        //               .copyWith(color: PdfColors.black)));
        // },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: []),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(160),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(70),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(70),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    final List<int> pdfData = await pdf.save();
    const String pdfPath = 'Report.pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      html.AnchorElement(
          href: "data:application/octet-stream;base64,${base64Encode(pdfData)}")
        ..setAttribute("download", pdfPath)
        ..click();
    }

    setState(() {
      isLoading = false;
    });
  }

// fetchEnergyData(String cityName, String depoName, String userId,
//       DateTime date, DateTime endDate) async {
//     final List<dynamic> timeIntervalList = [];
//     final List<dynamic> energyConsumedList = [];
//     int currentMonth = DateTime.now().month;
//     String monthName = DateFormat('MMMM').format(DateTime.now());
//     final List<EnergyManagementModel> fetchedData = [];
//     _energydata.clear();
//     timeIntervalList.clear();
//     energyConsumedList.clear();
//     for (DateTime initialdate = endDate;
//         initialdate.isAfter(date.subtract(const Duration(days: 1)));
//         initialdate = initialdate.subtract(const Duration(days: 1))) {
//       // print(date.add(const Duration(days: 1)));
//       // print(DateFormat.yMMMMd().format(initialdate));

//       FirebaseFirestore.instance
//           .collection('EnergyManagementTable')
//           .doc(cityName)
//           .collection('Depots')
//           .doc(depoName)
//           .collection('Year')
//           .doc(DateTime.now().year.toString())
//           .collection('Months')
//           .doc(monthName)
//           .collection('Date')
//           .doc(DateFormat.yMMMMd().format(initialdate))
//           .collection('UserId')
//           .doc(userId)
//           .get()
//           .then((value) {
//         if (value.data() != null) {
//           for (int i = 0; i < value.data()!['data'].length; i++) {
//             var data = value.data()!['data'][i];
//             fetchedData.add(EnergyManagementModel.fromJson(data));
//             timeIntervalList.add(value.data()!['data'][i]['timeInterval']);
//             energyConsumedList.add(value.data()!['data'][i]['energyConsumed']);
//           }
//           _energydata = fetchedData;
//           intervalListData = timeIntervalList;
//           energyListData = energyConsumedList;
//           notifyListeners();
//         } else {
//           intervalListData = timeIntervalList;
//           energyListData = energyConsumedList;

//           notifyListeners();
//         }
//       });
//     }
//   }

  Future<void> getTableDataForComplaint(
      String selectedSociety, DateTime startDate, DateTime endDate) async {
    // int counter = 0;
    CollectionReference collectionReference = FirebaseFirestore.instance
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
      DateTime enddate = rangeEndDate!;
      DateTime startdate = rangeStartDate;
      //DateTime.parse(rangeEndDate!);
      for (DateTime initialdate = enddate;
          initialdate.isAfter(startdate.subtract(const Duration(days: 1)));
          initialdate = initialdate.subtract(const Duration(days: 1))) {
        String date2 = DateFormat('dd-MM-yyyy').format(initialdate);

        for (int j = 0; j < complaintTypeList.length; j++) {
          DocumentSnapshot complaintDateQuery = await collectionReference
              .doc(flatNoList[i])
              .collection('typeofcomplaints')
              .doc(complaintTypeList[j])
              .collection('dateOfComplaint')
              .doc(date2)
              .get();

          if (complaintDateQuery.exists) {
            Map<String, dynamic> mapData =
                complaintDateQuery.data() as Map<String, dynamic>;
            counter = counter + 1;
            allData.add([
              counter,
              date2,
              flatNoList[i],
              'Complaint',
              complaintTypeList[j],
              mapData['response'].toString().isNotEmpty ? "Closed" : "Open",
            ]);
          }
        }
      }
    }
    print('allData--- $allData');
  }

  // funtion for noc management
  Future<void> getTableDataForNoc(
      String selectedSociety, DateTime startDate, DateTime endDate) async {
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
        for (DateTime initialdate = endDate;
            initialdate.isAfter(startDate.subtract(const Duration(days: 1)));
            initialdate = initialdate.subtract(const Duration(days: 1))) {
          String date2 = DateFormat('dd-MM-yyyy').format(initialdate);

          DocumentSnapshot documentSnapshot = await collectionReference
              .doc(flatNoList[i])
              .collection('typeofNoc')
              .doc(nocTypeList[j])
              .collection('dateOfNoc')
              .doc(date2)
              .get();

          if (documentSnapshot.exists) {
            Map<String, dynamic> mapData =
                documentSnapshot.data() as Map<String, dynamic>;
            counter = counter + 1;
            allData.add([
              counter,
              date2,
              flatNoList[i],
              'NOC',
              nocTypeList[j],
              mapData['isApproved'].toString().isNotEmpty ? "Closed" : "Open",
            ]);
            print("Data Added - $allData");
          }
        }
      }
      print('allData--- $allData');
    }
  }

  Future<void> getTableDataForGatePass(
      String selectedSociety, DateTime startDate, DateTime endDate) async {
    allData.clear();
    // int counter = 0;
    CollectionReference collectionReference = FirebaseFirestore.instance
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
        for (DateTime initialdate = endDate;
            initialdate.isAfter(startDate.subtract(const Duration(days: 1)));
            initialdate = initialdate.subtract(const Duration(days: 1))) {
          String date2 = DateFormat('dd-MM-yyyy').format(initialdate);

          DocumentSnapshot complaintDateQuery = await collectionReference
              .doc(flatNoList[i])
              .collection('gatePassType')
              .doc(complaintTypeList[j])
              .collection('dateOfGatePass')
              .doc(date2)
              .get();

          if (complaintDateQuery.exists) {
            Map<String, dynamic> mapData =
                complaintDateQuery.data() as Map<String, dynamic>;
            counter = counter + 1;
            allData.add([
              counter,
              date2,
              flatNoList[i],
              'GatePass',
              complaintTypeList[j],
              mapData['isApproved'].toString().isNotEmpty ? "Closed" : "Open",
            ]);
            print("Data Added - $allData");
          }
        }

        // FETCHING COMPLAINT DATA
      }
    }
  }

  Future<void> pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      rangeStartDate = dateRange.start;
      rangeEndDate = dateRange.end;
    });
  }
}
