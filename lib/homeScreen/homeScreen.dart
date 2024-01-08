import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
   HomePage({super.key, required this.society, required this.allRoles});
  String society;
  List<dynamic> allRoles = [];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home Page'),
      )
    );
  }
}