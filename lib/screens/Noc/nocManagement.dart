// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/nocManagementProvider.dart';
import 'package:society_admin/authScreen/common.dart';
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
  List<dynamic> dataList = [];
  List<dynamic> dataListOfNocType = [];
  String selectedFlatno = '';
  bool isNocLoaded = false;

  bool isLoading = true;
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
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                            child: Card(
                              color: primaryColor,
                              elevation: 5,
                              child: Container(
                                alignment: Alignment.center ,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ListTile(
                                    onTap: () {
                                      selectedFlatno =
                                          dataList[index]['flatno'];
                                      getTypeOfNoc(
                                              widget.society, selectedFlatno)
                                          .whenComplete(() {
                                        isNocLoaded = true;
                                        setState(() {});
                                      });
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) {
                                      //     return TypeOfNoc(
                                      //       society: widget.society,
                                      //       flatNo: dataList[index]['flatno'],
                                      //       userId: widget.userId,
                                      //     );
                                      //   }),
                                      // );
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
                      child: TypeOfNoc(
                        nocTypeList: dataListOfNocType,
                        flatNo: selectedFlatno,
                        society: widget.society,
                        userId: widget.userId,
                      ),
                    )),
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
                                        nocType: dataListOfNocType[
                                            globalSelectedIndex]['nocType'],
                                        text: dataListOfNocType[
                                            globalSelectedIndex]['text'],
                                        society: widget.society,
                                        flatNo: selectedFlatno,
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

  Future<void> getTypeOfNoc(society, flatNo) async {
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
    dataListOfNocType = allNocType;
    if (kDebugMode) {
      print('dataList $dataListOfNocType');
    }
  }
}
