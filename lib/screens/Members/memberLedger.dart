import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/ChangeValueProvider.dart';
import 'package:society_admin/authScreen/common.dart';

class MemberLedger extends StatefulWidget {
  final String society;
  final String landmark;
  final String city;
  final String stateName;
  final String pincode;
  final List<List<dynamic>> data;
  final int index1;

  const MemberLedger({
    super.key,
    required this.society,
    required this.landmark,
    required this.city,
    required this.stateName,
    required this.pincode,
    required this.data,
    required this.index1,
  });

  @override
  State<MemberLedger> createState() => _MemberLedgerState();
}

class _MemberLedgerState extends State<MemberLedger> {
  List<int> listOfIndex = [];
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController electricController = TextEditingController();
  final TextEditingController billnoController = TextEditingController();
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());

  String electric = '';
  String totalAmount = '';
  String billno = '';
  String water = '';
  bool isLoading = false;

  // ignore: non_constant_identifier_names

  String currentmonth = DateFormat('MMMM yyyy').format(DateTime.now());

  //List of Data with Bill Number
  Map<String, dynamic> allBillData = {};
  Map<String, dynamic> allBillDetails = {};
  List<dynamic> allDataWithBill = [];
  List<dynamic> allDataWithReceipt = [];
  List<dynamic> monthList = [];
  List<List<dynamic>> rowList = [];
  List<String> particulartsLableList = [];
  List<dynamic> colums = [
    'Date',
    'Reference',
    'Bills\nDebits',
    'Credits\nReceipts',
    'Balance',
  ];
  String flatno = '';
  String date = '';
  String date2 = '';
  String particulars = '';
  String debitnoteNumber = '0';
  String creditnoteNumber = '0';
  String amount = '';
  String totalBillAmount = '0';
  String totalCretitAmount = '0';
  String totalDebititAmount = '0';
  String totalReceiptAmount = '0';
  String month = '';
  List<List<dynamic>> billNoList = [];
  List<List<dynamic>> creditList = [];
  List<List<dynamic>> debitList = [];
  List<List<dynamic>> receiptList = [];

  String phoneNum = '';
  @override
  initState() {
    fetchData().whenComplete(() => setState(() {
          isLoading = false;
        }));

    super.initState();
  }

  Future<void> fetchData() async {
    await getBill(widget.society, widget.data[widget.index1][0].toString());
    await getReceipt(widget.society, widget.data[widget.index1][0].toString());
    await debitNoteData();
    await creditNoteData();
    await mergeAllList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          width: MediaQuery.of(context).size.width * 0.90,
          child: Column(
            children: [
              Center(
                child: Text(
                  widget.society,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.society,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${widget.society}, ${widget.landmark}, ${widget.city}, ${widget.stateName}, ${widget.pincode}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Flat No.: ${widget.data[widget.index1][0].toString()} ${widget.data[widget.index1][1].toString()}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  // Add tables here

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.88,
                          height: MediaQuery.of(context).size.height * 0.66,
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: DataTable(
                                      headingRowColor:
                                          const WidgetStatePropertyAll(
                                              primaryColor),
                                      // dataRowMinHeight: 10,
                                      columnSpacing: 5,
                                      columns: List.generate(5, (index) {
                                        return DataColumn(
                                          label: Text(
                                            colums[index],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }),
                                      rows: List.generate(
                                        rowList.length,
                                        (index1) {
                                          return DataRow(
                                            cells: List.generate(
                                              colums.length,
                                              (index2) {
                                                return DataCell(
                                                  index2 == 1
                                                      ? particulartsLableList[
                                                                  index1] ==
                                                              '5_Bill No'
                                                          ? Text(
                                                              '${particulartsLableList[index1].split('5_').join('')}\n ${rowList[index1][index2]}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      // backgroundColor:
                                                                      //     Colors.amber,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : particulartsLableList[
                                                                      index1] ==
                                                                  '2_Receipt No.'
                                                              ? Text(
                                                                  '${particulartsLableList[index1].split('2_').join('')}\n ${rowList[index1][index2]}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              : particulartsLableList[
                                                                          index1] ==
                                                                      'Debit Note'
                                                                  ? Text(
                                                                      '${particulartsLableList[index1]}\n${rowList[index1][index2]}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )
                                                                  : Text(
                                                                      '${particulartsLableList[index1]}\n ${rowList[index1][index2]}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )
                                                      : Text(
                                                          rowList[index1]
                                                                  [index2] ??
                                                              '0',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Column(
                                        children: [
                                          Text(
                                            'Total Amount: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.42,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(totalDebititAmount,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Text(totalCretitAmount,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Text(totalBillAmount,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getBill(String societyname, String flatno) async {
    billNoList.clear();
    isLoading = true;

    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('ladgerBill')
        .doc(societyname)
        .collection('month')
        .get();
    List<dynamic> monthList =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('ladgerBill')
          .doc(societyname)
          .collection('month')
          .doc(monthList[i])
          .get();
      if (data.exists) {
        Map<String, dynamic> totalusers = data.data() as Map<String, dynamic>;
        List<dynamic> mapData = totalusers['data'];

        for (var data in mapData) {
          List<dynamic> row = [];

          if (flatno == data['3_Flat No.']) {
            allDataWithBill.add(data);

            String billAmount = data['6_Bill Amount'].split('.')[0];
            print('billAmountssss $billAmount');
            // String payableAmount = data['9_Payable'].split(' ')[0];
            String payableAmount = 0.toString();
            totalBillAmount = (double.parse(billAmount) -
                    double.parse(payableAmount) +
                    double.parse(totalBillAmount))
                .toString()
                .split('.')[0];
            totalDebititAmount =
                (double.parse(totalDebititAmount) + double.parse(billAmount))
                    .toString();

            row.add(data['1_Bill Date'] ?? 'N/A');
            row.add(data['5_Bill No'] ?? '0');
            row.add(billAmount);
            row.add(payableAmount);
            row.add(totalBillAmount);
            row.add(data['2_Due Date'] ?? 'N/A');
            row.add(data['7_Interest'] ?? 'N/A');
            row.add(data['8_Arrears'] ?? 'N/A');
            row.add(data['9_Payable'] ?? 'N/A');
            row.add(data['Mhada Lease Rent'] ?? 'N/A');
            row.add(data['Municipal Tax'] ?? 'N/A');
            row.add(data['Non Occupancy Charges'] ?? 'N/A');
            row.add(data['Other Charges'] ?? 'N/A');
            row.add(data['Parking Charges'] ?? 'N/A');
            row.add(data['Repair Fund'] ?? 'N/A');
            row.add(data['Sinking Fund'] ?? 'N/A');
            row.add(data['TOWER BENEFIT'] ?? 'N/A');

            billNoList.add(row);

            allBillData = data;
          }
        }
      }
    }
    alldata(allBillData);
  }

  Future<void> alldata(Map<String, dynamic> map) async {
    var filteredMap = {};
    map.forEach((key, value) {
      if (![
        '9_Payable',
        '6_Bill Amount',
        '3_Flat No.',
        '4_Member Name',
        '1_Bill Date',
        '5_Bill No',
        '2_Due Date'
      ].contains(key)) {
        filteredMap[key] = value;
      }
    });
    allBillDetails = Map<String, dynamic>.from(filteredMap);
  }

  Future<void> getReceipt(String societyname, String flatno) async {
    receiptList.clear();
    isLoading = true;
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(societyname)
        .collection('month')
        .get();
    List<dynamic> monthList =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('ladgerReceipt')
          .doc(societyname)
          .collection('month')
          .doc(monthList[i])
          .get();
      if (data.exists) {
        Map<String, dynamic> totalusers = data.data() as Map<String, dynamic>;
        List<dynamic> mapData = totalusers['data'];

        for (var data in mapData) {
          List<dynamic> receipt = [];

          if (flatno == data['1_Flat No.']) {
            allDataWithReceipt.add(data);

            String receiptAmount = data['5_Amount'].split('.')[0];
            // String payableAmount = data['8_Payable'].split(' ')[0];
            String payableAmount = 0.toString();
            totalBillAmount = (double.parse(totalBillAmount) +
                    double.parse(payableAmount) -
                    double.parse(receiptAmount))
                .toString()
                .split('.')[0];
            totalCretitAmount =
                (double.parse(totalCretitAmount) + double.parse(receiptAmount))
                    .toString();

            receipt.add(data['3_Receipt Date'] ?? 'N/A');
            receipt.add(data['1_Flat No.'] ?? 'N/A');
            receipt.add(payableAmount);
            receipt.add(receiptAmount);
            receipt.add(totalBillAmount);
            receipt.add(data['Bank Name'] ?? 'N/A');
            receipt.add(data['7_ChqDate'] ?? 'N/A');
            receipt.add(data['2_Receipt No'] ?? '0');
            receipt.add(data['6_ChqNo'] ?? 'N/A');
            receiptList.add(receipt);
          }
        }
      }
    }
    if (billNoList.length > receiptList.length) {
      int loopLen = billNoList.length - receiptList.length;
      for (var i = 0; i < loopLen; i++) {
        receiptList.add(['N/A', '0', '0', '0', '0']);
      }
    }
  }

  Future<void> debitNoteData() async {
    debitList.clear();
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.society)
        .collection('month')
        .get();
    monthList = societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('debitNote')
          .doc(widget.society)
          .collection('month')
          .doc(monthList[i])
          .collection('memberName')
          .doc(widget.data[widget.index1][1].toString())
          .collection('noteNumber')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> singleRow = [];
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        flatno = data['Flat No.'];
        amount = data['amount'];
        date = data['date'];
        particulars = data['particular'];
        debitnoteNumber = data['noteNumber'];
        monthyear = data['month'];
        date2 = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

        String debitAmount = data['amount'].split('.')[0];
        String payableAmount = 0.toString();
        totalBillAmount = (double.parse(totalBillAmount) +
                double.parse(debitAmount) -
                double.parse(payableAmount))
            .toString()
            .split('.')[0];

        totalDebititAmount =
            (double.parse(totalDebititAmount) + double.parse(debitAmount))
                .toString();

        singleRow.add(date2);
        singleRow.add(particulars);
        singleRow.add(debitAmount);
        singleRow.add(payableAmount);
        singleRow.add(totalBillAmount);
        singleRow.add(monthyear);
        singleRow.add(debitnoteNumber);
        debitList.add(singleRow);
      }
    }
  }

  Future<void> creditNoteData() async {
    final provider = Provider.of<ChangeValue>(context, listen: false);
    creditList.clear();
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('creditNote')
        .doc(widget.society)
        .collection('month')
        .get();
    monthList = societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('creditNote')
          .doc(widget.society)
          .collection('month')
          .doc(monthList[i])
          .collection('memberName')
          .doc(widget.data[widget.index1][0].toString())
          .collection('noteNumber')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> singleRow = [];
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        flatno = data['Flat No.'];
        amount = data['amount'];
        date = data['date'];
        particulars = data['particular'];
        creditnoteNumber = data['noteNumber'];
        monthyear = data['month'];
        date2 = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

        String creditAmount = data['amount'].split('.')[0];
        String payableAmount = 0.toString();
        totalBillAmount = (double.parse(totalBillAmount) +
                double.parse(payableAmount) -
                double.parse(creditAmount))
            .toString()
            .split('.')[0];

        provider.setGrandTotalBillAmount(totalBillAmount);

        totalCretitAmount =
            (double.parse(totalCretitAmount) + double.parse(creditAmount))
                .toString();

        singleRow.add(date2);
        singleRow.add(particulars);
        singleRow.add(payableAmount);
        singleRow.add(creditAmount);
        singleRow.add(totalBillAmount);
        singleRow.add(monthyear);
        singleRow.add(creditnoteNumber);
        creditList.add(singleRow);
      }
    }
    if (debitList.length > creditList.length) {
      int loopLen = debitList.length - creditList.length;
      for (var i = 0; i < loopLen; i++) {
        creditList.add(['N/A', 'N/A', 'N/A', 'N/A', 'N/A']);
      }
    }
  }

  Future<void> mergeAllList() async {
    List<List<dynamic>> listOfRows = [];
    for (int i = 0; i < billNoList.length; i++) {
      listOfRows.add(billNoList[i]);
      particulartsLableList.add('5_Bill No');
      listOfRows.add(receiptList[i]);
      particulartsLableList.add('2_Receipt No.');
      if (creditList.length >= i + 1) {
        listOfRows.add(debitList[i]);
        particulartsLableList.add('Debit Note');
        listOfRows.add(creditList[i]);
        particulartsLableList.add('Credit Note');
      }
    }

    rowList = listOfRows;
  }
}
