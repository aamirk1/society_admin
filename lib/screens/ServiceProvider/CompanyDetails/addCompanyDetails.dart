// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/list_builder_provider.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddCompany extends StatefulWidget {
  AddCompany({super.key, required this.society, required this.userId});
  String society;
  String userId;

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Company',
          style: TextStyle(color: white),
        ),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [lightBlueColor, blueColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight))),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(children: [
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Company Name';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Company Email';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company Email',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Company Phone';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company Phone',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Company Address';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: addressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Company Address',
                          )),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            storedData(
                              nameController.text,
                              emailController.text,
                              phoneController.text,
                              addressController.text,
                              widget.userId,
                            );
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: white),
                          ))
                    ])),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> storedData(String companyName, String email, String phone,
      String address, String userId) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('vendorList')
          .doc(widget.society)
          .collection('companyList')
          .doc(companyName)
          .set({
        'companyName': companyName,
        'email': email,
        'phone': phone,
        'address': address,
      });
      provider.addSingleList({
        'companyName': companyName,
        'email': email,
        'phone': phone,
        'address': address,
      });
      Navigator.pop(context);
    }
  }
}
