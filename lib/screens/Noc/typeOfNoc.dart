// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Noc/addNoc.dart';

// ignore: must_be_immutable
class TypeOfNoc extends StatefulWidget {
  TypeOfNoc({super.key, required this.society, required this.flatNo, required this.userId});
  String society;
  String flatNo;
  String userId;

  @override
  State<TypeOfNoc> createState() => _TypeOfNocState();
}

class _TypeOfNocState extends State<TypeOfNoc> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getTypeOfNoc(widget.society, widget.flatNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Type of Noc'),
          backgroundColor: primaryColor,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          minVerticalPadding: 0.3,
                          title: Text(
                            dataList[index]['nocType'],
                            style: TextStyle(color: Colors.black),
                          ),
                          // subtitle: Text(data.docs[index]['city']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return AddNoc(
                                  nocType: dataList[index]['nocType'],
                                  text: dataList[index]['text'],
                                  society: widget.society,
                                  flatNo: widget.flatNo,
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ]));
  }

  Future<void> getTypeOfNoc(society, flatNo) async {
    isLoading = true;
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('nocApplications')
        .doc(society)
        .collection('flatno')
        .doc(flatNo)
        .collection('typeofNoc')
        .get();

    List<dynamic> allNocType =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();
    print('heloloeeoc $allNocType');
    // ignore: unused_local_variable
    dataList = allNocType;
    print('dataList ${dataList}');
    setState(() {
      isLoading = false;
    });
  }
}
