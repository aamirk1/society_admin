// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/emplist_builder_provider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/ServiceProvider/CompanyDetails/viewCompDetails.dart';
import 'package:society_admin/screens/ServiceProvider/EmployeeDetails/addEmployeeDetails.dart';
import 'package:society_admin/screens/ServiceProvider/EmployeeDetails/viewDetails.dart';

// ignore: must_be_immutable
class ViewEmployee extends StatefulWidget {
  ViewEmployee({
    super.key,
    required this.society,
    required this.CompanyName,
    required this.comEmail,
    required this.comPhone,
    required this.comAddress,
  });
  String society;
  String CompanyName;
  String comEmail;
  String comPhone;
  String comAddress;

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isAlreadyApproved = false;
  List<dynamic> empName = [];
  @override
  void initState() {
    super.initState();
    getEmployee(widget.CompanyName);
    // getApproved();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<EmpListBuilderProvider>(context, listen: false);
    provider.empList.clear();
    // getApproved();
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ViewCompanyData(
                    CompanyName: widget.CompanyName,
                    comEmail: widget.comEmail,
                    comPhone: widget.comPhone,
                    comAddress: widget.comAddress,
                  );
                },
              ),
            );
          },
          child: Text(
            'All Employee in ${widget.CompanyName}',
            style: const TextStyle(color: white),
          ),
        ),
        backgroundColor: primaryColor,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(white),
                      minimumSize: MaterialStateProperty.all(
                        const Size(20, 10),
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AddEmployee(
                            society: widget.society,
                            CompanyName: widget.CompanyName);
                      }),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: textColor,
                  ),
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<EmpListBuilderProvider>(builder: (context, value, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: value.empList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            value.empList[index]['empName'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            value.empList[index]['empDesignation'],
                          ),
                          trailing: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,

                            // margin: EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () {
                                deleteEmp(widget.CompanyName,
                                    value.empList[index]['empName'], index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                          // subtitle: Text(data.docs[index]['city']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ViewData(
                                  CompanyName: widget.CompanyName,
                                  name: value.empList[index]['empName'],
                                  email: value.empList[index]['empEmail'],
                                  phone: value.empList[index]['empPhone'],
                                  address: value.empList[index]['empAddress'],
                                  designation: value.empList[index]
                                      ['empDesignation'],
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }

  Future<void> getEmployee(String CompanyName) async {
    final provider =
        Provider.of<EmpListBuilderProvider>(context, listen: false);

    QuerySnapshot companyQuerySnapshot = await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(CompanyName)
        .collection('employeeList')
        .get();

    List<dynamic> allCompany =
        companyQuerySnapshot.docs.map((e) => e.data()).toList();

    empName = allCompany.map((e) => e['empName']).toList();

    provider.setBuilderEmpList(allCompany);
    print('hello -  $allCompany');
  }

  Future<void> deleteEmp(String company, String name, int index) async {
    final provider =
        Provider.of<EmpListBuilderProvider>(context, listen: false);
    DocumentReference deleteEmployee = FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(company)
        .collection('employeeList')
        .doc(name);
    await deleteEmployee.delete();

    provider.removeData(index);
  }

  alertbox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: textColor),
                )),
          ],
          title: const Text(
            'No data found!',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}
