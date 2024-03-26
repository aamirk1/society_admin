// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Noc/typeOfNoc.dart';

// ignore: must_be_immutable
class NocManagement extends StatefulWidget {
  NocManagement(
      {super.key, required this.society, required this.userId, List? allRoles});
  String society;
  List<dynamic> allRoles = [];
  String userId;

  @override
  State<NocManagement> createState() => _NocManagementState();
}

class _NocManagementState extends State<NocManagement> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getFlatNum(widget.society, widget.userId).whenComplete(() {
      isLoading = false;
    });
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
                            return TypeOfNoc(
                              society: widget.society,
                              flatNo: dataList[index]['flatno'],
                              userId: widget.userId,
                            );
                          }),
                        );
                      },
                      child: Card(
                        color: Color.fromARGB(255, 91, 171, 236),
                        elevation: 5,
                        child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              dataList[index]['flatno'],
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Future<void> getFlatNum(String selectedSociety, String userId) async {
    isLoading = true;
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('nocApplications')
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
