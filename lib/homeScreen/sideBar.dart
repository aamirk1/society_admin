import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/nocManagementProvider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/homeScreen/homeScreen.dart';
import 'package:society_admin/screens/Complaint/complaintManagement.dart';
import 'package:society_admin/screens/GatePass/gatePass.dart';
import 'package:society_admin/screens/Members/ListOfMemberName.dart';
import 'package:society_admin/screens/Noc/nocManagement.dart';
import 'package:society_admin/screens/Notice/circularNotice.dart';
import 'package:society_admin/screens/ServiceProvider/serviceProvider.dart';
import 'package:society_admin/screens/assignRoll/user.dart';
import 'package:society_admin/screens/settings/settings.dart';

// ignore: camel_case_types, must_be_immutable
class customSide extends StatefulWidget {
  customSide({super.key, this.society, this.allRoles, required this.userId});
  String? society;
  List<dynamic>? allRoles = [];
  String userId;
  @override
  State<customSide> createState() => _customSideState();
}

// ignore: camel_case_types
class _customSideState extends State<customSide> {
  List<String> tabTitle = [
    'Circular/Notice \n Module',
    'NOC Management',
    'Complaint Management',
    'Service Provider \n Management',
    'Member Name List',
    'Assign Roles',
    'Gate Pass',
    'Settings',
  ];
  List<dynamic> tabIcon = [
    Icons.supervised_user_circle_outlined,
    Icons.house_rounded,
    Icons.house_outlined,
    Icons.account_balance_outlined,
    Icons.group,
    Icons.person,
    Icons.insert_drive_file,
    Icons.settings_outlined,
  ];
  List<bool> design = [true, false, false, false, false, false, false, false];

  int _selectedIndex = 0;

  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    pages = [
      CircularNotice(
          society: widget.society!,
          allRoles: widget.allRoles!,
          userId: widget.userId),
      NocManagement(
          society: widget.society!,
          allRoles: widget.allRoles,
          userId: widget.userId),
      ComplaintManagement(
          society: widget.society!,
          allRoles: widget.allRoles!,
          userId: widget.userId),
      ServiceProvider(
          society: widget.society!,
          allRoles: widget.allRoles!,
          userId: widget.userId),
      MemberNameList(
          society: widget.society!,
          allRoles: widget.allRoles!,
          userId: widget.userId),
      MenuUserPage(society: widget.society!, userId: widget.userId),
      GatePass(
          society: widget.society!,
          allRoles: widget.allRoles!,
          userId: widget.userId),
      Settings(
          society: widget.society!,
          allRoles: widget.allRoles!,
          userId: widget.userId),
    ];
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: 150,
            color: primaryColor,
            child: Column(
              children: [
                Container(
                  width: 80,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset('assets/images/devlogo.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 0.5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: 100,
                    child: Center(
                        child: SingleChildScrollView(
                      child: Text(
                        widget.society!,
                        style: const TextStyle(color: white),
                      ),
                    )),
                  ),
                ),
                const Divider(
                  color: white,
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tabIcon.length,
                        itemBuilder: (context, index) {
                          return customListTile(
                              tabTitle[index], tabIcon[index], index);
                        }),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: pages[_selectedIndex])
        ],
      ),
    );
  }

  Widget customListTile(String title, dynamic icon, int index) {
    final provider = Provider.of<NocManagementProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        provider.setLoadWidget(false);
        setDesignBool();
        _selectedIndex = index;
        design[index] = !design[index];
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Icon(icon,
              size: 30,
              color: design[index]
                  ? const Color.fromARGB(255, 8, 8, 8)
                  : Colors.white),
          subtitle: Text(
            textAlign: TextAlign.center,
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void setDesignBool() {
    List<bool> tempBool = [];
    for (int i = 0; i < 8; i++) {
      tempBool.add(false);
    }
    design = tempBool;
  }

  Widget getPage(int index) {
    if (index == 0) {
      return HomePage(
        society: widget.society!,
        allRoles: widget.allRoles!,
      );
    }
    return const Text('');
  }
}
