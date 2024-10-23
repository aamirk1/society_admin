import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Notice/addNoticePdf.dart';
import 'package:society_admin/screens/Notice/shortNotice.dart';

// ignore: camel_case_types, must_be_immutable
class NoticeSidebar extends StatefulWidget {
  NoticeSidebar(
      {super.key,
      this.societyName,
      required this.userId,
      required this.fcmIdList});
  String? societyName;
  String userId;
  List<String> fcmIdList = [];
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
  bool isIndex1 = false;
  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    pages = [
      ShortNotice(
          userId: widget.userId,
          societyName: widget.societyName,
          isIndex1: isIndex1,
          fcmIdList: widget.fcmIdList,
          ),
      ShortNotice(
        userId: widget.userId,
        societyName: widget.societyName,
        fcmIdList: widget.fcmIdList
      ),
      AddNoticePdf(userId: widget.userId, societyName: widget.societyName,fcmIdList: widget.fcmIdList),
    ];
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: 150,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [lightBlueColor, blueColor])),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 50,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset('assets/images/devlogo.png'),
                ),
                const Divider(
                  color: white,
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
        index == 0 ? isIndex1 = true : () {};
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

  Future<PlatformFile> pickAndUploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    PlatformFile? file;

    if (result != null) {
      file = result.files.first;
    } else {
      print('File picking canceled');
    }
    return file!;
  }
}
