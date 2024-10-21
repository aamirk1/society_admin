// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/gatePassProvider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/authScreen/loginScreen.dart';
import 'package:society_admin/screens/GatePass/addGatePass.dart';
import 'package:society_admin/screens/GatePass/typeOfGatePass.dart';

// ignore: must_be_immutable
class GatePass extends StatefulWidget {
  GatePass(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});
  String society;
  List<dynamic> allRoles = [];
  String userId;

  @override
  State<GatePass> createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  List<dynamic> dataListOfPassType = [];
  List<dynamic> dataListOfFlatNo = [];
  int selectedDateIndex = 0;
  List<dynamic> dateofNocList = [];
  String selectedFlatno = '';
  bool isClicked = false;
  bool isGatePassLoaded = false;
  bool isShowGatePass = false;
  bool isLoading = true;
  Map<String, dynamic> allGatePassData = {};
  @override
  void initState() {
    super.initState();
    getFlatNum(widget.society).whenComplete(() {
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GatePassProvider>(context, listen: false);
    provider.setFetchDateOfGatePass(
        () => dateOfGatePass(widget.society, selectedFlatno));

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Gate Pass Application', style: TextStyle(color: white)),
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
                        itemCount: dataListOfFlatNo.length,
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
                                          dataListOfFlatNo[index]['flatno'];
                                      getTypeOfGatePass(
                                              widget.society, selectedFlatno)
                                          .whenComplete(() {
                                        setState(() {
                                          isShowGatePass = true;
                                        });
                                      });
                                    },
                                    minVerticalPadding: 0.3,
                                    title: Center(
                                      child: Text(
                                        dataListOfFlatNo[index]['flatno'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
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
                    child: TypeOfGatePass(
                      flatNo: selectedFlatno,
                      society: widget.society,
                      passType: dataListOfPassType,
                    ),
                  ),
                ),
                Consumer<GatePassProvider>(
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
                                                  dataListOfFlatNo[index]
                                                      ['flatno'];
                                              selectedDateIndex = index;

                                              allDatafetch(
                                                      widget.society,
                                                      selectedFlatno,
                                                      dateofNocList[index]
                                                          .toString())
                                                  .whenComplete(() {
                                                isGatePassLoaded =
                                                    !isGatePassLoaded;
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
                Consumer<GatePassProvider>(
                  builder: ((context, value, child) {
                    return Expanded(
                      flex: 5,
                      child: provider.loadWidget
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: 500,
                              child: isGatePassLoaded
                                  ? AddGatePass(
                                      gatePassType: provider.selectedPass,
                                      text: allGatePassData['text'],
                                      society: widget.society,
                                      flatNo: selectedFlatno,
                                      date: dateofNocList[selectedDateIndex])
                                  : Container(),
                            )
                          : Container(),
                    );
                  }),
                ),
              ],
            ),
    );
  }

  Future<void> getFlatNum(String selectedSociety) async {
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('gatePassApplications')
        .doc(selectedSociety)
        .collection('flatno')
        .get();

    List<dynamic> allFlat =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();

    // ignore: unused_local_variable
    dataListOfFlatNo = allFlat;
    print('dataListOfFlatNo $dataListOfFlatNo');
  }

  Future<void> getTypeOfGatePass(society, flatNo) async {
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('gatePassApplications')
        .doc(society)
        .collection('flatno')
        .doc(flatNo)
        .collection('gatePassType')
        .get();

    List<dynamic> allNocType =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();

    dataListOfPassType = allNocType;
    print("dataListOfPassType - $dataListOfPassType");
  }

  Future<dynamic> dateOfGatePass(String society, String flatNo) async {
    try {
      final provider = Provider.of<GatePassProvider>(context, listen: false);
      QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
          .collection('gatePassApplications')
          .doc(society)
          .collection('flatno')
          .doc(flatNo)
          .collection('gatePassType')
          .doc(provider.selectedPass)
          .collection('dateOfGatePass')
          .get();

      if (flatNumQuerySnapshot.docs.isNotEmpty) {
        List<dynamic> allComplaintType =
            flatNumQuerySnapshot.docs.map((e) => e.id).toList();
        print('heloloeeoc $allComplaintType');
        dateofNocList = allComplaintType;
      } else {
        dateofNocList = [];
      }
      print("dateOfNocList - $dateofNocList");
    } catch (e) {
      print("Error while fetching data $e");
    }
  }

  Future<void> allDatafetch(String society, String flatNo, String date) async {
    try {
      final provider = Provider.of<GatePassProvider>(context, listen: false);
      DocumentSnapshot fetchallData = await FirebaseFirestore.instance
          .collection('gatePassApplications')
          .doc(society)
          .collection('flatno')
          .doc(flatNo)
          .collection('gatePassType')
          .doc(provider.selectedPass)
          .collection('dateOfGatePass')
          .doc(date)
          .get();

      if (fetchallData.exists) {
        allGatePassData = fetchallData.data() as Map<String, dynamic>;
        print(' GatePass -  $allGatePassData');
      }
    } catch (e) {
      print("Error while fetching data $e");
    }
  }
}
