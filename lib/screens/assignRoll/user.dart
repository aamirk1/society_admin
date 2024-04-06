// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/filteration_provider.dart';
import 'package:society_admin/Provider/menuUserPageProvider.dart';
import 'package:society_admin/authScreen/common.dart';

import '../../authScreen/loginScreen.dart';
import 'menu_screen/assigned_user.dart';
import 'menu_screen/totalUser.dart';
import 'menu_screen/unAssignedUserPage.dart';

class MenuUserPage extends StatefulWidget {
  static const String id = 'user-page';
  MenuUserPage({super.key, required this.society, required this.userId});
  final String society;
  String userId;

  @override
  State<MenuUserPage> createState() => _MenuUserPageState();
}

class _MenuUserPageState extends State<MenuUserPage> {
  final TextEditingController _controllerSociety = TextEditingController();
  final TextEditingController _controllerForUser = TextEditingController();
  String selectedUserId = '';
  List<String> searchedList = [];

  // Boolean value fro updating and setting user role in database
  bool userExist = false;
  List<dynamic> societyList = [];
  List<dynamic> memberList = [];
  List<String> assignedUserList = [];
  int assignedUsers = 0;
  int totalUsers = 0;
  List<dynamic> unAssignedUserList = [];
  int unAssignedUser = 0;
  String selectedUserName = '';
  List<bool> changeColorForDepo = [];
  List<dynamic> selectedDepo = [];
  List<dynamic> selecteddesignation = [];
  List<dynamic> selectedCity = [];
  List<dynamic> role = [];
  List<bool> changeColorForRole = [];
  List<bool> changeColorForCity = [];
  List<bool> isRemoveDepo = [];
  List<String> cityData = [];
  Stream? _stream;
  bool showError = false;
  String errorMessage = '';
  bool isLoading = true;
  bool getDepooData = false;
  TextEditingController unAssignedUserController = TextEditingController();

  List<String> designation = ['Admin', 'Secretary', 'Treasurer'];

  List<String> cardTitle = [
    'Total User',
    'Assigned User',
    'Unassigned User',
  ];

  List<Color> cardColor = [
    const Color.fromARGB(255, 57, 177, 63),
    const Color.fromARGB(255, 76, 123, 250),
    const Color.fromARGB(255, 207, 45, 24),
  ];

  List<dynamic> depodata = [];
  bool isProjectManager = false;

  TextEditingController myController = TextEditingController();

  @override
  void initState() {
    // getCityName().whenComplete(() => {
    //       isLoading = false,
    //       getCityLen(),
    //       if (mounted) {setState(() {})}
    //     });
    getDesigationLen();
    getTotalUsers().whenComplete(() => {
          isLoading = false,
          if (mounted) {setState(() {})}
        });

    _stream = FirebaseFirestore.instance
        .collection('User')
        .orderBy('FirstName')
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String selectedSocietyName = widget.society;
    final provider = Provider.of<MenuUserPageProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryColor),
        title: Text(widget.society),
        backgroundColor: primaryColor,
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
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width * 0.98,
              height: MediaQuery.of(context).size.height * 0.99,
              child: Column(
                children: [
                  Consumer<MenuUserPageProvider>(
                    builder: (context, providerValue, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          UserCard(context, totalUsers, cardTitle[0],
                              cardColor[0], const TotalUsers()),
                          UserCard(
                              context,
                              assignedUsers,
                              cardTitle[1],
                              cardColor[1],
                              AssignedUser(society: widget.society)),
                          UserCard(context, unAssignedUser, cardTitle[2],
                              cardColor[2], const UnAssingedUsers()),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    // height: MediaQuery.of(context).size.height * 0.7,
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 63, 155, 221),
                              ),
                              padding: const EdgeInsets.only(left: 10.0),
                              child: getDepooData
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: TextButton(
                                                    style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.yellow)),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Select Member: ',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Consumer<MenuUserPageProvider>(
                                                builder: (context,
                                                    providerValue, child) {
                                                  return Container(
                                                    color: Colors.white,
                                                    height: 30,
                                                    width: 260,
                                                    child: TypeAheadField(
                                                      hideOnLoading: true,
                                                      textFieldConfiguration:
                                                          TextFieldConfiguration(
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                        controller:
                                                            _controllerForUser,
                                                        decoration: const InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            labelText:
                                                                'Select Member',
                                                            labelStyle: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: Colors
                                                                    .black),
                                                            border:
                                                                OutlineInputBorder()),
                                                      ),
                                                      itemBuilder: (context,
                                                          suggestion) {
                                                        return ListTile(
                                                          title: Text(
                                                            suggestion
                                                                .toString(),
                                                          ),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (suggestion) async {
                                                        _controllerForUser
                                                                .text =
                                                            suggestion
                                                                .toString();

                                                        await getDataId(
                                                                suggestion
                                                                    .toString())
                                                            .whenComplete(
                                                                () {});

                                                        selectedUserName =
                                                            suggestion
                                                                .toString();
                                                        checkUserAlreadyExist(
                                                                selectedUserName)
                                                            .then((value) {
                                                          providerValue
                                                              .setLoadWidget(
                                                                  true);
                                                        });
                                                      },
                                                      suggestionsCallback:
                                                          (String
                                                              pattern) async {
                                                        return await getMemberList(
                                                            pattern);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                width: 65,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: 130,
                                                child: ElevatedButton(
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.green)),
                                                  onPressed: () async {
                                                    for (int i = 0;
                                                        i < assignedUsers;
                                                        i++) {
                                                      if (assignedUserList[i] ==
                                                          selectedUserName) {
                                                        // isDefined = true;
                                                      }
                                                    }

                                                    if (selectedUserName !=
                                                        selectedSocietyName) {
                                                      role.isEmpty
                                                          ? customAlertBox(
                                                              'Please Select Designation')
                                                          : selectedSocietyName
                                                                  .isEmpty
                                                              ? customAlertBox(
                                                                  'Please Select Society')
                                                              : storeAssignData();
                                                      getTotalUsers()
                                                          .whenComplete(
                                                              () async {
                                                        DocumentReference
                                                            documentReference =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'unAssignedRole')
                                                                .doc(
                                                                    selectedUserName);

                                                        await documentReference
                                                            .delete();

                                                        provider.setLoadWidget(
                                                            true);
                                                      });
                                                      // } else {
                                                      //   customAlertBox(
                                                      //       '$selectedUserName is Already Assigned a Role');
                                                      // }
                                                    } else if (selectedUserName
                                                            .isEmpty &&
                                                        selectedSocietyName
                                                            .isEmpty) {
                                                      customAlertBox(
                                                          'Please Select Member and User');
                                                    } else {
                                                      customAlertBox(
                                                          'Reporting Manager and User cannot be same');
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Assign Role',
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Consumer<MenuUserPageProvider>(
                                          builder: (context, value, child) {
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 500),
                                                  child: showError
                                                      ? Text(
                                                          errorMessage,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        )
                                                      : const Text(''),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              top: 10.0,
                                              bottom: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: SizedBox(
                                                  width: 130,
                                                  child: TextButton(
                                                    style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.yellow)),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Designation :',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Consumer<MenuUserPageProvider>(
                                                builder: (BuildContext context,
                                                    providerValue,
                                                    Widget? child) {
                                                  return SizedBox(
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: GridView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            designation.length,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    6,
                                                                crossAxisSpacing:
                                                                    10.0,
                                                                mainAxisSpacing:
                                                                    5.0,
                                                                mainAxisExtent:
                                                                    30,
                                                                childAspectRatio:
                                                                    9.0),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(changeColorForRole[
                                                                            index]
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .lightGreen)),
                                                            onPressed: () {
                                                              if (designation[
                                                                      index] ==
                                                                  'Others') {
                                                              } else {
                                                                if (designation[
                                                                        index] ==
                                                                    'Project Manager') {
                                                                  isProjectManager =
                                                                      true;
                                                                } else {
                                                                  isProjectManager =
                                                                      false;
                                                                }

                                                                changeColorForRole[
                                                                        index] =
                                                                    !changeColorForRole[
                                                                        index];
                                                                insertSelectedRole(
                                                                    index);
                                                                providerValue
                                                                    .setLoadWidget(
                                                                        true);
                                                              }
                                                            },
                                                            child: Text(
                                                              designation[
                                                                  index],
                                                              style: TextStyle(
                                                                  color: changeColorForRole[
                                                                          index]
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  fontSize: 9),
                                                            ),
                                                          );
                                                        }),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  //Calculating Total users for additional screen
  Future<void> getTotalUsers() async {
    await getAssignedUsers();
    await getUnAssignedUser();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('TotalUsers').get();
    totalUsers = querySnapshot.docs.length;
  }

//Function for changing designation roles button color on tap
  void getDesigationLen() {
    List<bool> tempBool = [];
    for (int i = 0; i < designation.length; i++) {
      tempBool.add(true);
    }
    changeColorForRole = tempBool;
  }

  void getCityLen() {
    List<bool> tempBool = [];
    for (int i = 0; i < cityData.length; i++) {
      tempBool.add(true);
    }
    changeColorForCity = tempBool;
  }

//Function for changing depo name button color on tap
  void getDepoLen() {
    List<bool> tempListForDepo = [];
    for (int i = 0; i < depodata.length; i++) {
      tempListForDepo.add(true);
    }
    changeColorForDepo = tempListForDepo;
  }

  void insertSelectedRole(int currentIndex) {
    if (changeColorForRole[currentIndex] == false) {
      role.add(designation[currentIndex]);
    } else if (changeColorForRole[currentIndex] == true) {
      role.remove(designation[currentIndex]);
    }
  }

  void insertSelectedDepo(int currentIndex) {
    if (changeColorForDepo[currentIndex] == false) {
      selectedDepo.add(depodata[currentIndex]);
    } else if (changeColorForDepo[currentIndex] == true) {
      selectedDepo.remove(depodata[currentIndex]);
    }
  }

  void insertSelectedCity(int currentIndex) {
    if (changeColorForCity[currentIndex] == false) {
      selectedCity.add(cityData[currentIndex]);
    } else if (changeColorForCity[currentIndex] == true) {
      selectedCity.remove(cityData[currentIndex]);
    }
  }

//Function to fetch depo name when any city name is clicked on the pag C

  getUserdata(String input) async {
    searchedList.clear();
    getSocietyList();
    for (int i = 0; i < societyList.length; i++) {
      if (societyList[i].toUpperCase().startsWith(input.toUpperCase())) {
        searchedList.add(societyList[i]);
      }
    }
    societyList.clear();
    return searchedList;
  }

  Future<void> getUnAssignedUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('unAssignedRole').get();

    unAssignedUserList = querySnapshot.docs.map((e) => e.id).toList();
    unAssignedUser = querySnapshot.docs.length;
    unAssignedUserController.text = unAssignedUser.toString();
  }

  //Storing data in firebase
  Future<void> storeAssignData() async {
    if (userExist) {
      updateUserData(selectedUserName);
    } else {
      String phoneNum = await getPhoneNumber(selectedUserName);
      await FirebaseFirestore.instance
          .collection('AssignedRole')
          .doc(selectedUserName)
          .set({
        "fullName": selectedUserName,
        "phoneNum": phoneNum,
        'alphabet': selectedUserName[0][0].toUpperCase(),
        'position': 'Assigned',
        'roles': role,
        // 'depots': selectedDepo,
        'societyname': widget.society,
        // 'cities': selectedCity,
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Center(child: Text('Role Assigned Successfully')),
        ));
      });

      await FirebaseFirestore.instance
          .collection('TotalUsers')
          .doc(selectedUserName)
          .set({
        // 'userId': selectedUserId,
        'alphabet': selectedUserName[0][0].toUpperCase(),
        'position': 'Assigned',
        'roles': role,
        // 'depots': selectedDepo,
        'societyname': widget.society,
        // 'cities': selectedCity,
      });
    }
  }

  Future getPhoneNumber(String selectedUser) async {
    String phoneNum = '';
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("members")
        .doc(widget.society)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> allUserMapData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> allUserData = allUserMapData["data"];

      for (int i = 0; i < allUserData.length; i++) {
        if (allUserData[i]['Member Name'] == selectedUser) {
          phoneNum = allUserData[i]['Mobile No.'];
        }
      }
      print("MobileNum - $phoneNum");
    }
    if (phoneNum.isEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("societyAdmin")
          .where("fullName", isEqualTo: selectedUser)
          .get();
      List<dynamic> adminData =
          querySnapshot.docs.map((e) => e.data()).toList();

      phoneNum = adminData[0]['mobile'];
    }
    return phoneNum;
  }

  Future<List<dynamic>> getAssignedUsers() async {
    assignedUserList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('societyname', isEqualTo: widget.society)
        .get();

    assignedUserList = querySnapshot.docs.map((e) => e.id).toList();
    assignedUsers = querySnapshot.docs.length;
    // print('aasasasasasasasa -  $assignedUsers');
    return assignedUserList;
  }

  // ignore: non_constant_identifier_names
  UserCard(BuildContext context, int number, String title, Color color,
      Widget name) {
    final menuProvider =
        Provider.of<MenuUserPageProvider>(context, listen: true);
    return Column(
      children: [
        Container(
          width: 300,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '$number',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(title,
                    style: const TextStyle(fontSize: 13, color: Colors.white)),
              ]),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(providers: [
                          ChangeNotifierProvider(
                              create: (context) => MenuUserPageProvider()),
                          ChangeNotifierProvider(
                            create: (context) => FilterProvider(),
                          )
                        ], child: name);
                      })).then((value) {
                        getTotalUsers().whenComplete(() async {
                          isRemoveDepo =
                              List.generate(cityData.length, (index) => true);
                          errorMessage = '';
                          _controllerSociety.text = '';
                          _controllerForUser.text = '';
                          isProjectManager = false;
                          getDepoLen();
                          getCityLen();
                          getDesigationLen();
                          selectedDepo.clear();
                          role.clear();
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                    ),
                    child: const Text('More Info'),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.forward),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<void> checkUserAlreadyExist(String username) async {
    showError = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('societyname', isEqualTo: widget.society)
        .get();
    List<dynamic> assignedUsers = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < assignedUsers.length; i++) {
      if (assignedUsers[i].toString().toUpperCase().trim() ==
          username.toUpperCase().trim()) {
        showError = true;
        errorMessage = 'Warning! User Already Assigned A Role';
        userExist = true;
      }
    }
  }

  Future<void> updateUserData(String username) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .doc(username)
        .get();

    List<dynamic> updatedRole = [];
    List<dynamic> updatedDepo = [];
    List<dynamic> updatedCity = [];

    Map<String, dynamic> tempData =
        documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> presentRoles = tempData['roles'];
    List<dynamic> presentDepots = tempData['depots'];
    List<dynamic> presentCities = tempData['cities'];

    updatedRole = presentRoles + role;
    updatedDepo = presentDepots + selectedDepo;
    updatedCity = presentCities + selectedCity;

    updatedRole = updatedRole.toSet().toList();
    updatedDepo = updatedDepo.toSet().toList();
    updatedCity = updatedCity.toSet().toList();

    await FirebaseFirestore.instance
        .collection('AssignedRole')
        .doc(selectedUserName)
        .update({
      'username': selectedUserName.trim(),
      'userId': selectedUserId,
      'alphabet': selectedUserName[0][0].toUpperCase(),
      'position': 'Assigned',
      'roles': updatedRole,
      'depots': updatedDepo,
      'society': widget.society,
      'cities': updatedCity,
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Role Assigned Successfully'),
      ));
    });

    await FirebaseFirestore.instance
        .collection('TotalUsers')
        .doc(selectedUserName)
        .update({
      'userId': selectedUserId,
      'alphabet': selectedUserName[0][0].toUpperCase(),
      'position': 'Assigned',
      'roles': updatedRole,
      'depots': updatedDepo,
      'society': widget.society,
      'cities': updatedCity,
    }).whenComplete(() {
      updatedCity.clear();
      updatedDepo.clear();
      updatedRole.clear();
    });
    // print('Updated');
  }

  customAlertBox(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor: Colors.white,
            icon: const Icon(
              Icons.warning_amber,
              size: 45,
              color: Colors.red,
            ),
            title: Text(
              message,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 14, letterSpacing: 2),
            ),
          );
        });
  }

  Future<String> getSelectedUserId(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('FirstName', isEqualTo: username)
        .get();

    List<dynamic> tempData = querySnapshot.docs.map((e) => e.data()).toList();
    Map<String, dynamic> data = tempData[0];

    selectedUserId = data['Employee Id'];

    return selectedUserId;
  }

  Future<void> getDataId(String username) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < tempList.length; i++) {
      if (username
          .toString()
          .toUpperCase()
          .trim()
          .startsWith(tempList[i].toUpperCase().trim())) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc('${tempList[i]}')
            .get();

        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        selectedUserId = data['Employee Id'];
      }
    }
  }

  Future<void> getSocietyList() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();
    List<dynamic> temp = querySnapshot.docs.map((e) => e.id).toList();
    societyList = temp;
  }

  Future<List<dynamic>> getMemberList(String pattern) async {
    List<String> searchedList = [];
    QuerySnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('unAssignedRole').get();
    memberList = documentSnapshot.docs.map((e) => e.id).toList();

    for (var member in memberList) {
      if (member
          .toString()
          .trim()
          .toLowerCase()
          .contains(pattern.trim().toLowerCase())) {
        searchedList.add(member);
      }
    }

    return searchedList;
  }
}

Widget searchWidget(String text) {
  return ListTile(
    title: Text(
      text.length > 4 ? text.substring(0, 4) : text,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
    ),
    subtitle: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
        color: Colors.black26,
      ),
    ),
  );
}
