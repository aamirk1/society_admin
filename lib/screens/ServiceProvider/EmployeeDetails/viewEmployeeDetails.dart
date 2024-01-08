import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/ServiceProvider/EmployeeDetails/addEmployeeDetails%20copy.dart';
import 'package:society_admin/screens/ServiceProvider/EmployeeDetails/viewDetails.dart';

class ViewEmployee extends StatefulWidget {
  ViewEmployee({super.key, required this.society, required this.CompanyName});
  String society;
  String CompanyName;

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getEmployee(widget.CompanyName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Employee in ${widget.CompanyName}',
          style: const TextStyle(color: secondaryColor),
        ),
        backgroundColor: primaryColor,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                      minimumSize: MaterialStateProperty.all(
                        Size(20, 10),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : dataList.isEmpty
              ? alertbox()
              : Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  dataList[index]['empName'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  dataList[index]['empDesignation'],
                                ),
                                // subtitle: Text(data.docs[index]['city']),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ViewData(
                                        CompanyName: widget.CompanyName,
                                        name: dataList[index]['empName'],
                                        email: dataList[index]['empEmail'],
                                        phone: dataList[index]['empPhone'],
                                        address: dataList[index]['empAddress'],
                                        designation: dataList[index]
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
                    ),
                  ],
                ),
    );
  }

  Future<void> getEmployee(String CompanyName) async {
    isLoading = true;
    QuerySnapshot companyQuerySnapshot = await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(CompanyName)
        .collection('employeeList')
        .get();

    List<dynamic> allCompany =
        companyQuerySnapshot.docs.map((e) => e.data()).toList();

    // ignore: unused_local_variable
    dataList = allCompany;
   
    setState(() {
      isLoading = false;
    });
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
                'Please select a file first!',
                style: TextStyle(color: Colors.red),
              ));
        });
  }
}
