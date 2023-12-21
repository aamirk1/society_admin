import 'package:flutter/material.dart';

class AddNoc extends StatefulWidget {
  const AddNoc({super.key});

  @override
  State<AddNoc> createState() => _AddNocState();
}

class _AddNocState extends State<AddNoc> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Add Noc \n Module'),
    ));
  }
}
