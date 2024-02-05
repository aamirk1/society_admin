// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Complaint/addComplaints.dart';

// ignore: must_be_immutable
class TypeOfComplaint extends StatefulWidget {
  TypeOfComplaint(
      {super.key,
      required this.society,
      required this.flatNo,
      required this.userId});
  String society;
  String flatNo;
  String userId;

  @override
  State<TypeOfComplaint> createState() => _TypeOfComplaintState();
}

class _TypeOfComplaintState extends State<TypeOfComplaint> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getTypeOfComplaint(widget.society, widget.flatNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Type of Complaint'),
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
                            dataList[index]['complaintsType'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          // subtitle: Text(data.docs[index]['city']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return AddComplaint(
                                  complaintType: dataList[index]
                                      ['complaintsType'],
                                  text: dataList[index]['text'],
                                  society: widget.society,
                                  flatNo: widget.flatNo,
                                  userId: widget.userId,
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

  Future<void> getTypeOfComplaint(society, flatNo) async {
    isLoading = true;
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('complaints')
        .doc(society)
        .collection('flatno')
        .doc(flatNo)
        .collection('typeofcomplaints')
        .get();

    List<dynamic> allComplaintType =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();
    print('heloloeeoc $allComplaintType');
    // ignore: unused_local_variable
    dataList = allComplaintType;
    setState(() {
      isLoading = false;
    });
  }
}
