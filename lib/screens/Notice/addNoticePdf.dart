// import 'dart:html';
// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore, void_checks, file_names

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/deleteNoticeProvider.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddNoticePdf extends StatefulWidget {
  static const id = "/AddNoticePdf";
  AddNoticePdf(
      {super.key,
      this.societyName,
      required this.userId,
      required this.fcmIdList});
  String? societyName;
  String userId;
  List<String> fcmIdList = [];

  @override
  State<AddNoticePdf> createState() => _AddNoticePdfState();
}

class _AddNoticePdfState extends State<AddNoticePdf> {
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
    pickAndUploadPDF().whenComplete(() {
      setState(() {});
    });
  }

  final date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            width: MediaQuery.of(context).size.width * 0.50,
            child: Card(
              elevation: 10,
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.20,
                          color: white,
                          child: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 100,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width * 0.15,
                            color: primaryColor,
                            child: Center(
                              child: Text(
                                selectedFile?.name ?? 'No file selected',
                                style: const TextStyle(color: white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height * 0.10,
                          width: MediaQuery.of(context).size.width * 0.15,
                          color: primaryColor,
                          child: ElevatedButton(
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
                        ),
                      ]),
                )
              ]),
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
      selectedFile = file;
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
                    )),
              ],
              title: const Text(
                'Please select a file first!',
                style: TextStyle(color: Colors.red),
              ));
        });
  }
}
