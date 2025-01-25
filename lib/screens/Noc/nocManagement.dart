// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/nocManagementProvider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/authScreen/loginScreen.dart';
import 'package:society_admin/screens/Noc/addNoc.dart';
import 'package:society_admin/screens/Noc/typeOfNoc.dart';

// ignore: must_be_immutable
class NocManagement extends StatefulWidget {
  NocManagement(
      {super.key, required this.society, required this.userId, List? allRoles});
  String society;
  List<dynamic> allRoles = [];
  String userId;
  bool isClicked = false;
  @override
  State<NocManagement> createState() => _NocManagementState();
}

class _NocManagementState extends State<NocManagement> {
  int selectedDateIndex = 0;

  List<dynamic> dataList = [];
  List<dynamic> dataListOfNocType = [];
  List<dynamic> dateofNocList = [];
  String selectedFlatno = '';
  bool isNocLoaded = false;
  Map<String, dynamic> allNocData = {};

  // Map<String, dynamic> allComplaintData = {};
  bool isLoading = true;

  bool isShowNoc = false;
  // bool isClicked = false;
  @override
  void initState() {
    super.initState();
    getFlatNum(widget.society, widget.userId).whenComplete(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NocManagementProvider>(context, listen: false);
    provider.setFetchNocFuntion(
      () => dateOfNoc(
        widget.society,
        selectedFlatno,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOC Application', style: TextStyle(color: white)),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [lightBlueColor, blueColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight))),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20.0),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                                        isShowNoc = true;
                                      });
                                    },
                                    minVerticalPadding: 0.3,
                                    title: Center(
                                      child: Text(
                                        dataList[index]['flatno'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                      child: isShowNoc
                          ? TypeOfNoc(
                              nocTypeList: dataListOfNocType,
                              flatNo: selectedFlatno.toString(),
                              society: widget.society,
                              userId: widget.userId,
                            )
                          : Container(),
                    )),
                Consumer<NocManagementProvider>(
                  builder: (context, value, child) {
                    return Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: dateofNocList.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
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
                                                      dateofNocList[index]
                                                          .toString())
                                                  .whenComplete(() {
                                                isNocLoaded = !isNocLoaded;
                                                provider.setLoadWidget(true);
                                                // setState(() {});
                                              });
                                            },
                                            minVerticalPadding: 0.3,
                                            title: Center(
                                              child: Text(
                                                dateofNocList[index].toString(),
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
                Consumer<NocManagementProvider>(
                  builder: (context, value, child) {
                    return Expanded(
                        flex: 5,
                        child: provider.loadWidget
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: 500,
                                child: isNocLoaded
                                    ? AddNoc(
                                        nocType: provider.selectedNoc,
                                        text: allNocData['text'].toString(),
                                        society: widget.society,
                                        flatNo: selectedFlatno,
                                        date: dateofNocList[selectedDateIndex]
                                            .toString(),
                                        fcmId: allNocData['fcmId'].toString(),
                                      )
                                    : Container(),
                              )
                            : Container());
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

  // Future<void> getTypeOfNoc(society, flatNo) async {
  //   QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
  //       .collection('nocApplications')
  //       .doc(society)
  //       .collection('flatno')
  //       .doc(flatNo)
  //       .collection('typeofNoc')
  //       .get();

  //   List<dynamic> allNocType =
  //       flatNumQuerySnapshot.docs.map((e) => e.data()).toList();
  //   print('heloloeeoc $allNocType');
  //   dataListOfNocType = allNocType;
  //   if (kDebugMode) {
  //     print('dataList $dataListOfNocType');
  //   }
  // }

  Future<dynamic> dateOfNoc(String society, String flatNo) async {
    try {
      final provider =
          Provider.of<NocManagementProvider>(context, listen: false);
      QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
          .collection('nocApplications')
          .doc(society)
          .collection('flatno')
          .doc(flatNo)
          .collection('typeofNoc')
          .doc(provider.selectedNoc)
          .collection('dateOfNoc')
          .get();

      if (flatNumQuerySnapshot.docs.isNotEmpty) {
        List<dynamic> allNocType =
            flatNumQuerySnapshot.docs.map((e) => e.id).toList();
        print('heloloeeoc $allNocType');
        dateofNocList = allNocType;
      } else {
        dateofNocList = [];
      }
    } catch (e) {
      print("Error while fetching data $e");
    }
  }

  Future<void> allDatafetch(String society, String flatNo, String date) async {
    try {
      final provider =
          Provider.of<NocManagementProvider>(context, listen: false);
      DocumentSnapshot fetchallData = await FirebaseFirestore.instance
          .collection('nocApplications')
          .doc(society)
          .collection('flatno')
          .doc(flatNo)
          .collection('typeofNoc')
          .doc(provider.selectedNoc)
          .collection('dateOfNoc')
          .doc(date)
          .get();
      print('bers');
      if (fetchallData.exists) {
        //allComplaintData = fetchallData.data().toString();
        allNocData = fetchallData.data() as Map<String, dynamic>;
        print('allNocData $allNocData');
      }
    } catch (e) {
      print("Error while fetching data $e");
    }
  }
}
