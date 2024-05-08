import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/menuUserPageProvider.dart';
import 'package:society_admin/Provider/role_page_total_number_provider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/assignRoll/menu_screen/assigned_user.dart';

// ignore: must_be_immutable
class RoleScreen extends StatefulWidget {
  // String society;
  RoleScreen({super.key, required this.society, required this.userId});
  final String society;
  String userId;
  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  bool isSelectAllDepots = false;
  int assignedUsers = 0;
  List<String> assignedUserList = [];
  int totalUsers = 0;
  List<dynamic> unAssignedUserList = [];
  TextEditingController unAssignedUserController = TextEditingController();
  String selectedUserId = '';
  bool isLoading = true;
  List<String> unAssignedUsersList = [];
  List<String> memberList = [];
  String selectedUserName = '';
  List<dynamic> role = [];

  final TextEditingController citiesController = TextEditingController();
  final TextEditingController reportingManagerController =
      TextEditingController();
  final TextEditingController selectedUserController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController depotController = TextEditingController();
  String messageForSocietyMember = '';

  List<String> gridTabLabels = [
    'Assigned',
  ];

  List<String> designationList = ['Admin', 'Secretary', 'Treasurer'];

  String? selectedUser;
  String? selectedCity;
  String? selectedDesignation;
  String? selectedReportingManager;
  String? selectedDepot;

  List<String> selectedDesignationList = [];
  List<String> selectedCitiesList = [];
  List<String> selectedDepotList = [];
  int unAssignedUser = 0;

  List<String> allUserList = [];
  List<String> allCityList = [];
  List<String> allDepotList = [];

  @override
  void initState() {
    fetchCompleteUserList().whenComplete(() async {
      await getMemberList();
      await getTotalUsers();
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    citiesController.dispose();
    reportingManagerController.dispose();
    selectedUserController.dispose();
    designationController.dispose();
    depotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedSocietyName = widget.society;
    final provider = Provider.of<MenuUserPageProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Role Management",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //EV PMIS

                    Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              52,
                              91,
                              199,
                            ),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: const Text(
                              "Society Users",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(
                                    255,
                                    52,
                                    91,
                                    199,
                                  ),
                                  letterSpacing: 1.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 80,
                            child: GridView.builder(
                                itemCount: 3,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 3.5,
                                ),
                                itemBuilder: (context, index) {
                                  return Consumer<
                                      RolePageTotalNumProviderAdmin>(
                                    builder: (context, value, child) {
                                      return gridTabs(
                                        index,
                                        const Color.fromARGB(
                                          255,
                                          52,
                                          91,
                                          199,
                                        ),
                                        assignedUsers,
                                        AssignedUser(
                                          society: widget.society,
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(
                      255,
                      208,
                      232,
                      253,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Card(
                            elevation: 5.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  3.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              height: 35,
                              width: 180,
                              child: const Text(
                                "Select Member:",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                customDropDown('Select Member', false,
                                    memberList, "Search Reporting Manager", 0),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    messageForSocietyMember,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customDropDown(
                                'Select Designation',
                                true,
                                designationList,
                                "Search Designation",
                                2,
                              ),
                              Container(),
                            ],
                          ),
                          customShowBox(
                            selectedDesignationList,
                            0.6,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 50.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(
                                    255,
                                    47,
                                    173,
                                    74,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                for (int i = 0; i < assignedUsers; i++) {
                                  if (assignedUserList[i] == selectedUserName) {
                                    // isDefined = true;
                                  }
                                }

                                if (selectedUserName != selectedSocietyName) {
                                  role.isEmpty
                                      ? customAlertBox(
                                          'Please Select Designation')
                                      : selectedSocietyName.isEmpty
                                          ? customAlertBox(
                                              'Please Select Society')
                                          : storeAssignData();
                                  getTotalUsers().whenComplete(() async {
                                    DocumentReference documentReference =
                                        FirebaseFirestore.instance
                                            .collection('unAssignedRole')
                                            .doc(selectedUserName);

                                    await documentReference.delete();

                                    provider.setLoadWidget(true);
                                  });
                                } else if (selectedUserName.isEmpty &&
                                    selectedSocietyName.isEmpty) {
                                  customAlertBox(
                                      'Please Select Member and User');
                                } else {
                                  customAlertBox(
                                      'Reporting Manager and User cannot be same');
                                }
                              },
                              child: const Text(
                                'Assign Role',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Future<void> fetchCompleteUserList() async {
    // QuerySnapshot adminQuery =
    //     await FirebaseFirestore.instance.collection('Admin').get();
    // List<String> adminList = adminQuery.docs.map((e) => e.id).toList();

    QuerySnapshot userQuery =
        await FirebaseFirestore.instance.collection('User').get();
    List<String> userList = userQuery.docs.map((e) => e.id).toList();

    allUserList = userList;

    QuerySnapshot cityQuery =
        await FirebaseFirestore.instance.collection('DepoName').get();
    List<String> cityList = cityQuery.docs.map((e) => e.id).toList();

    allCityList = cityList;
  }

  Widget gridTabs(int index, Color cardColor, int headerNum, Widget screen) {
    final totalValueProvider =
        Provider.of<RolePageTotalNumProviderAdmin>(context, listen: false);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
      child: Card(
        color: cardColor,
        elevation: 5,
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              margin: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headerNum.toString(), //O&M value
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                      Text(
                        gridTabLabels[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Card(
                      elevation: 5.0,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => screen,
                            ),
                          ).whenComplete(() {
                            getTotalUsers().whenComplete(() {
                              totalValueProvider.reloadTotalNum(true);
                            });
                          });
                        },
                        child: Text(
                          'More Info',
                          style: TextStyle(fontSize: 12, color: cardColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customDropDown(String title, bool isMultiCheckbox,
      List<String> customDropDownList, String hintText, int index) {
    return Card(
      elevation: 5.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(
            3.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 180,
              height: 30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownSearchData: DropdownSearchData(
                    searchController: index == 0
                        ? reportingManagerController
                        : index == 1
                            ? selectedUserController
                            : index == 2
                                ? designationController
                                : index == 3
                                    ? citiesController
                                    : depotController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: index == 4 ? 90 : 42,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            width: 160,
                            height: 30,
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: index == 0
                                  ? reportingManagerController
                                  : index == 1
                                      ? selectedUserController
                                      : index == 2
                                          ? designationController
                                          : index == 3
                                              ? citiesController
                                              : depotController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                hintText: hintText,
                                hintStyle: const TextStyle(
                                  fontSize: 11,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (index == 4)
                            InkWell(
                              onTap: () {
                                isSelectAllDepots = !isSelectAllDepots;

                                if (isSelectAllDepots) {
                                  selectedDepotList.clear();
                                  customDropDownList.forEach((element) {
                                    selectedDepotList.add(element);
                                  });
                                } else {
                                  selectedDepotList.clear();
                                }
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                    value: isSelectAllDepots,
                                    onChanged: (value) {},
                                  ),
                                  const Text(
                                    "All Depots",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  value: index == 0
                      ? selectedReportingManager
                      : index == 1
                          ? selectedUser
                          : index == 2
                              ? selectedDesignation
                              : index == 3
                                  ? selectedCity
                                  : selectedDepot,
                  isExpanded: true,
                  onMenuStateChange: (isOpen) {
                    if (index == 0) messageForSocietyMember = "";
                    index == 3
                        ? selectedCitiesList.isEmpty
                            ? allDepotList.clear()
                            : () {}
                        : () {};
                    setState(() {});
                  },
                  // selectedItemBuilder: (context) {
                  //   return [
                  //     Text(
                  //       title,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 11,
                  //         color: white,
                  //       ),
                  //       textAlign: TextAlign.left,
                  //     ),
                  //   ];
                  // },
                  hint: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  items: isMultiCheckbox
                      ? customDropDownList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            enabled: false,
                            child: StatefulBuilder(
                              builder: (context, menuSetState) {
                                bool isSelected = index == 2
                                    ? selectedDesignationList.contains(item)
                                    : index == 3
                                        ? selectedCitiesList.contains(item)
                                        : selectedDepotList.contains(item);

                                return InkWell(
                                  onTap: () async {
                                    switch (isSelected) {
                                      case true:
                                        if (isSelectAllDepots) {
                                          isSelectAllDepots =
                                              !isSelectAllDepots;
                                        }
                                        index == 2
                                            ? selectedDesignationList
                                                .remove(item)
                                            : index == 3
                                                ? selectedCitiesList
                                                    .remove(item)
                                                : selectedDepotList
                                                    .remove(item);
                                        break;
                                      case false:
                                        index == 2
                                            ? selectedDesignationList.add(item)
                                            : index == 3
                                                ? selectedCitiesList.add(item)
                                                : selectedDepotList.add(item);
                                        break;
                                    }
                                    index == 3 ? allDepotList.clear() : () {};
                                    index == 3
                                        ? await fetchDepotList(
                                            selectedCitiesList.length,
                                          )
                                        : () {};
                                    setState(() {});
                                    menuSetState(() {});
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        isSelected
                                            ? const Icon(
                                                Icons.check_box_outlined,
                                                size: 20,
                                              )
                                            : const Icon(
                                                Icons.check_box_outline_blank,
                                                size: 20,
                                              ),
                                        const SizedBox(width: 3),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList()
                      : customDropDownList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          .toList(),
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 300,
                  ),
                  onChanged: (value) {
                    index == 0
                        ? selectedReportingManager = value
                        : index == 1
                            ? selectedUser = value
                            : index == 2
                                ? selectedDesignation = value
                                : selectedCity = value;
                    if (index == 1) {
                    } else if (index == 0) {
                      messageForSocietyMember = 'Society Manager Selected ✔';
                    }
                  },
                  iconStyleData: const IconStyleData(
                    iconDisabledColor: Colors.blue,
                    iconEnabledColor: Colors.blue,
                  ),
                  buttonStyleData: const ButtonStyleData(
                    elevation: 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<void> fetchDepotList(int cityListLen) async {
    if (cityListLen != 0) {
      for (int i = 0; i < cityListLen; i++) {
        QuerySnapshot depotQuery = await FirebaseFirestore.instance
            .collection('DepoName')
            .doc(selectedCitiesList[i])
            .collection('AllDepots')
            .get();

        List<String> depotList = depotQuery.docs.map((e) => e.id).toList();
        allDepotList = allDepotList + depotList;
      }
    }
  }

  Future customAlert() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.all(5.0),
            iconPadding: const EdgeInsets.all(5.0),
            contentPadding: const EdgeInsets.all(10.0),
            elevation: 10,
            content: const Text(
              "Please Select Admin as Designation to Approve",
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
            backgroundColor: Colors.white,
            icon: const Icon(
              Icons.warning_amber,
              size: 60.0,
              color: Colors.blue,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue)),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          );
        });
  }

  //Storing data in firebase
  Widget customShowBox(List<String> buildList, double widhtSize) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      height:
          buildList.length > 6 ? MediaQuery.of(context).size.height * 0.13 : 40,
      width: MediaQuery.of(context).size.width * widhtSize,
      child: GridView.builder(
          itemCount: buildList.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 4.5,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 3.0,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      2.0,
                    ),
                    border: Border.all(
                      color: Colors.blue,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    buildList[index],
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<void> storeAssignData() async {
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

  //Calculating Total users for additional screen
  Future<void> getTotalUsers() async {
    await getAssignedUsers();
    await getUnAssignedUser();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('TotalUsers').get();
    totalUsers = querySnapshot.docs.length;
  }

  Future<void> getUnAssignedUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('unAssignedRole').get();
    unAssignedUserList = querySnapshot.docs.map((e) => e.id).toList();
    unAssignedUser = querySnapshot.docs.length;

    unAssignedUserController.text = unAssignedUser.toString();
  }

  Future<List<dynamic>> getAssignedUsers() async {
    assignedUserList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('societyname', isEqualTo: widget.society)
        .get();

    assignedUserList = querySnapshot.docs.map((e) => e.id).toList();
    assignedUsers = querySnapshot.docs.length;
    print("assignedUser - $assignedUsers");
    // print('aasasasasasasasa -  $assignedUsers');
    return assignedUserList;
  }

  Future<void> getMemberList() async {
    QuerySnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('unAssignedRole').get();
    memberList = documentSnapshot.docs.map((e) => e.id).toList();
  }
}
