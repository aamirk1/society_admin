import 'package:flutter/material.dart';

class ComplaintManagement extends StatefulWidget {
  ComplaintManagement({super.key, this.society, this.allRoles});
  String? society;
  List<dynamic>? allRoles = [];

  @override
  State<ComplaintManagement> createState() => _ComplaintManagementState();
}

class _ComplaintManagementState extends State<ComplaintManagement> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Complaint Management \n Module'),
    ));
  }
}
