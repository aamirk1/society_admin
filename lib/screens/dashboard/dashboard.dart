import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/applicationManagementProvider.dart';
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

  bool isLoading = true;
  List<dynamic> flatList = [];
  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now); // Initialize here
    getFlatNum(widget.society!);
  }

  List<String> flat = ['101', '102'];
  List<dynamic> particular = [];
@override
Widget build(BuildContext context) {
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  Map<String, List<dynamic>> groupedApplications = {};

  // Sort applications by timestamp (latest first)
  particular.sort((a, b) {
    Timestamp timeA = a['dateOfApplication'];
    Timestamp timeB = b['dateOfApplication'];
    return timeB.compareTo(timeA); // 🔹 Latest date first
  });

  // Group applications by date
  for (var app in particular) {
    Timestamp timestamp = app['dateOfApplication'];
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    if (!groupedApplications.containsKey(formattedDate)) {
      groupedApplications[formattedDate] = [];
    }
    groupedApplications[formattedDate]!.add(app);
  }

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
              child: Text(todayDate), // Show today's date
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout_outlined,
              color: white,
            ),
          ),
        ],
      )
    ]),
    body: isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Row(
                        children: [
                          TableHeading(title: 'Flat No.', width: 0.15),
                          TableHeading(title: 'Particulars', width: 0.70),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ListView.builder(
                              itemCount: groupedApplications.length,
                              itemBuilder: (context, index) {
                                String date = groupedApplications.keys.elementAt(index);
                                List<dynamic> applications = groupedApplications[date]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🔹 Show Date Header ONLY IF it's NOT today's date
                                    if (date != todayDate)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          date, // Display date
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),

                                    // 🔹 List of Applications for this date
                                    ...applications.map((app) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            // 🔹 Flat Number Box
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.10,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: ListTile(
                                                onTap: () {
                                                  final provider = Provider.of<ApplicationManagementProvider>(context, listen: false);
                                                  provider.setSelectedApplication(true);
                                                  provider.setSelectedFlatNo(app['flatno']);
                                                  provider.setSelectedApplicationType(app['applicationType']);
                                                  provider.setLoadWidget(false);
                                                },
                                                title: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(app['flatno']),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 50),

                                            // 🔹 Application Type Box
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.65,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: ListTile(
                                                onTap: () {
                                                  final provider = Provider.of<ApplicationManagementProvider>(context, listen: false);
                                                  provider.setSelectedApplication(true);
                                                  provider.setSelectedFlatNo(app['flatno']);
                                                  provider.setSelectedApplicationType(app['applicationType']);
                                                  provider.setLoadWidget(false);
                                                },
                                                title: Text(app['applicationType']),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
  );
}


  Future<void> getFlatNum(String selectedSociety) async {
    isLoading = true;
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('application')
        .doc(selectedSociety)
        .collection('flatno')
        .get();

    List<dynamic?> allFlat =
        flatNumQuerySnapshot.docs.map((e) => e.data()).toList();
    flatList = allFlat;

    getAppType(widget.society!);
  }

  Future<void> getAppType(String selectedSociety) async {
    try {
      for (var i = 0; i < flatList.length; i++) {
        QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
            .collection('application')
            .doc(selectedSociety)
            .collection('flatno')
            .doc(flatList[i]['flatno'])
            .collection('applicationType')
            .orderBy('dateOfApplication', descending: true)
            .get();

        List<dynamic> allParticular =
            flatNumQuerySnapshot.docs.map((e) => e.data()).toList();
        particular.addAll(allParticular);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
