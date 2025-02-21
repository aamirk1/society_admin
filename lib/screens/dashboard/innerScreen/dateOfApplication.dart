// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/applicationManagementProvider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/dashboard/innerScreen/addApplication.dart';

int globalSelectedIndexForComplaint = 0;

// ignore: must_be_immutable
class DateOfApplication extends StatefulWidget {
  DateOfApplication({
    super.key,
    required this.society,
    required this.flatNo,
    required this.particular,
    required this.userId,
  });
  String society;
  String flatNo;
  String particular;
  String userId;

  @override
  State<DateOfApplication> createState() => _DateOfApplicationState();
}

class _DateOfApplicationState extends State<DateOfApplication> {
  // Map<String, dynamic> allComplaintData = {};
  // List<dynamic> dateofComplainList = [];
  //  String selectedDate = '';
  bool isApplicationLoaded = false;
  int selectedDateIndex = 0;
  bool isLoading = true;
  bool isShowApplication = false;

  List<dynamic> listOfDate = [];
  List<dynamic> applicationdateList = [];
  Map<String, dynamic> allApplicationData = {};
  @override
  void initState(){
    super.initState();
    getAllDate(widget.society, widget.flatNo);
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              width: MediaQuery.of(context).size.width * 0.10,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listOfDate.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: MediaQuery.of(context).size.height * 0.060,
                      width: MediaQuery.of(context).size.width * 0.30,
                      // color: primaryColor,
                      child: ListTile(
                        minVerticalPadding: 0.1,
                        title: Text(
                        listOfDate[index]['dateOfApplication'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        // subtitle: Text(data.docs[index]['city']),
                        onTap: () async {
                          final provider =
                              Provider.of<ApplicationManagementProvider>(
                                  context,
                                  listen: false);
                          selectedDateIndex = index;
                          isApplicationLoaded = !isApplicationLoaded;
                          provider.setLoadWidget(true);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Consumer<ApplicationManagementProvider>(
            builder: (context, value, child) {
              return Expanded(
                flex: 5,
                child: value.loadWidget
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: 500,
                        child: isApplicationLoaded
                            ? 
                            
                            AddApplication(
                                applicationType: listOfDate[selectedDateIndex]['applicationType'],
                                text:
                                    listOfDate[selectedDateIndex]['text']?.toString() ??
                                        'N/A',
                                society: widget.society!,
                                flatNo: widget.flatNo,
                                date: listOfDate[selectedDateIndex]['dateOfApplication'],
                                response:
                                    listOfDate[selectedDateIndex]['response'].toString(),
                                fcmId:listOfDate[selectedDateIndex]['fcmId']?.toString() ??
                                        'N/A',
                              )
                            : Container(),
                      )
                    : Container(),
              );
            },
          ),

        ],
      ),
    ));
  }
Future<void> getAllDate(String selectedSociety, String selectedFlatno) async {
  try {
    // Query the Firestore collection
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('application')
        .doc(selectedSociety)
        .collection('flatno')
        .doc(selectedFlatno)
        .collection('applicationType')
        .where('dateOfApplication', isNotEqualTo: null)
        .get();

    // Map the query snapshot docs to a list of maps
    List<Map<String, dynamic>> allDate = flatNumQuerySnapshot.docs
        .map((e) => e.data() as Map<String, dynamic>)
        .toList();

    // Add all dates to the list
    listOfDate.addAll(allDate);

   

    // Update the loading state
    setState(() {
      isLoading = false;
    });
  } catch (e) {
    print('Error: $e');
  }
}

 

}
