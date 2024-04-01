import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Noc/nocManagement.dart';
import 'package:society_admin/screens/Notice/circularNotice.dart';

// ignore: camel_case_types, must_be_immutable
class NoticeSidebar extends StatefulWidget {
  NoticeSidebar({super.key, this.societyName, required this.userId});
  String? societyName;
  String userId;
  @override
  State<NoticeSidebar> createState() => _NoticeSidebarState();
}

// ignore: camel_case_types
class _NoticeSidebarState extends State<NoticeSidebar> {
  List<String> tabTitle = [
    'Title',
    'Notice',
    'Pick File',
  ];
  List<dynamic> tabIcon = [
    Icons.text_fields_rounded,
    Icons.text_snippet_rounded,
    Icons.picture_as_pdf,
  ];
  List<bool> design = [true, false, false];

  int _selectedIndex = 0;

  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    pages = [
      CircularNotice(society: widget.societyName!, userId: widget.userId),
      NocManagement(society: widget.societyName!, userId: widget.userId),
      // ComplaintManagement(society: widget.society!, userId: widget.userId, ),
    ];
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: 250,
            color: Colors.purple,
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 80,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset('assets/images/devlogo.png'),
                ),
                const Divider(
                  color: secondaryColor,
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
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
    for (int i = 0; i < 8; i++) {
      tempBool.add(false);
    }
    design = tempBool;
  }

  // Widget getPage(int index) {
  //   if (index == 0) {
  //     return HomePage(
  //       society: widget.society!,
  //       allRoles: widget.allRoles[index],
  //     );
  //   }
  //   return const Text('');
  // }
}
