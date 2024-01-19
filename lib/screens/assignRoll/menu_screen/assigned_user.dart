import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/filteration_provider.dart';
import 'package:society_admin/authScreen/common.dart';

import 'LoadingForMenuUser.dart';

class AssignedUser extends StatefulWidget {
  const AssignedUser({super.key, required this.society});
  final String society;

  @override
  State<AssignedUser> createState() => _AssignedUserState();
}

class _AssignedUserState extends State<AssignedUser> {
  bool showText = false;
  bool isLoading = true;
  List<Widget> filterChips = [];
  List<bool> selectedDesign = [];
  String selectedAlphabet = 'All';
  bool showAll = true;
  String alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  void initState() {
    setColor();
    selectedDesign[26] = !selectedDesign[26];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FilterProvider>(context, listen: true);
    return isLoading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50),
              child: AppBar(
                  title: Text(
                    'Assigned Members',
                    style: TextStyle(color: secondaryColor),
                  ),
                  backgroundColor: primaryColor),
            ),
            body: Column(
              children: [
                Consumer<FilterProvider>(
                  builder: (context, value, child) {
                    return Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 5.0),
                      width: MediaQuery.of(context).size.width * 0.97,
                      height: 50,
                      child: Row(
                        children: [
                          Card(
                            elevation: selectedDesign[26] ? 5 : 0,
                            shadowColor: Colors.black,
                            child: SizedBox(
                              height: 32,
                              width: 60,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                    selectedDesign[26]
                                        ? Colors.grey
                                        : Colors.black,
                                  )),
                                  onPressed: () {
                                    setColor();
                                    selectedDesign[26] = !selectedDesign[26];
                                    selectedAlphabet = 'All';
                                    showAll = true;
                                    provider.setReloadWidget(true);
                                  },
                                  child: const Text(
                                    'All',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: alpha.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: selectedDesign[index] ? 5 : 0,
                                  child: SizedBox(
                                    width: 40,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                        selectedDesign[index]
                                            ? Colors.grey
                                            : Colors.black,
                                      )),
                                      onPressed: () {
                                        setColor();
                                        selectedDesign[index] =
                                            !selectedDesign[index];
                                        selectedAlphabet = alpha[index];
                                        showAll = false;
                                        provider.setReloadWidget(true);
                                      },
                                      child: Text(
                                        alpha[index],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                StreamBuilder(
                    stream: showAll
                        ? FirebaseFirestore.instance
                            .collection('AssignedRole')
                            .where('societyname', isEqualTo: widget.society)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('AssignedRole')
                            .where('alphabet', isEqualTo: selectedAlphabet)
                            .where('societyname', isEqualTo: widget.society)
                            .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingForMenuUser();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error Occured'),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('No Data Available'),
                        );
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        List<dynamic> user =
                            data!.docs.map((e) => e.id).toList();

                        return SingleChildScrollView(
                          child: Consumer<FilterProvider>(
                            builder: (context, value, child) {
                              return Container(
                                padding: const EdgeInsets.all(5.0),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.width * 0.39,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 240,
                                          childAspectRatio: 6,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 10,
                                          mainAxisExtent: 310),
                                  itemCount: user.length,
                                  itemBuilder: (context, index) {
                                    List<dynamic> roles =
                                        data.docs[index]['roles'];
                                    // List<dynamic> cities =
                                    //     data.docs[index]['cities'];
                                    // List<dynamic> depots =
                                    //     data.docs[index]['depots'];
                                    String societyname =
                                        data.docs[index]['societyname'];

                                    return InkWell(
                                      onTap: () {
                                        customDialogBox(
                                            user[index], roles, societyname);
                                      },
                                      child: customCard(user[index], index,
                                          roles, societyname),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Container();
                    })),
              ],
            ));
  }

  Widget customRowBuilder(List<String> data) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.circle_rounded,
                    size: 5,
                  ),
                ),
                Text(
                  data[index],
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        });
  }

  Widget customRowBuilderForDialog(List<dynamic> inputList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: inputList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.circle_rounded,
                    size: 10,
                  ),
                ),
                Text(
                  inputList[index],
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget customRowGridBuilder(List<dynamic> inputList) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            childAspectRatio: 10.0,
            mainAxisSpacing: 10),
        itemCount: inputList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(border: Border.all()),
            child: Text(
              inputList[index],
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  Widget customCard(String user, int index, List<dynamic> selectedRole,
      String currentReportingmanager) {
    return Card(
      elevation: 15,
      child: Container(
        // decoration: BoxDecoration(
        //     image: const DecorationImage(
        //         image: AssetImage('assets/tata_power_card.jpeg'),
        //         fit: BoxFit.cover),
        //     borderRadius: BorderRadius.circular(10.0)),
        height: 260,
        width: 180,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 2.0, bottom: 10.0, right: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      user.split("&")[0].toString(),
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(255, 241, 237, 238),
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 5,
                                        top: 10),
                                    height: 250,
                                    width: 390,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.warning_amber,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Are you sure you want to delete "$user" from his role?',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.redAccent)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Color.fromARGB(255,
                                                                67, 182, 126))),
                                                onPressed: () {
                                                  removeRole(user);

                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Confirm',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.red,
                          size: 18,
                        )),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.person_2_sharp,
                  color: Colors.blue[900],
                  size: 14,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'Designation',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontSize: 12),
                  ),
                )
              ],
            ),
            customRowBuilder([
              selectedRole[0].isNotEmpty ? selectedRole[0] : '',
              selectedRole.length > 1 ? 'More..' : '',
            ]),
            Container(
              padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person_4_sharp,
                    color: Colors.blue[900],
                    size: 14,
                  ),
                  Text(
                    'Society Name',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      currentReportingmanager.isNotEmpty
                          ? currentReportingmanager
                          : '',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Text(
                    'More..',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Text(
                    'Click To View Full Report..',
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> removeRole(String user) async {
    //Deleting role from Total Users user
    DocumentReference totalUsersDoc =
        FirebaseFirestore.instance.collection('TotalUsers').doc(user);

    await totalUsersDoc.delete().whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Role Removed Successfully'),
      ));
    });
    // print('Role unAssigned Successfully');

    //Deleting role from the assigned users
    DocumentReference assginedUsersDoc =
        FirebaseFirestore.instance.collection('AssignedRole').doc(user);

    await assginedUsersDoc.delete();

    //Adding role as unssigned user in total users
    await FirebaseFirestore.instance
        .collection('TotalUsers')
        .doc(user)
        .set({'alphabet': user[0][0].toUpperCase(), 'position': 'unAssigned'});

    //Adding un Assgined role in unAssigned users

    await FirebaseFirestore.instance
        .collection('unAssignedRole')
        .doc(user)
        .set({'alphabet': user[0][0].toUpperCase(), 'position': 'unAssigned'});
  }

  customDialogBox(
    String user,
    List<dynamic> currentRoles,
    String currentsocietyname,
    // List<dynamic> cities,
    // List<dynamic> depots
  ) {
    return showDialog(
        context: context,
        builder: (_) => Dialog(
                child: Card(
              elevation: 10,
              shadowColor: Colors.black,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/tata_dialog_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                height: 550,
                width: 1000,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          user,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_2_sharp,
                            color: Colors.black,
                            size: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Designation',
                              style: TextStyle(
                                  decorationThickness: 2.0,
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          child: customRowBuilderForDialog(currentRoles)),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 20.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_4_sharp,
                              color: Colors.black,
                              size: 20,
                            ),
                            const Text(
                              'Society Name',
                              style: TextStyle(
                                  decorationThickness: 2.0,
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.circle,
                                size: 10,
                              ),
                            ),
                            Text(
                              currentsocietyname.toString().isNotEmpty
                                  ? currentsocietyname
                                  : '',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 30.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_4_sharp,
                              color: Colors.black,
                              size: 20,
                            ),
                            Text(
                              'Cities',
                              style: TextStyle(
                                  decorationThickness: 2.0,
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                      // Container(child: customRowBuilderForDialog(cities)),
                      // Container(
                      //   padding: const EdgeInsets.only(bottom: 10.0, top: 30.0),
                      //   child: Row(
                      //     children: [
                      //       const Icon(
                      //         Icons.bus_alert_outlined,
                      //         color: Colors.black,
                      //         size: 20,
                      //       ),
                      //       Text(
                      //         'Depots',
                      //         style: GoogleFonts.average(
                      //             decorationThickness: 2.0,
                      //             color: Colors.black,
                      //             fontSize: 15,
                      //             letterSpacing: 1),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //     width: 900,
                      //     height: 120,
                      //     child: SingleChildScrollView(
                      //       child: customRowGridBuilder(depots),
                      //     ))
                    ]),
              ),
            )));
  }

  Future<void> storeAssginedUser(
      List<dynamic> roles,
      // List<dynamic> depots,
      // List<dynamic> cities,
      String username,
      String societynameName) async {
    await FirebaseFirestore.instance
        .collection('AssignedRole')
        .doc(username)
        .set({
      'alphabet': username[0][0].toUpperCase(),
      'position': 'Assigned',
      'roles': roles,
      // 'depots': depots,
      // 'cities': cities,
      'societyname': societynameName
    }).whenComplete(() {
      // ignore: avoid_print
      print('Operation Complete');
    });
  }

  void processLoading() {
    for (int i = 0; i < 50; i++) {}
  }

  void setColor() async {
    List<bool> tempBool = [];
    for (int i = 0; i < 27; i++) {
      tempBool.add(false);
    }
    selectedDesign = tempBool;
    setState(() {
      isLoading = false;
    });
  }
}
