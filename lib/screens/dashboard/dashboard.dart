import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/components/customAppBar.dart';
import 'package:society_admin/screens/dashboard/tableHeading.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, this.society, this.allRoles, required this.userId});
  String? society;
  List<dynamic>? allRoles = [];
  String userId;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime now = DateTime.now();
  String? formattedDate; // Make this nullable for now

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now); // Initialize here
  }

  List<String> flat = ['101', '102'];
  List<String> particular = ['Sale NOC', 'Complaint'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Customappbar(title: 'Dashboard', action: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(formattedDate!),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: white,
                  )),
            ],
          )
        ]),
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(10),
          child: Card(
            elevation: 10,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                children: [
                  Row(
                    children: [
                      TableHeading(title: 'Flat No.', width: 0.15),
                      TableHeading(title: 'Particulars', width: 0.70),
                    ],
                  ),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: flat.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.10,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      onTap: () {},
                                      title: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          flat[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      onTap: () {},
                                      title: Text(
                                        flat[index],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ]),
                ],
              ),
            ]),
          ),
        ));
  }
}
