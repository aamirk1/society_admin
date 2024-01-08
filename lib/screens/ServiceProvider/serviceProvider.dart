import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/list_builder_provider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/ServiceProvider/CompanyDetails/addCompanyDetails.dart';
import 'package:society_admin/screens/ServiceProvider/EmployeeDetails/viewEmployeeDetails.dart';

class ServiceProvider extends StatefulWidget {
  ServiceProvider({super.key, required this.society, required this.allRoles});
  String society;
  List<dynamic> allRoles = [];

  @override
  State<ServiceProvider> createState() => _ServiceProviderState();
}

class _ServiceProviderState extends State<ServiceProvider> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getCompany(widget.society);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Service Provider'),
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
                        return AddCompany(society: widget.society);
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
          // : dataList.isEmpty
          //     ? alertbox()
          : Column(
              children: [
                Consumer<ListBuilderProvider>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              minVerticalPadding: 0.3,
                              title: Text(
                                provider.list[index]['companyName'],
                                style: const TextStyle(color: Colors.black),
                              ),
                              // subtitle: Text(data.docs[index]['city']),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ViewEmployee(
                                      society: widget.society,
                                      CompanyName: provider.list[index]
                                          ['companyName'],
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
    );
  }

  Future<void> getCompany(String selectedSociety) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);
    isLoading = true;
    QuerySnapshot companyQuerySnapshot = await FirebaseFirestore.instance
        .collection('vendorList')
        .doc(selectedSociety)
        .collection('companyList')
        .get();

    List<dynamic> allCompany =
        companyQuerySnapshot.docs.map((e) => e.data()).toList();

    // ignore: unused_local_variable
    // dataList = allCompany;
    print(allCompany);
    provider.setBuilderList(allCompany);
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
