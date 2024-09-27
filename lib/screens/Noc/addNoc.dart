// import 'dart:html';
// ignore_for_file: use_build_context_synchronously, avoid_print, file_names, void_checks
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddNoc extends StatefulWidget {
  AddNoc(
      {super.key,
      required this.nocType,
      required this.text,
      required this.society,
      required this.flatNo,
      required this.date});
  String nocType;
  String text;
  String society;
  String flatNo;
  String date;
  @override
  State<AddNoc> createState() => _AddNocState();
}

class _AddNocState extends State<AddNoc> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
    // getTypeOfNoc(widget.society, widget.flatNo, widget.nocType,widget.text);
  }

  @override
  Widget build(BuildContext context) {
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
                            widget.nocType,
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
                            backgroundColor: primaryColor),
                        onPressed: () async {
                          selectedFile = await pickAndUploadPDF();
                          setState(() {});
                        },
                        child: const Text(
                          'Pick PDF',
                          style: TextStyle(color: white),
                        ),
                      ),
                      Text(
                        selectedFile?.name ?? 'No file selected',
                        style: const TextStyle(color: textColor),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () {
                          if (selectedFile == null) {
                            return alertbox();
                          } else {
                            uploadFile(selectedFile!, selectedFile!.name);
                          }
                        },
                        child: const Text(
                          'Upload PDF',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PlatformFile> pickAndUploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    PlatformFile? file;

    if (result != null) {
      file = result.files.first;
    } else {
      print('File picking canceled');
    }
    return file!;
  }

  void uploadFile(PlatformFile file, String fileName) async {
    try {
      TaskSnapshot taskSnapshot;
      // ignore: duplicate_ignore
      if (file.bytes != null) {
        taskSnapshot = await FirebaseStorage.instance
            .ref('NocPdfs')
            .child(widget.society)
            .child(widget.flatNo)
            .child(widget.nocType)
            .child(widget.date)
            .child(fileName)
            .putData(file.bytes!);
      } else {
        throw Exception('File bytes are null');
      }

      if (taskSnapshot.state == TaskState.success) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  '$fileName uploaded successfully!',
                  style: const TextStyle(color: Colors.green),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  )
                ],
              );
            });
      } else {
        print('Failed to upload PDF file');
      }
    } on FirebaseException catch (e) {
      print('Failed to upload PDF file: $e');
    }
  }

  alertbox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: textColor),
                    )),
              ],
              title: const Text(
                'Please select a file first!',
                style: TextStyle(color: Colors.red),
              ));
        });
  }

  Future<void> sendNotification(String token, String title, String body) async {
    final url =
        Uri.parse('http://localhost:8000/notifications/send-notification/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Notification sent successfully: ${response.body}');
      } else {
        // Handle error response
        print('Failed to send notification: ${response.body}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }
}
