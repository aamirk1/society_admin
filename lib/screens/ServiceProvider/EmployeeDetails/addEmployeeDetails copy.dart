import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/list_builder_provider.dart';
import 'package:society_admin/authScreen/common.dart';

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
          style: const TextStyle(color: secondaryColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(children: [
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: empNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Employee Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: empDesignationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Designation',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: empEmailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Employee Email',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: empPhoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Employee Phone',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: empAddressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Employee Address',
                          )),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          onPressed: () {
                            storedData(
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

  Future<void> storedData(String CompanyName, String empName, String email,
      String phone, String address, String designation) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('vendorEmployeeList')
          .doc(CompanyName)
          .collection('employeeList')
          .doc(empName)
          .set({
        'companyName': CompanyName,
        'empName': empName,
        'empEmail': email,
        'empPhone': phone,
        'empAddress': address,
        'empDesignation': designation,
      });
      provider.addSingleList({
        'companyName': CompanyName,
      });
      Navigator.pop(context);
    }
  }
}
