import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
   Settings({super.key,required this.society, required this.allRoles});
  String society;
  List<dynamic> allRoles = [];

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Text('Settings \n Module'),
        )
    );
  }
}