// import 'dart:html';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddComplaint extends StatefulWidget {
  AddComplaint(
      {super.key,
      required this.complaintType,
      required this.text,
      required this.society,
      required this.flatNo});
  String complaintType;
  String text;
  String society;
  String flatNo;
  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  PlatformFile? selectedFile;
  @override
  void initState() {
    super.initState();
    // getTypeOfNoc(widget.society, widget.flatNo, widget.nocType,widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.60,
          height: MediaQuery.of(context).size.height * 0.98,
          child: Card(
            elevation: 5,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Flat No: ${widget.flatNo}',
                    style: const TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  widget.complaintType,
                  style: const TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ]),
              const SizedBox(
                height: 7,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.77,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: textColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    minimumSize: MaterialStateProperty.all(
                      const Size(20, 30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Response'))
            ]),
          ),
        ),
      ),
    );
  }
}
