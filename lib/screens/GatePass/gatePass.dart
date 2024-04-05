// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/gatePassProvider.dart';
import 'package:society_admin/authScreen/common.dart';
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

  String selectedFlatno = '';
  bool isClicked = false;
  bool isGatePassLoaded = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getFlatNum(widget.society).whenComplete(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GatePassProvider>(context, listen: false);

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
                                        widget.society,
                                        selectedFlatno,
                                      ).whenComplete(() {
                                        isGatePassLoaded = true;
                                        // isClicked = true;
                                        setState(() {});
                                      });
                                    },
                                    minVerticalPadding: 0.3,
                                    title: Center(
                                      child: Text(
                                        dataListOfFlatNo[index]['flatno'],
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
                Consumer(builder: ((context, value, child) {
                  return Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: 500,
                        child: TypeOfGatePass(
                          flatNo: selectedFlatno,
                          society: widget.society,
                          passType: dataListOfPassType,
                        ),
                      ));
                })),
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
                                      gatePassType: dataListOfPassType[
                                              globalSelectedIndexForGatePass]
                                          ['gatePassType'],
                                      text: dataListOfPassType[
                                              globalSelectedIndexForGatePass]
                                          ['text'],
                                      society: widget.society,
                                      flatNo: selectedFlatno,
                                    )
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
    isLoading = true;
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('gatePassApplications')
        .doc(selectedSociety)
        .collection('flatno')
        .get();

    List<dynamic> allFlat =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();

    // ignore: unused_local_variable
    dataListOfFlatNo = allFlat;
    setState(() {
      isLoading = false;
    });
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
  }
}
