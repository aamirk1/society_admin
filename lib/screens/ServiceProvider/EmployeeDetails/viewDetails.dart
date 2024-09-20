// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class ViewData extends StatefulWidget {
  const ViewData({
    super.key,
    required this.CompanyName,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.designation,
  });
  final String CompanyName;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String designation;

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Full Detais of ${widget.name}',
          style: const TextStyle(color: white),
        ),
          flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [lightBlueColor, blueColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight))),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 0.50,
          child: Card(
            elevation: 15,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Company Name: ${widget.CompanyName}',
                    style: const TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
              const SizedBox(
                height: 7,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${widget.name}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Designation: ${widget.designation}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Mobile: ${widget.phone}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Email: ${widget.email}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Address: ${widget.address}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 55.0, right: 30),
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: textColor, fontSize: 18),
                    )),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
