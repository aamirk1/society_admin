import 'package:flutter/material.dart';

class CommonScreen extends StatefulWidget {
  const CommonScreen({super.key, required String particular, required String flat, String? society, required String userId});

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('data'),
      ),
    );
  }
}
