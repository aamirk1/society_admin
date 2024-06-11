import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Note/ViewNote/DebitNoteView.dart';
// ignore: must_be_immutable
class ReceiptDebitNote extends StatefulWidget {
  ReceiptDebitNote(
      {super.key,
      required this.societyName,
      required this.name,
      required this.monthyear});
  final String societyName;
  final String name;
  final String monthyear;
  String Currentmonthyears = DateFormat('MMMM yyyy').format(DateTime.now());

  @override
  State<ReceiptDebitNote> createState() => _ReceiptDebitNoteState();
}

class _ReceiptDebitNoteState extends State<ReceiptDebitNote> {
  bool isLoading = true;

  List<dynamic> noteNumberList = [];
  @override
  void initState() {
    fetchMap(
            widget.societyName,
            widget.monthyear.isEmpty
                ? widget.Currentmonthyears
                : widget.monthyear,
            widget.name)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: const Text("Receipt "),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: noteNumberList.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ListTile(
                              title: Text(
                                'Debit Note No.: ${noteNumberList[index]}',
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewDebitNote(
                                      societyName: widget.societyName,
                                      name: widget.name,
                                      monthyear: widget.monthyear.isEmpty
                                          ? widget.Currentmonthyears
                                          : widget.monthyear,
                                      noteNumber: noteNumberList[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ]);
                      }),
                ),
              )
            ]),
    );
  }

  Future<void> fetchMap(
      String societyName, String monthyear, String name) async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .collection('memberName')
        .doc(name)
        .collection('noteNumber')
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      List<dynamic> data1 = docSnapshot.docs.map((e) => e.id).toList();
      noteNumberList = data1;
      // Use the data map as needed
    }
    setState(() {
      isLoading = false;
    });
  }
}
