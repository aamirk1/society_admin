// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/nocManagementProvider.dart';

int globalSelectedIndexForNoc = 0;

// ignore: must_be_immutable
class DateOfNoc extends StatefulWidget {
  DateOfNoc({
    super.key,
    required this.dataList,
    required this.society,
    required this.flatNo,
    required this.userId,
    required this.dateOfNoc,
  });
  String society;
  String flatNo;
  String userId;
  List<dynamic> dataList;
  List dateOfNoc;

  @override
  State<DateOfNoc> createState() => _DateOfNocState();
}

class _DateOfNocState extends State<DateOfNoc> {
  List<dynamic> colors = [
    const Color.fromARGB(255, 233, 87, 76),
    const Color.fromARGB(255, 102, 174, 233),
    const Color.fromARGB(255, 7, 141, 12),
    const Color.fromARGB(255, 216, 109, 235),
    const Color.fromARGB(255, 243, 103, 150),
    const Color.fromARGB(255, 167, 92, 49),
    const Color.fromARGB(255, 23, 48, 163),
    const Color.fromARGB(255, 82, 72, 212),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      shrinkWrap: true,
      itemCount: widget.dataList.length,
      itemBuilder: (context, index) {
        return Card(
          color: colors[index % colors.length],
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              minVerticalPadding: 0.3,
              title: Text(
                widget.dataList[index]['typeofNoc'],
                style: const TextStyle(color: Colors.white),
              ),
              // subtitle: Text(data.docs[index]['city']),
              onTap: () {
                globalSelectedIndexForNoc = index;
                print('globalIndex - $globalSelectedIndexForNoc');
                final provider =
                    Provider.of<NocManagementProvider>(context, listen: false);
                provider.setLoadWidget(false);
              },
            ),
          ),
        );
      },
    ));
  }
}
