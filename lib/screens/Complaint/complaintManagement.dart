// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Complaint/addComplaints.dart';
import 'package:society_admin/screens/Complaint/typeOfComplaint.dart';

import '../../Provider/complaintManagementProvider.dart';

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
  List<dynamic> complaintDataList = [];
  String selectedFlatno = '';
  bool isComplaintLoaded = false;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getFlatNum(widget.society).whenComplete(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ComplaintManagementProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flat No. Of Members'),
          backgroundColor: primaryColor,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 5,
                          //     crossAxisSpacing: 10,
                          //     childAspectRatio: 2.0,
                          //     mainAxisSpacing: 10),
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                              child: Card(
                                color: primaryColor,
                                elevation: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ListTile(
                                        onTap: () {
                                          selectedFlatno =
                                              dataList[index]['flatno'];
                                          getTypeOfComplaint(widget.society,
                                                  selectedFlatno)
                                              .whenComplete(() {
                                            isComplaintLoaded = true;
                                            setState(() {});
                                          });
                                        },
                                        minVerticalPadding: 0.3,
                                        title: Center(
                                          child: Text(
                                            dataList[index]['flatno'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )),
                                ),
                                //Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return TypeOfComplaint(
                                //       userId: widget.userId,
                                //       society: widget.society,
                                //       flatNo: dataList[index]['flatno'],
                                //     );
                                //   }),
                                // );
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: 500,
                        child: TypeOfComplaint(
                          dataList: complaintDataList,
                          TypeOfComplaint: complaintDataList,
                          flatNo: selectedFlatno,
                          society: widget.society,
                          userId: widget.userId,
                        ),
                      )),
                  Consumer<ComplaintManagementProvider>(
                      builder: (context, value, child) {
                    return Expanded(
                      flex: 5,
                      child: provider.loadWidget
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: 500,
                              child: isComplaintLoaded
                                  ? AddComplaint(
                                      complaintType: complaintDataList[
                                              globalSelectedIndexForComplaint]
                                          ['complaintsType'],
                                      text: complaintDataList[
                                              globalSelectedIndexForComplaint]
                                          ['text'],
                                      society: widget.society,
                                      userId: widget.userId,
                                      flatNo: selectedFlatno,
                                    )
                                  : Container(),
                            )
                          : Container(),
                    );
                  })
                ],
              ));
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
    dataList = allFlat;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getTypeOfComplaint(society, flatNo) async {
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
    complaintDataList = allComplaintType;
  }
}
