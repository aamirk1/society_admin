// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class ViewCompanyData extends StatefulWidget {
  const ViewCompanyData({
    super.key,
    required this.CompanyName,
    required this.comEmail,
    required this.comPhone,
    required this.comAddress,
  });
  final String CompanyName;
  final String comEmail;
  final String comPhone;
  final String comAddress;

  @override
  State<ViewCompanyData> createState() => _ViewCompanyDataState();
}

class _ViewCompanyDataState extends State<ViewCompanyData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Full Detais of ${widget.CompanyName}',
          style: const TextStyle(color: white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [lightBlueColor, blueColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 0.40,
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
                    'Email: ${widget.comEmail}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Mobile: ${widget.comPhone}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Address: ${widget.comAddress}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: textColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0, right: 30),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: textColor, fontSize: 18),
                      )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
