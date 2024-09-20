// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/emplist_builder_provider.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class AddEmployee extends StatefulWidget {
  AddEmployee({super.key, required this.society, required this.CompanyName});
  String society;
  String CompanyName;

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController empNameController = TextEditingController();
  TextEditingController empEmailController = TextEditingController();
  TextEditingController empPhoneController = TextEditingController();
  TextEditingController empAddressController = TextEditingController();
  TextEditingController empDesignationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    empNameController.dispose();
    empEmailController.dispose();
    empPhoneController.dispose();
    empAddressController.dispose();
    empDesignationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Employee in ${widget.CompanyName}',
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
                            return 'Please enter Employee Name';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: empNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Employee Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Employee Designation';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: empDesignationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Designation',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Employee Email';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: empEmailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Employee Email',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Employee Phone';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: empPhoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Employee Phone',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Employee Address';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: empAddressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Employee Address',
                          )),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            storedData(
                                widget.society,
                                widget.CompanyName,
                                empNameController.text,
                                empEmailController.text,
                                empPhoneController.text,
                                empAddressController.text,
                                empDesignationController.text);
                          },
                          child: const Text('Submit'))
                    ])),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> storedData(
      String societyName,
      String CompanyName,
      String empName,
      String email,
      String phone,
      String address,
      String designation) async {
    final provider =
        Provider.of<EmpListBuilderProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('vendorEmployeeList')
          .doc(CompanyName)
          .collection('employeeList')
          .doc(email)
          .set({
        'society': societyName,
        'companyName': CompanyName,
        'empName': empName,
        'empEmail': email,
        'empPhone': phone,
        'empAddress': address,
        'empDesignation': designation,
        'status': true,
      });

      FirebaseFirestore.instance
          .collection('vendorEmployeeList')
          .doc(CompanyName)
          .set({
        'companyName': CompanyName,
      });
      provider.addSingleList({
        'society': societyName,
        'companyName': CompanyName,
        'empName': empName,
        'empEmail': email,
        'empPhone': phone,
        'empAddress': address,
        'empDesignation': designation,
        'status': true,
      });

      Navigator.pop(context);
    }
  }
}
