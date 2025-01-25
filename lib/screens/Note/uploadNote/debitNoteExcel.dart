import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';
// import '../excel/uploadExcel.dart';

class DebitNoteExcel extends StatefulWidget {
  static const String id = "/DebitNoteExcel";
  const DebitNoteExcel({super.key, required this.societyName});
  final String societyName;

  @override
  State<DebitNoteExcel> createState() => _DebitNoteExcelState();
}

class _DebitNoteExcelState extends State<DebitNoteExcel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController particularController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController debitNoteNumberController =
      TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController _controllerForUser = TextEditingController();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<dynamic> memberList = [];
  List<dynamic> allMemberList = [];
  String url = '';
  List<List<dynamic>> data = [];

  List<Map<String, dynamic>> newData = [];
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  // String monthyear = 'February 2024';
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());
  List<dynamic> mapData = [];
  bool showTable = false;
  bool isLoading = true;
  final List<String> flatNoList = [];
  String? selectedFlatNo;
  @override
  void initState() {
    print("This page running");
    // print(monthyear);
    fetchAllUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _societyNameController.dispose();
    particularController.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          title: Text(
            "Upload Debit Note of ${widget.societyName}",
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
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
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
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: white,
                    ),
                    onPressed: () {
                      signOut(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 40.0),
                            color: Colors.white,
                            height: 35,
                            width: 200,
                            child: Card(
                              elevation: 5.0,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select Flat No.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  items: flatNoList
                                      .map((item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedFlatNo,
                                  onChanged: (value) {
                                    print("onChange");
                                    setState(() {
                                      selectedFlatNo = value;
                                    });
                                    fetchMemberName(selectedFlatNo!);
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    decoration: BoxDecoration(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: 200,
                                  ),
                                  dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 200,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: textEditingController,
                                    searchInnerWidgetHeight: 50,
                                    searchInnerWidget: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 4,
                                        right: 8,
                                        left: 8,
                                      ),
                                      child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        controller: textEditingController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          hintText: 'Search for a flat no...',
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    searchMatchFn: (item, searchValue) {
                                      return item.value
                                          .toString()
                                          .contains(searchValue);
                                    },
                                  ),
                                  //This to clear the search value when you close the menu
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      textEditingController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                              color: Colors.white,
                              height: 35,
                              width: 800,
                              child: TextField(
                                readOnly: true,
                                controller: _controllerForUser,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    focusedBorder: OutlineInputBorder()),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  controller: debitNoteNumberController,
                                  decoration: const InputDecoration(
                                    hintText: "Note No.",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Credit Note No.';
                                    }
                                    return null;
                                  }),
                            ),
                            SizedBox(
                              width: 700,
                              height: 100,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  controller: particularController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Particular",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter particular';
                                    }
                                    return null;
                                  }),
                            ),
                            SizedBox(
                              width: 200,
                              height: 100,
                              child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Amount",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Amount';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(buttonColor),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              selectedFlatNo != null) {
                            await storeData();
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Please select Flat No. and fill all the fields',
                                    )));
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    // print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    // print(searchedList.length);
    return searchedList;
  }

  storeData() async {
    await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .collection('memberName')
        .doc(_controllerForUser.text)
        .collection('noteNumber')
        .doc(debitNoteNumberController.text)
        .set({
      'noteNumber': debitNoteNumberController.text,
      'Flat No.': selectedFlatNo,
      'particular': particularController.text,
      'amount': amountController.text,
      'month': monthyear,
      'date': DateTime.now().toString()
    }).then((value) {
      const ScaffoldMessenger(
          child: SnackBar(
        content: Text('Successfully Uploaded'),
      ));
    });
    FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .set({'month': monthyear});

    FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .collection('memberName')
        .doc(_controllerForUser.text)
        .set({'name': _controllerForUser.text});

    particularController.clear();
    amountController.clear();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<List<dynamic>> getMemberList(
    String pattern,
    String societyName,
  ) async {
    List<String> searchedList = [];
    for (var name in allMemberList) {
      if (name.toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(name);
      }
    }
    return searchedList;
  }

  Future<void> fetchAllUser() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(widget.societyName)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data1 =
          documentSnapshot.data() as Map<String, dynamic>;
      mapData = data1['data'];
    }

    for (int i = 1; i < mapData.length; i++) {
      allMemberList.add(mapData[i]['Member Name']);
      if (mapData[i]['Flat No.'] != null) {
        flatNoList.add(mapData[i]['Flat No.'].toString());
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future fetchMemberName(String flatNo) async {
    if (flatNo.isNotEmpty) {
      memberList.clear();
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(widget.societyName)
          .get();
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> allUserData = mapData['data'];

      for (dynamic data in allUserData) {
        final currentFlatNo = data['Flat No.'];
        if (currentFlatNo.toString() == flatNo.toString()) {
          memberList.add(data['Member Name']);
        }
      }
      _controllerForUser.text = memberList.isNotEmpty ? memberList[0] : '';
    } else {
      memberList.add(['Please select a flat number']);
    }

    setState(() {});
  }

  Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/',
    (route) => false,
  );
}
}
