// import 'dart:html';
// ignore_for_file: use_build_context_synchronously, avoid_print, file_names, void_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddGatePass extends StatefulWidget {
  AddGatePass(
      {super.key,
      required this.gatePassType,
      required this.text,
      required this.society,
      required this.flatNo});
  String gatePassType;
  String text;
  String society;
  String flatNo;

  @override
  @override
  State<AddGatePass> createState() => _AddGatePassState();
}

class _AddGatePassState extends State<AddGatePass> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  PlatformFile? selectedFile;
  String url = '';
  bool isAlreadyApproved = false;
  bool isAlreadyRejected = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getpassforApproved();
    getpassforRejected();
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
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.gatePassType,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black),
                                ),
                                Text(
                                  widget.text,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: isAlreadyRejected
                                  ? null
                                  : () {
                                      approvedAlertbox();
                                    },
                              child: isAlreadyApproved
                                  ? const Text('Approved')
                                  : const Text('Approve'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: isAlreadyApproved
                                  ? null
                                  : () {
                                      rejectedAlertbox();
                                    },
                              child: isAlreadyRejected
                                  ? const Text('Rejected')
                                  : const Text('Reject'),
                            )
                          ]),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> getpassforApproved() async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('gatePassApplications')
        .doc(widget.society)
        .collection('flatno')
        .doc(widget.flatNo)
        .collection('gatePassType')
        .doc(widget.gatePassType)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      isAlreadyApproved = mapData['isApproved'] ?? false;
    }
  }

  Future<void> storeApprovedGatePass() async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('gatePassApplications')
        .doc(widget.society)
        .collection('flatno')
        .doc(widget.flatNo)
        .collection('gatePassType')
        .doc(widget.gatePassType)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      isAlreadyApproved = mapData['isApproved'] ?? false;

      if (isAlreadyApproved == false) {
        await firestore
            .collection('gatePassApplications')
            .doc(widget.society)
            .collection('flatno')
            .doc(widget.flatNo)
            .collection('gatePassType')
            .doc(widget.gatePassType)
            .update({"isApproved": true});
        await firestore
            .collection('gatePassApplications')
            .doc(widget.society)
            .collection('flatno')
            .doc(widget.flatNo)
            .set({"flatno": widget.flatNo});
      } else {
        print('Already Approved');
      }
    }
  }

  // Rejected code start here

  Future<void> getpassforRejected() async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('gatePassApplications')
        .doc(widget.society)
        .collection('flatno')
        .doc(widget.flatNo)
        .collection('gatePassType')
        .doc(widget.gatePassType)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      isAlreadyRejected = mapData['isRejected'] ?? false;

      print('test isAlreadyRejected $isAlreadyRejected');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> storeRejectedGatePass() async {
    if (isAlreadyRejected == false) {
      await firestore
          .collection('gatePassApplications')
          .doc(widget.society)
          .collection('flatno')
          .doc(widget.flatNo)
          .collection('gatePassType')
          .doc(widget.gatePassType)
          .update({"isRejected": true});
      await firestore
          .collection('gatePassApplications')
          .doc(widget.society)
          .collection('flatno')
          .doc(widget.flatNo)
          .set(
        {"flatno": widget.flatNo},
      );
    }
  }

  // Rejected code end here

  approvedAlertbox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (isAlreadyApproved == false) {
                          if (isAlreadyRejected == false) {
                            storeApprovedGatePass();
                            isAlreadyApproved = true;
                          }
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'YES',
                      style: TextStyle(color: textColor),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'NO',
                      style: TextStyle(color: textColor),
                    ))
              ],
            ),
          ],
          title: const Text(
            'Are you sure, you want to Approve this application?',
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }

  rejectedAlertbox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        if (isAlreadyRejected == false) {
                          if (isAlreadyApproved == false) {
                            storeRejectedGatePass();
                            isAlreadyRejected = true;
                          }
                        }
                      });

                      Navigator.pop(context);
                    },
                    child: const Text(
                      'YES',
                      style: TextStyle(color: textColor),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'NO',
                      style: TextStyle(color: textColor),
                    ))
              ],
            ),
          ],
          title: const Text(
            'Are you sure, you want to Reject this application?',
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }
}
