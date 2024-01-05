// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';

class AddNotice extends StatefulWidget {
  static const id = "/addNotice";
  AddNotice({super.key, this.societyName});
  String? societyName;

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
                onPressed: () {
                  storeNotice(
                      titleController.text, customNoticeController.text);
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
              margin: EdgeInsets.only(top: 10),
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

  void storeNotice(title, notice) {
    FirebaseFirestore.instance
        .collection('notice')
        .doc(widget.societyName)
        .collection('notices')
        .doc(title)
        .set({
      'date': date,
      'notice': notice,
    });

    Navigator.pop(context);
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
      if (file.bytes != null) {
        taskSnapshot = await FirebaseStorage.instance
            .ref('Notices')
            .child(widget.societyName!)
            .child(fileName)
            .putData(file.bytes!);

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
