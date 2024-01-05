import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/Notice/addNotice.dart';

class CircularNotice extends StatefulWidget {
  CircularNotice({super.key, this.society, this.allRoles});
  String? society;
  List<dynamic>? allRoles = [];

  @override
  State<CircularNotice> createState() => _CircularNoticeState();
}

class _CircularNoticeState extends State<CircularNotice> {
  final date = DateFormat('dd-MM-yyyy ').format(DateTime.now());
  @override
  void initState() {
    print(date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular Notice'),
        backgroundColor: primaryColor,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                      minimumSize: MaterialStateProperty.all(
                        Size(20, 10),
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AddNotice(societyName: widget.society);
                      }),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: textColor,
                  ),
                ),
              ))
        ],
      ),
      body: const Center(
        child: Column(children: []),
      ),
    );
  }

  
}

// https://youtu.be/KZH-kyUUclE?si=v4AQq-XWaHvfpij8
