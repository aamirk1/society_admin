// ignore_for_file: non_constant_identifier_names, avoid_web_libraries_in_flutter, duplicate_ignore, file_names

import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/deleteNoticeProvider.dart';
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
  final date = DateFormat('dd-MM-yyyy ').format(DateTime.now());
  @override
  void initState() {
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
              padding:const EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                      minimumSize: MaterialStateProperty.all(
                        const Size(20, 10),
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
      body: Material(
        child: SingleChildScrollView(
          child: Consumer<DeleteNoticeProvider>(
            builder: (context, value, child) => Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.noticeList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ListTile(
                            minVerticalPadding: 0.3,
                            title: Text(
                              value.noticeList[index]['title'],
                              style: const TextStyle(color: textColor),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                deleteNotice(widget.society,
                                    value.noticeList[index]['title'], index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ViewNotice(
                                      society: widget.society,
                                      title: value.noticeList[index]['title'],
                                      notice: value.noticeList[index]['notice'],
                                      date: value.noticeList[index]['date']);
                                }),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                ListView.builder(
                    itemCount: value.noticePdfList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ListTile(
                            minVerticalPadding: 0.3,
                            title: Text(
                              value.noticePdfList[index].toString(),
                              style: const TextStyle(color: textColor),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                deleteNoticePdf(widget.society,
                                    value.noticePdfList[index], index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            onTap: () {
                              openPdf(value.noticePdfList[index]);
                            },
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> getNotice(String? SelectedSociety) async {
    final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);

    QuerySnapshot getAllNotice = await FirebaseFirestore.instance
        .collection('notice')
        .doc(SelectedSociety)
        .collection('notices')
        .get();
    List<dynamic> allTypeOfNotice =
        getAllNotice.docs.map((e) => e.data()).toList();
    provider.setBuilderNoticeList(allTypeOfNotice);
  }

  Future<List<String>> getNoticePdf(String? SelectedSociety) async {
    final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);

    // List<String> fileList = [];

    ListResult listResult = await FirebaseStorage.instance
        .ref('Notices')
        .child(SelectedSociety!)
        .listAll();

    for (Reference ref in listResult.items) {
      String filename = ref.name;
      fileList.add(filename);
    }

    provider.setBuilderNoticePdfList(fileList);

    return fileList;
  }

  Future<void> deleteNotice(
      String? SelectedSociety, String typeOfNotice, int index) async {
    final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);
    DocumentReference deleteNotice = FirebaseFirestore.instance
        .collection('notice')
        .doc(SelectedSociety)
        .collection('notices')
        .doc(typeOfNotice);
    await deleteNotice.delete();
    provider.removeData(index);
  }

  Future<void> deleteNoticePdf(
      String? SelectedSociety, String fileName, int index) async {
    final provider = Provider.of<DeleteNoticeProvider>(context, listen: false);
    await FirebaseStorage.instance
        .ref('Notices')
        .child(SelectedSociety!)
        .child(fileName)
        .delete();

    provider.removePdfData(index);
  }

  openPdf(String title) async {
    final storage = FirebaseStorage.instance;
    final Reference ref =
        storage.ref('Notices').child(widget.society!).child(title);
    String url = await ref.getDownloadURL();

    if (kIsWeb) {
      html.window.open(url, '_blank');
      final encodedUrl = Uri.encodeFull(url);
      html.Url.revokeObjectUrl(encodedUrl);
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
  }
}
