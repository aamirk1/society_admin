import 'package:flutter/material.dart';
import 'package:society_admin/homeScreen/homeScreen.dart';
import 'package:society_admin/screens/Complaint/complaint.dart';
import 'package:society_admin/screens/Noc/nocManagement.dart';
import 'package:society_admin/screens/Notice/circularNotice.dart';

// ignore: camel_case_types
class customSide extends StatefulWidget {
  const customSide({super.key});

  @override
  State<customSide> createState() => _customSideState();
}

// ignore: camel_case_types
class _customSideState extends State<customSide> {
  List<String> tabTitle = [
    'Home',
    'Circular/Notice \n Module',
    'NOC Management',
    'Complaint Management',
    'Service Provider \n Management',
    'Settings',
  ];
  List<dynamic> tabIcon = [
    Icons.apartment_outlined,
    Icons.supervised_user_circle_outlined,
    Icons.house_rounded,
    Icons.house_outlined,
    Icons.account_balance_outlined,
    Icons.account_balance_wallet_outlined,
  ];
  List<bool> design = [true, false, false, false, false, false];

  int _selectedIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const CircularNotice(),
    const NocManagement(),
    const ComplaintManagement(),
    // const ServiceProvider(),
    // const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: 250,
            color: Colors.purple,
            child: Column(
              children: [
                // Container(
                //   width: 100,
                //   height: 40,
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: Image.asset('assets/images/devlogo.png'),
                // ),
                const Divider(
                  color: Colors.black,
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tabIcon.length,
                    itemBuilder: (context, index) {
                      return customListTile(
                          tabTitle[index], tabIcon[index], index);
                    })
              ],
            ),
          ),
          Expanded(child: pages[_selectedIndex])
        ],
      ),
    );
  }

  Widget customListTile(String title, dynamic icon, int index) {
    return InkWell(
      onTap: () {
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
    for (int i = 0; i < 6; i++) {
      tempBool.add(false);
    }
    design = tempBool;
  }

  Widget getPage(int index) {
    if (index == 0) {
      return const HomePage();
    }
    return const Text('');
  }
}
