// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/list_builder_provider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/authScreen/loginScreen.dart';
import 'package:society_admin/screens/ServiceProvider/CompanyDetails/addCompanyDetails.dart';
import 'package:society_admin/screens/ServiceProvider/EmployeeDetails/viewEmployeeDetails.dart';

// ignore: must_be_immutable
class ServiceProvider extends StatefulWidget {
  ServiceProvider(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});
  String society;
  List<dynamic> allRoles = [];
  String userId;

  @override
  State<ServiceProvider> createState() => _ServiceProviderState();
}

class _ServiceProviderState extends State<ServiceProvider> {
  @override
  void initState() {
    super.initState();
    getCompany(widget.society);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Service Provider'),
        backgroundColor: primaryColor,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(white),
                      minimumSize: MaterialStateProperty.all(
                        const Size(20, 10),
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AddCompany(
                            society: widget.society, userId: widget.userId);
                      }),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: textColor,
                  ),
                ),
              )),
          IconButton(
            padding: const EdgeInsets.only(right: 20.0),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ListBuilderProvider>(
              builder: (context, value, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.list.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          minVerticalPadding: 0.3,
                          title: Text(
                            value.list[index]['companyName'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              alertbox(widget.society,
                                  value.list[index]['companyName'], index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          // subtitle: Text(data.docs[index]['city']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ViewEmployee(
                                  society: widget.society,
                                  CompanyName: value.list[index]['companyName'],
                                  comEmail: value.list[index]['email'],
                                  comPhone: value.list[index]['phone'],
                                  comAddress: value.list[index]['address'],
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getCompany(String selectedSociety) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);

    QuerySnapshot companyQuerySnapshot = await FirebaseFirestore.instance
        .collection('vendorList')
        .doc(selectedSociety)
        .collection('companyList')
        .get();

    List<dynamic> allCompany =
        companyQuerySnapshot.docs.map((e) => e.data()).toList();

    // print(allCompany);
    provider.setBuilderList(allCompany);
  }

  Future<void> deleteEmp(
      String selectedSociety, String company, int index) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);
    DocumentReference deleteCompany = FirebaseFirestore.instance
        .collection('vendorList')
        .doc(selectedSociety)
        .collection('companyList')
        .doc(company);

    await deleteCompany.delete();

    provider.removeData(index);

    deletCom(company);
  }

  Future<void> deletCom(String company) async {
    DocumentReference deleteCompanyFromEmployee = FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(company);

    await deleteCompanyFromEmployee.delete();
  }

  alertbox(String society, companyName, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          deleteEmp(society, companyName, index);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'YES',
                          style: TextStyle(color: textColor),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'NO',
                          style: TextStyle(color: textColor),
                        )),
                  ],
                ),
              ],
              title: const Text(
                'Are you sure? Do you want to delete this company?',
                style: TextStyle(color: Colors.red),
              ));
        });
  }
}
