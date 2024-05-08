// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/authScreen/loginScreen.dart';
import 'package:society_admin/screens/Complaint/addComplaints.dart';
import 'package:society_admin/screens/Complaint/typeOfComplaint.dart';

import '../../Provider/complaintManagementProvider.dart';

class ComplaintManagement extends StatefulWidget {
  ComplaintManagement(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});
  final String society;
  List<dynamic> allRoles = [];
  final String userId;

  @override
  State<ComplaintManagement> createState() => _ComplaintManagementState();
}

class _ComplaintManagementState extends State<ComplaintManagement> {
  List<dynamic> dataList = [];
  List<dynamic> complaintDataList = [];
  List<dynamic> dateofComplainList = [];
  Map<String, dynamic> allComplaintData = {};
  String selectedFlatno = '';
  bool isComplaintLoaded = false;
  int selectedDateIndex = 0;
  bool isLoading = true;
  bool isShowComplaint = false;

  @override
  void initState() {
    super.initState();
    getFlatNum(widget.society).whenComplete(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ComplaintManagementProvider>(context, listen: false);
    provider.setFetchComplaintFuntion(
      () => dateOfComplaint(
        widget.society,
        selectedFlatno,
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Complaint Application',
          ),
          backgroundColor: primaryColor,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 20.0),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
            )
          ],
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

                                          setState(() {
                                            isShowComplaint = true;
                                          });
                                        },
                                        minVerticalPadding: 0.3,
                                        title: Center(
                                          child: Text(
                                            dataList[index]['flatno'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
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
                      child: isShowComplaint
                          ? TypeOfComplaint(
                              dataList: complaintDataList,
                              flatNo: selectedFlatno.toString(),
                              society: widget.society,
                              userId: widget.userId,
                            )
                          : Container(),
                    ),
                  ),
                  Consumer<ComplaintManagementProvider>(
                    builder: (context, value, child) {
                      return Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: dateofComplainList.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
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
                                                selectedDateIndex = index;
                                                allDatafetch(
                                                        widget.society,
                                                        selectedFlatno,
                                                        dateofComplainList[
                                                                index]
                                                            .toString())
                                                    .whenComplete(() {
                                                  isComplaintLoaded =
                                                      !isComplaintLoaded;
                                                  provider.setLoadWidget(true);
                                                  // setState(() {});
                                                });
                                              },
                                              minVerticalPadding: 0.3,
                                              title: Center(
                                                child: Text(
                                                  dateofComplainList[index]
                                                      .toString(),
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
                      );
                    },
                  ),
                  Consumer<ComplaintManagementProvider>(
                    builder: (context, value, child) {
                      return Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: provider.loadWidget
                              ? AddComplaint(
                                  complaintType: provider.selectedComplaint,
                                  text: allComplaintData['text'],
                                  society: widget.society,
                                  flatNo: selectedFlatno,
                                  date: dateofComplainList[selectedDateIndex]
                                      .toString(),
                                  response: allComplaintData['response'],
                                )
                              : Container(),
                        ),
                      );
                    },
                  )
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

  // Future<void> getTypeOfComplaint(society, flatNo) async {
  //   QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
  //       .collection('complaints')
  //       .doc(society)
  //       .collection('flatno')
  //       .doc(flatNo)
  //       .collection('typeofcomplaints')
  //       .get();

  //   List<dynamic> allComplaintType =
  //       flatNumQuerySnapshot.docs.map((e) => e.data()).toList();
  //   print('heloloeeoc $allComplaintType');
  //   // ignore: unused_local_variable
  //   complaintDataList = allComplaintType;

  Future<dynamic> dateOfComplaint(String society, String flatNo) async {
    try {
      final provider =
          Provider.of<ComplaintManagementProvider>(context, listen: false);
      QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(society)
          .collection('flatno')
          .doc(flatNo)
          .collection('typeofcomplaints')
          .doc(provider.selectedComplaint)
          .collection('dateOfComplaint')
          .get();

      if (flatNumQuerySnapshot.docs.isNotEmpty) {
        List<dynamic> allComplaintType =
            flatNumQuerySnapshot.docs.map((e) => e.id).toList();
        print('heloloeeoc $allComplaintType');
        dateofComplainList = allComplaintType;
      } else {
        dateofComplainList = [];
      }
    } catch (e) {
      print("Error while fetching data $e");
    }
  }

  Future<void> allDatafetch(String society, String flatNo, String date) async {
    try {
      final provider =
          Provider.of<ComplaintManagementProvider>(context, listen: false);
      DocumentSnapshot fetchallData = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(society)
          .collection('flatno')
          .doc(flatNo)
          .collection('typeofcomplaints')
          .doc(provider.selectedComplaint)
          .collection('dateOfComplaint')
          .doc(date)
          .get();

      if (fetchallData.exists) {
        //allComplaintData = fetchallData.data().toString();
        allComplaintData = fetchallData.data() as Map<String, dynamic>;
        print('allComplaintData $allComplaintData');
      }
    } catch (e) {
      print("Error while fetching data $e");
    }
  }
}
