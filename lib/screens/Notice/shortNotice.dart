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
class ShortNotice extends StatefulWidget {
  static const id = "/ShortNotice";
  ShortNotice(
      {super.key,
      this.societyName,
      required this.userId,
      this.isIndex1 = false,
      required this.fcmIdList});
  String? societyName;
  String userId;
  bool isIndex1;
  List<String> fcmIdList = [];

  @override
  State<ShortNotice> createState() => _ShortNoticeState();
}

class _ShortNoticeState extends State<ShortNotice> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController customNoticeController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  List<String> searchedList = [];
  @override
  void dispose() {
    customNoticeController.dispose();
    titleController.dispose();
    super.dispose();
  }

  final date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                color: primaryColor)),
        title: const Text('Short Notice', style: TextStyle(color: white)),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 20,
                        autofocus: widget.isIndex1,
                        // autofocus: true,
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)
                          ),
                          labelText: 'Title',
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextField(
                        maxLength: 500,
                        maxLines: 10,
                        controller: customNoticeController,
                        decoration: const InputDecoration(
                          
                          hintText: 'Write a short notice',
                          border: OutlineInputBorder( borderSide: BorderSide(color: primaryColor)
                        ),
                          // alignLabelWithHint: true,
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
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(MediaQuery.of(context).size.width * 0.09, 50),
                      ),
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    onPressed: () async {
                      storeNotice(titleController.text,
                              customNoticeController.text, widget.userId)
                          .whenComplete(() {

                        sendNoticeNotification(
                            widget.fcmIdList, "Notice", titleController.text);
                      });
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> storeNotice(String title, String notice, String userId) async {
  try {
    final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);
    
    // Create a reference with an auto-generated ID
    DocumentReference noticeRef = FirebaseFirestore.instance
        .collection('notice')
        .doc(widget.societyName)
        .collection('notices')
        .doc(); // Auto-generated ID

    await noticeRef.set({
      'id': noticeRef.id, // Store the document ID for future edits
      'userId': userId,
      'title': title,
      'date': DateTime.now().toString(),
      'notice': notice,
    }).whenComplete((){
      
    Navigator.pop(context);
    });

    print('Notice stored successfully!');
  } catch (e) {
    print('Error storing notice: $e');
  }
}
  // Future<void> storeNotice(title, notice, userId) async {
  //   final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);
  //   await FirebaseFirestore.instance
  //       .collection('notice')
  //       .doc(widget.societyName)
  //       .collection('notices')
  //       .doc(title)
  //       .set({
  //     'userId': userId,
  //     'title': title,
  //     'date': date,
  //     'notice': notice,
  //   });
  //   provider.addSingleList({
  //     'userId': userId,
  //     'title': title,
  //     'date': date,
  //     'notice': notice,
  //   });
  //   Navigator.pop(context);
  // }

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

  Future<void> sendNotification(
      String token, String title, String message) async {
    final url = Uri.parse('https://notifactionsend-ram2.onrender.com/not');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'token': token,
          'message': message,
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
}
