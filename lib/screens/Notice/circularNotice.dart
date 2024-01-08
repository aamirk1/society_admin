import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Notice/addNotice.dart';
import 'package:society_admin/screens/Notice/viewNotice.dart';

// ignore: must_be_immutable
class CircularNotice extends StatefulWidget {
  CircularNotice({super.key, this.society, this.allRoles});
  String? society;
  List<dynamic>? allRoles = [];

  @override
  State<CircularNotice> createState() => _CircularNoticeState();
}

class _CircularNoticeState extends State<CircularNotice> {
  List<dynamic> dataList = [];
  List<String> fileList = [];
  String url = '';
  bool isLoading = true;
  final date = DateFormat('dd-MM-yyyy ').format(DateTime.now());
  @override
  void initState() {
    print(date);
    getNotice(widget.society);
    getNoticePdf(widget.society);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular Notice'),
        backgroundColor: primaryColor,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                      minimumSize: MaterialStateProperty.all(
                        Size(20, 10),
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AddNotice(societyName: widget.society);
                      }),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: textColor,
                  ),
                ),
              ))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ListTile(
                            minVerticalPadding: 0.3,
                            title: Text(
                              dataList[index]['title'],
                              style: const TextStyle(color: textColor),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                deleteNotice(
                                    widget.society, dataList[index]['title']);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ViewNotice(
                                      society: widget.society,
                                      title: dataList[index]['title'],
                                      notice: dataList[index]['notice'],
                                      date: dataList[index]['date']);
                                }),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                ListView.builder(
                    itemCount: fileList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ListTile(
                            minVerticalPadding: 0.3,
                            title: Text(
                              fileList[index],
                              style: const TextStyle(color: textColor),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                deleteNoticePdf(
                                    widget.society, fileList[index]);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            onTap: () {
                              openPdf(fileList[index]);
                            },
                          ),
                        ),
                      );
                    })
              ],
            ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> getNotice(String? SelectedSociety) async {
    isLoading = true;
    QuerySnapshot getAllNotice = await FirebaseFirestore.instance
        .collection('notice')
        .doc(SelectedSociety)
        .collection('notices')
        .get();
    List<dynamic> allTypeOfNotice =
        getAllNotice.docs.map((e) => e.data()).toList();
    dataList = allTypeOfNotice;
    setState(() {
      isLoading = false;
    });
  }

  Future<List<String>> getNoticePdf(String? SelectedSociety) async {
    isLoading = true;
    // List<String> fileList = [];
    ListResult listResult = await FirebaseStorage.instance
        .ref('Notices')
        .child(SelectedSociety!)
        .listAll();

    for (Reference ref in listResult.items) {
      String filename = ref.name;
      fileList.add(filename);
      setState(() {
        isLoading = false;
      });
    }
    return fileList;
  }

  Future<void> deleteNotice(
      String? SelectedSociety, String typeOfNotice) async {
    DocumentReference deleteNotice = FirebaseFirestore.instance
        .collection('notice')
        .doc(SelectedSociety)
        .collection('notices')
        .doc(typeOfNotice);
    await deleteNotice.delete();
  }

  Future<void> deleteNoticePdf(String? SelectedSociety, String fileName) async {
    await FirebaseStorage.instance
        .ref('Notices')
        .child(SelectedSociety!)
        .child(fileName)
        .delete();
  }

  openPdf(String title) async {
    final storage = FirebaseStorage.instance;
    final Reference ref =
        storage.ref('Notices').child(widget.society!).child(title);
    String url = await ref.getDownloadURL();
    print('url - $url');

    if (kIsWeb) {
      html.window.open(url, '_blank');
      final encodedUrl = Uri.encodeFull(url);
      html.Url.revokeObjectUrl(encodedUrl);
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
  }
}
