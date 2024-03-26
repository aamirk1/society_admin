// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Complaint/typeOfComplaint.dart';

// ignore: must_be_immutable
class ComplaintManagement extends StatefulWidget {
  ComplaintManagement(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});
  String society;
  List<dynamic> allRoles = [];
  String userId;

  @override
  State<ComplaintManagement> createState() => _ComplaintManagementState();
}

class _ComplaintManagementState extends State<ComplaintManagement> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getFlatNum(widget.society);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flat No. Of Members'),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.0,
                      mainAxisSpacing: 10),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return TypeOfComplaint(
                              userId: widget.userId,
                              society: widget.society,
                              flatNo: dataList[index]['flatno'],
                            );
                          }),
                        );
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 91, 171, 236),
                        elevation: 5,
                        child: Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dataList[index]['flatno'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Future<void> getFlatNum(String selectedSociety) async {
    isLoading = true;
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('complaints')
        .doc(selectedSociety)
        .collection('flatno')
        .get();

    List<dynamic> allFlat =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();

    // ignore: unused_local_variable
    dataList = allFlat;
    setState(() {
      isLoading = false;
    });
  }
}
