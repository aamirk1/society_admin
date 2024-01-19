import 'package:flutter/material.dart';

class GatePass extends StatefulWidget {
  GatePass({super.key, required this.society, required this.allRoles});
  String society;
  List<dynamic> allRoles = [];
  @override
  State<GatePass> createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Gate Pass')),
    );
  }
}
