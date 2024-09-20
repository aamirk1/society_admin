// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Note/ParticularNoteList/ReceiptDebitNote.dart';
import 'package:society_admin/screens/Note/uploadNote/debitNoteExcel.dart';

class DebitNote extends StatefulWidget {
  final String societyName;

  static const id = "/DebitNote";
  const DebitNote({super.key, required this.societyName});

  @override
  State<DebitNote> createState() => _DebitNoteState();
}

class _DebitNoteState extends State<DebitNote> {
  final TextEditingController monthyears = TextEditingController();
  final TextEditingController _societyNameController = TextEditingController();
  bool isLoding = true;
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<String> dateList = [];
  List<dynamic> allMemberNameList = [];
  List<List<dynamic>> data = [];
  List<dynamic> mapData = [];
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());
  @override
  void initState() {
    fetchMap(widget.societyName, monthyear).whenComplete(() {
      setState(() {
        isLoding = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _societyNameController.dispose();
    monthyears.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          title: Text(
            "All Members Debit Note of ${widget.societyName}",
            style: const TextStyle(color: white),
          ),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [lightBlueColor, blueColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight))),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 150, right: 10.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DebitNoteExcel(societyName: widget.societyName),
                        ),
                      ).whenComplete(
                          () => fetchMap(widget.societyName, monthyear));
                    },
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: const TextStyle(color: Colors.white),
                            controller: monthyears,
                            decoration: const InputDecoration(
                                labelText: 'Selcet Month',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder())),
                        suggestionsCallback: (pattern) async {
                          return await getBillMonth(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            textColor: Colors.black,
                            title: Text(suggestion.toString()),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          monthyears.text = suggestion.toString();
                          fetchMap(widget.societyName, monthyears.text);
                        },
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 200,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: TypeAheadField(
                  //       textFieldConfiguration: TextFieldConfiguration(
                  //           controller: _societyNameController,
                  //           style: const TextStyle(color: Colors.white),
                  //           decoration: const InputDecoration(
                  //               labelText: 'Search Society',
                  //               labelStyle: TextStyle(color: Colors.white),
                  //               border: OutlineInputBorder())),
                  //       suggestionsCallback: (pattern) async {
                  //         return await getUserdata(pattern);
                  //       },
                  //       itemBuilder: (context, suggestion) {
                  //         return ListTile(
                  //           title: Text(suggestion.toString()),
                  //         );
                  //       },
                  //       onSuggestionSelected: (suggestion) {
                  //         _societyNameController.text = suggestion.toString();
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => customSocietySide(
                  //                 societyNames: suggestion.toString()),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  IconButton(
                    icon: Icon(
                      Icons.logout_rounded,
                      color: white,
                    ),
                    onPressed: () {
                      signOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: isLoding
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : allMemberNameList.isEmpty
                ? alertBox()
                : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: allMemberNameList.length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ListTile(
                                    title: Text(
                                      allMemberNameList[index],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReceiptDebitNote(
                                            societyName: widget.societyName,
                                            name: allMemberNameList[index],
                                            monthyear: monthyear,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ]);
                            }),
                      ),
                    )
                  ]),
      );

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    // print(searchedList.length);
    return searchedList;
  }

  Future<void> storeEditedData() async {
    List<Map<String, dynamic>> mapdata = [];
    Map<String, dynamic> temp = {};
    // print("data - $data");
    for (int i = 0; i < data[0].length; i++) {
      temp[columnName[i]] = columnName[i];
    }
    mapdata.add(temp);

    for (List<dynamic> listData in data) {
      Map<String, dynamic> tempMap = {};
      for (int i = 0; i < listData.length; i++) {
        tempMap[columnName[i]] = listData[i];
      }
      mapdata.add(tempMap);
    }
    // print(mapdata);

    FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .update({"data": mapdata}).whenComplete(
      () => const ScaffoldMessenger(
        child: SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Data Saved Successfully',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  Future<void> fetchMap(String societyName, String monthyear) async {
    setState(() {
      isLoding = true;
    });
    QuerySnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .collection('memberName')
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      List<dynamic> data1 = docSnapshot.docs.map((e) => e.id).toList();
      allMemberNameList = data1;
      // Use the data map as needed
    }
    setState(() {
      isLoding = false;
    });
  }

  getBillMonth(String pattern) async {
    dateList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        dateList.add(tempList[i]);
      } else {
        // dateList.add('Not Availabel');
      }
    }
    return dateList;
  }

  alertBox() {
    return const AlertDialog(
      title: Center(
          child: Text(
        'No Data Found',
        style: TextStyle(fontSize: 20, color: Colors.red),
      )),
    );
  }
}
