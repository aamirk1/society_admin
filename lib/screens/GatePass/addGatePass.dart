// import 'dart:html';
// ignore_for_file: use_build_context_synchronously, avoid_print, file_names, void_checks
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/gatePassProvider.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddGatePass extends StatefulWidget {
  AddGatePass(
      {super.key,
      required this.gatePassType,
      required this.text,
      required this.society,
      required this.flatNo,
      required this.date});
  String gatePassType;
  String text;
  String society;
  String flatNo;
  String date;

  @override
  @override
  State<AddGatePass> createState() => _AddGatePassState();
}

class _AddGatePassState extends State<AddGatePass> {
  List<dynamic> dataList = [];
  PlatformFile? selectedFile;
  String url = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GatePassProvider>(context, listen: false);
    print('isApproved - ${provider.isApproved}');
    return Scaffold(
      body: Center(
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
                        onPressed: provider.isApproved == false
                            ? null
                            : provider.isApproved != null
                                ? () {}
                                : () {
                                    approvedAlertbox(true, 'Approved');
                                  },
                        child: provider.isApproved == true
                            ? const Text('Approved')
                            : const Text('Approve'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: provider.isApproved == true
                            ? null
                            : provider.isApproved != null
                                ? () {}
                                : () {
                                    approvedAlertbox(false, 'Rejected');
                                  },
                        child: provider.isApproved == false
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

  Future<void> storeApprovedGatePass(bool approvedStatus) async {
    final provider = Provider.of<GatePassProvider>(context, listen: false);
    await firestore
        .collection('gatePassApplications')
        .doc(widget.society)
        .collection('flatno')
        .doc(widget.flatNo)
        .collection('gatePassType')
        .doc(provider.selectedPass)
        .collection('dateOfGatePass')
        .doc(widget.date)
        .update({"isApproved": approvedStatus});
  }

  // Rejected code end here

  approvedAlertbox(bool approvedStatus, String status) {
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
                        final provider = Provider.of<GatePassProvider>(context,
                            listen: false);
                        storeApprovedGatePass(approvedStatus);
                        provider.setIsApproved(approvedStatus);
                        provider.setLoadWidget(true);
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
          title: Text(
            'Are you sure, you want to $status this application?',
            style: const TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }
}
