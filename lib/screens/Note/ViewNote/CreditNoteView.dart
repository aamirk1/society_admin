import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ViewCreditNote extends StatefulWidget {
  ViewCreditNote(
      {super.key,
      required this.societyName,
      required this.name,
      required this.monthyear,
      required this.noteNumber});
  String societyName;
  String name;
  String monthyear;
  String noteNumber;
  @override
  State<ViewCreditNote> createState() => _ViewCreditNoteState();
}

class _ViewCreditNoteState extends State<ViewCreditNote> {
  bool isLoading = true;
  // List<dynamic> a = widget.name.toString().split('');

  late String email;
  late String regNo;
  late String landmark;
  late String city;
  late String state;
  late String pincode;

  String flatNo = '';
  String amount = '';
  String date = '';
  String date2 = '';
  String particular = '';

  @override
  void initState() {
    super.initState();
    getSocietyDetails().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    particularsData(widget.societyName, widget.monthyear, widget.name,
            widget.noteNumber)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                height: MediaQuery.of(context).size.height * 0.98,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.societyName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Registration No.: $regNo',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  '$landmark $city $state $pincode',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'CREDIT NOTE',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Unit No.: $flatNo',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      Text(
                                        'Date: $date2',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Name : ${widget.name}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 18.0),
                                            child: Text(
                                              'Particular ',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            'Amount',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0),
                                            child: Text(particular,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            amount,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> getSocietyDetails() async {
    DocumentSnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('society')
        .doc(widget.societyName)
        .get();
    Map<String, dynamic> societyData =
        societyQuerySnapshot.data() as Map<String, dynamic>;

    email = societyData['email'];
    regNo = societyData['regNo'];
    landmark = societyData['landmark'];
    city = societyData['city'];
    state = societyData['state'];
    pincode = societyData['pincode'];
  }

  Future<void> particularsData(String societyName, String monthyear,
      String name, String noteNumber) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('creditNote')
        .doc(societyName)
        .collection('month')
        .doc(monthyear)
        .collection('memberName')
        .doc(name)
        .collection('noteNumber')
        .doc(noteNumber)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      flatNo = data['Flat No.'];
      amount = data['amount'];
      date = data['date'];
      particular = data['particular'];
      date2 = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

      setState(() {
        isLoading = false;
      });
    }
  }
}
