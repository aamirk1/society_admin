// import 'dart:html';
// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore, void_checks, file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/deleteNoticeProvider.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddNotice extends StatefulWidget {
  static const id = "/addNotice";
  AddNotice({super.key, this.societyName, required this.userId});
  String? societyName;
  String userId;
  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController customNoticeController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  List<String> searchedList = [];
  PlatformFile? selectedFile;
  @override
  void dispose() {
    customNoticeController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  final date = DateFormat('dd-MM-yyyy ').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: customNoticeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Notice',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
                onPressed: () async {
                  storeNotice(titleController.text, customNoticeController.text,
                      widget.userId);
                },
                child: const Text('Submit')),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'OR',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                      onPressed: () async {
                        selectedFile = await pickAndUploadPDF();
                        setState(() {});
                      },
                      child: const Text('Pick PDF'),
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
                      child: const Text('Upload PDF'),
                    ),
                    // Text('${fileName} Uploaded successfully');
                  ]),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> storeNotice(title, notice, userId) async {
    final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('notice')
        .doc(widget.societyName)
        .collection('notices')
        .doc(title)
        .set({
      'userId': userId,
      'title': title,
      'date': date,
      'notice': notice,
    });
    provider.addSingleList({
      'userId': userId,
      'title': title,
      'date': date,
      'notice': notice,
    });
    Navigator.pop(context);
  }

  Future<void> sendNotification(String token, String title, String body) async {
    final url = Uri.parse('http://localhost:3000/not');

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
    final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);
    try {
      TaskSnapshot taskSnapshot;
      if (file.bytes != null) {
        taskSnapshot = await FirebaseStorage.instance
            .ref('Notices')
            .child(widget.societyName!)
            .child(fileName)
            .putData(file.bytes!);
        provider.addSingleList({
          'title': fileName,
        });

        // ignore: use_build_context_synchronously
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
                      Navigator.pop(context);
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
                ),
              ),
            ],
            title: const Text(
              'Please select a file first!',
              style: TextStyle(color: Colors.red),
            ),
          );
        });
  }
}
