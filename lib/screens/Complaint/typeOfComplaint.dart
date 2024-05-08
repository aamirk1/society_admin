// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/complaintManagementProvider.dart';

int globalSelectedIndexForComplaint = 0;

// ignore: must_be_immutable
class TypeOfComplaint extends StatefulWidget {
  TypeOfComplaint({
    super.key,
    required this.dataList,
    required this.society,
    required this.flatNo,
    required this.userId,
  });
  String society;
  String flatNo;
  String userId;
  List<dynamic> dataList;

  @override
  State<TypeOfComplaint> createState() => _TypeOfComplaintState();
}

class _TypeOfComplaintState extends State<TypeOfComplaint> {
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

  List<String> complaintsTypeList = [
    'House Keeping Complaint',
    'Security Issues',
    'Parking Issue',
    'Admin Issue',
    'Accounts Issue',
    'Vendor Complaints',
    'Water Related',
    'Leackage Related',
    'Pet Animals Related',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      shrinkWrap: true,
      itemCount: complaintsTypeList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: Card(
            color: colors[index % colors.length],
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                minVerticalPadding: 0.3,
                title: Text(
                  complaintsTypeList[index],
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                // subtitle: Text(data.docs[index]['city']),
                onTap: () async {
                  globalSelectedIndexForComplaint = index;
                  print('globalIndex - $globalSelectedIndexForComplaint');
                  final provider = Provider.of<ComplaintManagementProvider>(
                      context,
                      listen: false);
                  provider.setSelectedComplaint(
                    complaintsTypeList[index],
                  );
                  await provider.getComplaintData();
                  provider.setLoadWidget(false);
                },
              ),
            ),
          ),
        );
      },
    ));
  }
}
