import 'package:flutter/material.dart';

class ComplaintManagement extends StatefulWidget {
  const ComplaintManagement({super.key});

  @override
  State<ComplaintManagement> createState() => _ComplaintManagementState();
}

class _ComplaintManagementState extends State<ComplaintManagement> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Complaint Management \n Module'),
      )
    );
  }
}