// ignore_for_file: must_be_immutable, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class AddComplaint extends StatefulWidget {
  AddComplaint(
      {super.key,
      required this.complaintType,
      required this.society,
      required this.text,
      required this.flatNo,
      required this.date,
      this.response,
      required this.fcmId});
  String complaintType;
  String society;
  String text;
  String flatNo;
  String date;
  String? response;
  String fcmId;
  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  PlatformFile? selectedFile;

  TextEditingController responseMsgController = TextEditingController();
  @override
  void initState() {
    print('fcm ${widget.fcmId}');
    print('complaintType ${widget.complaintType}');
    print('society ${widget.society}');
    print('text ${widget.text}');
    print('flatNo ${widget.flatNo}');
    print('date ${widget.date}');
    print('response ${widget.response}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: 
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.90,
            child: Card(
              elevation: 5,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Flat No: ${widget.flatNo}',
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    widget.complaintType,
                    style: const TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
                const SizedBox(
                  height: 7,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 5.0),
                          child: Text(
                            widget.text,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(color: textColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  'Response: ${widget.response ?? 'Response not sent.'}',
                  style: const TextStyle(color: textColor, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                          style: const TextStyle(color: textColor),
                          controller: responseMsgController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Response',
                            border: OutlineInputBorder(),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(primaryColor),
                            minimumSize: WidgetStateProperty.all(
                              const Size(20, 30),
                            ),
                          ),
                          onPressed: () {
                            if (responseMsgController.text.isNotEmpty) {
                              storeData().whenComplete(() {
                                successAlertBox();
                                sendNotification(
                                    widget.fcmId,
                                    widget.complaintType,
                                    responseMsgController.text);
                              });
                            } else {
                              errorAlertBox();
                            }
                          },
                          child: const Text(
                            'Send Response',
                            style: TextStyle(color: white),
                          ))
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> storeData() async {
    if (responseMsgController.text.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('complaints')
          .doc(widget.society)
          .collection('flatno')
          .doc(widget.flatNo)
          .collection('typeofcomplaints')
          .doc(widget.complaintType)
          .collection('dateOfComplaint')
          .doc(widget.date)
          .update({'response': responseMsgController.text});
    }
  }

  successAlertBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 50,
                  ),
                  const Text(
                    'Response sent successfully',
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      responseMsgController.clear();
                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Text(
                        'OK',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  errorAlertBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.yellow[700],
                    size: 50,
                  ),
                  const Text(
                    'Please enter response',
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Text(
                        'OK',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
