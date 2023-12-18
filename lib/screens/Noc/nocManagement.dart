import 'package:flutter/material.dart';

class NocManagement extends StatefulWidget {
  const NocManagement({super.key});

  @override
  State<NocManagement> createState() => _NocManagementState();
}

class _NocManagementState extends State<NocManagement> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('NOC Management \n Module'),
    ));
  }
}
