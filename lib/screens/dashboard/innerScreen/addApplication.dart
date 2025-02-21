// ignore_for_file: must_be_immutable, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/applicationManagementProvider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:url_launcher/url_launcher.dart';

class AddApplication extends StatefulWidget {
  AddApplication(
      {super.key,
      required this.applicationType,
      required this.society,
      required this.text,
      required this.flatNo,
      required this.date,
      this.response,
      required this.fcmId});
  String applicationType;
  String society;
  String text;
  String flatNo;
  String date;
  String? response;
  String fcmId;
  @override
  State<AddApplication> createState() => _AddApplicationState();
}

class _AddApplicationState extends State<AddApplication> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  PlatformFile? selectedFile;
  List<Map<String, String>> pdfFiles = [];
  TextEditingController responseMsgController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    fetchPdfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection('application')
            .doc(widget.society)
            .collection('flatno')
            .doc(widget.flatNo)
            .collection('applicationType')
            .doc(widget.applicationType)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('No data available');
          }

          var responseData = snapshot.data!.data() as Map<String, dynamic>;
          print('All-------- $responseData');
          String responseText =
              responseData['response'] ?? 'Response not sent.';
          bool? isApproved = responseData['isApproved'];

          return SingleChildScrollView(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.height * 0.70,
                child: Card(
                  elevation: 5,
                  child: widget.applicationType.split(' ').last == 'Issue'
                      ? Column(children: [
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.applicationType,
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
                            height: MediaQuery.of(context).size.height * 0.35,
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            'Response: $responseText',
                            style:
                                const TextStyle(color: textColor, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
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
                                        const Size(30, 50),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (widget.applicationType
                                              .split(' ')
                                              .last ==
                                          'Issue') {
                                        if (responseMsgController
                                            .text.isNotEmpty) {
                                          storeComplaintData().whenComplete(() {
                                            successAlertBox();
                                            sendNotification(
                                                widget.fcmId,
                                                widget.applicationType,
                                                responseMsgController.text);
                                          });
                                        } else {
                                          errorAlertBox();
                                        }
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
                        ])
                      : widget.applicationType.split(' ').last == 'NOC'
                          ? Column(
                              children: [
                                SingleChildScrollView(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.55,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.applicationType,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            widget.text,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height:150,
                                          ),
                                          pdfFiles.isEmpty
                                              ? Text(
                                                  selectedFile?.name ??
                                                      'No file selected',
                                                  style: const TextStyle(
                                                      color: textColor),
                                                )
                                              : Container(
                                                height: 100,
                                                width: MediaQuery.of(context).size.width * 0.45,
                                                  child: ListView.builder(
                                                    itemCount: pdfFiles.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4.0,
                                                                  horizontal:
                                                                      8.0),
                                                          child: Container(
                                                            height: 50,
                                                            width: 150,
                                                            child: ListTile(
                                                              onTap: () => openPdf(
                                                                  pdfFiles[index]
                                                                      ['url']!),
                                                              title: Text(
                                                                  pdfFiles[index]
                                                                      ['name']!),
                                                                      
                                                            ),
                                                          ),
                                                          );
                                                    },
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor),
                                        onPressed: () async {
                                          if (widget.applicationType
                                                  .split(' ')
                                                  .last ==
                                              'NOC') {
                                            selectedFile =
                                                await pickAndUploadPDF();
                                            setState(() {});
                                          } else {}
                                        },
                                        child: const Text(
                                          'Pick PDF',
                                          style: TextStyle(color: white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor),
                                        onPressed: () {
                                          if (selectedFile == null) {
                                            return alertbox();
                                          } else {
                                            uploadFile(selectedFile!,
                                                    selectedFile!.name)
                                                .whenComplete(() {
                                              sendNotification(
                                                  widget.fcmId,
                                                  selectedFile!.name,
                                                  widget.applicationType);
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'Upload PDF',
                                          style: TextStyle(color: white),
                                        ),
                                      ),
                                    ])
                              ],
                            )
                          : Consumer<ApplicationManagementProvider>(
                              builder: (context, value, child) {
                                return Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.55,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.applicationType,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                widget.text,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green),
                                            onPressed: isApproved == false
                                                ? null
                                                : isApproved != null
                                                    ? () {}
                                                    : () {
                                                        approvedAlertbox(
                                                            true, 'Approved');
                                                      },
                                            child: isApproved == true
                                                ? const Text('Approved',
                                                    style:
                                                        TextStyle(color: white))
                                                : const Text('Approve',
                                                    style: TextStyle(
                                                        color: white)),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            onPressed: isApproved == true
                                                ? null
                                                // ignore: unnecessary_null_comparison
                                                : isApproved != null
                                                    ? () {}
                                                    : () {
                                                        approvedAlertbox(
                                                            false, 'Rejected');
                                                      },
                                            child: isApproved == false
                                                ? const Text('Rejected',
                                                    style:
                                                        TextStyle(color: white))
                                                : const Text('Reject',
                                                    style: TextStyle(
                                                        color: white)),
                                          )
                                        ]),
                                  ],
                                );
                              },
                            ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> storeComplaintData() async {
    if (responseMsgController.text.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('application')
          .doc(widget.society)
          .collection('flatno')
          .doc(widget.flatNo)
          .collection('applicationType')
          .doc(widget.applicationType)
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
      },
    );
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

  // funtions

  Future<void> storeApprovedGatePass(bool? approvedStatus) async {
    final provider =
        Provider.of<ApplicationManagementProvider>(context, listen: false);
    provider.setIsApproved(false);

    await firestore
        .collection('application')
        .doc(widget.society)
        .collection('flatno')
        .doc(widget.flatNo)
        .collection('applicationType')
        .doc(widget.applicationType)
        .update({"isApproved": approvedStatus});

    provider.setIsApproved(approvedStatus!);
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
                      final provider =
                          Provider.of<ApplicationManagementProvider>(context,
                              listen: false);
                      storeApprovedGatePass(approvedStatus).whenComplete(() {
                        sendNotification(widget.fcmId, status,
                            provider.selectedApplicationType);
                      });
                      provider.setLoadWidget(true);
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

  Future<void> uploadFile(PlatformFile file, String fileName) async {
    try {
      TaskSnapshot taskSnapshot;
      // ignore: duplicate_ignore
      if (file.bytes != null) {
        taskSnapshot = await FirebaseStorage.instance
            .ref('NocPdfs')
            .child(widget.society)
            .child(widget.flatNo)
            .child(widget.applicationType)
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

  Future<void> fetchPdfFiles() async {
    try {
      String path =
          'NocPdfs/${widget.society}/${widget.flatNo}/${widget.applicationType}/${widget.date}/';
      ListResult result = await FirebaseStorage.instance.ref(path).listAll();

      List<Map<String, String>> tempFiles = [];

      for (var file in result.items) {
        String downloadUrl = await file.getDownloadURL();
        tempFiles.add({'name': file.name, 'url': downloadUrl});
      }

      setState(() {
        pdfFiles = tempFiles;
        print('sss----- $pdfFiles');
      });
    } catch (e) {
      print('Error fetching PDF files: $e');
    }
  }

  void openPdf(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not open the PDF');
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
            ),
          );
        });
  }
}
