// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/applicationManagementProvider.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/components/customAppBar.dart';
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
    required this.listOfDate,
  });
  String society;
  String flatNo;
  String particular;
  String userId;
  List<dynamic> listOfDate = [];
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


  List<dynamic> applicationdateList = [];
  Map<String, dynamic> allApplicationData = {};


   String selectedStartDate = '';
  String selectedEndDate = '';
  DateTime rangeStartDate = DateTime.now();
  DateTime? rangeEndDate = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2020, 01, 01),
    end: DateTime(2025, 01, 01),
  );
  @override
  void initState(){
    super.initState();
    // getAllDate(widget.society, widget.flatNo);
    
  }
  
  @override
   Widget build(BuildContext context) {
    return Scaffold(
        appBar: Customappbar(
        arrows: true,
        title: widget.flatNo,
        action: [
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.052,
                //  width: MediaQuery.of(context).size.width * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: white,
                ),
                child: TextButton(
                  onPressed: () {
                    pickDateRange();
                    setState(() {});
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: selectedStartDate.isNotEmpty
                            ? Text(" $selectedStartDate TO $selectedEndDate ")
                            : const Text('Select Date')),
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.052,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: white,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        prefixIconColor: Colors.grey),
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: white,
                  )),
            ],
          )
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.listOfDate.length,
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
                      child: ListTile(
                        title: Text(
                          widget.listOfDate[index]['dateOfApplication'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
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
          Expanded(
            flex: 5,
            child: Consumer<ApplicationManagementProvider>(
              builder: (context, value, child) {
                return Container(
                  width: double.infinity,
                  child: value.loadWidget
                      ? isApplicationLoaded
                          ? AddApplication(
                              applicationType: widget.listOfDate[selectedDateIndex]['applicationType'],
                              text: widget.listOfDate[selectedDateIndex]['text']?.toString() ?? 'N/A',
                              society: widget.society,
                              flatNo: widget.flatNo,
                              date: widget.listOfDate[selectedDateIndex]['dateOfApplication'],
                              response: widget.listOfDate[selectedDateIndex]['response'].toString(),
                              fcmId: widget.listOfDate[selectedDateIndex]['fcmId']?.toString() ?? 'N/A',
                            )
                          : Container()
                      : Container(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

Future<void> getAllDate(String selectedSociety, String selectedFlatno, String startDate, String endDate) async {
  widget.listOfDate.clear();
  try {
    // Query the Firestore collection
    QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
        .collection('application')
        .doc(selectedSociety)
        .collection('flatno')
        .doc(selectedFlatno)
        .collection('applicationType')
        .where('dateOfApplication', isGreaterThanOrEqualTo: startDate)
        .where('dateOfApplication', isLessThanOrEqualTo: endDate)
        .get();

    // Map the query snapshot docs to a list of maps
    List<Map<String, dynamic>> allDate = flatNumQuerySnapshot.docs
        .map((e) => e.data() as Map<String, dynamic>)
        .toList();

    // Add all dates to the list
    widget.listOfDate.addAll(allDate);

   

    // Update the loading state
    setState(() {
      isLoading = false;
    });
  } catch (e) {
    print('Error: $e');
  }
}
 Future<void> pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,

      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      saveText: "OK",
      // initialEntryMode: DatePickerEntryMode.input,
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      rangeStartDate = dateRange.start;
      rangeEndDate = dateRange.end;

      selectedStartDate =
          "${rangeStartDate.day.toString().padLeft(2, '0')}-${rangeStartDate.month.toString().padLeft(2, '0')}-${rangeStartDate.year.toString()} ";
      selectedEndDate =
          "${rangeEndDate!.day.toString().padLeft(2, '0')}-${rangeEndDate!.month.toString().padLeft(2, '0')}-${rangeEndDate!.year.toString()} ";
   
    });
if (selectedStartDate.isNotEmpty) {
  
    getAllDate(widget.society, widget.flatNo,selectedStartDate,selectedEndDate);
}
  }

  DateTime parseDateString(String dateStr) {
    try {
      // Using DateFormat to parse the string into DateTime object
      return DateFormat('dd-MM-yyyy').parse(dateStr);
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
      return DateTime.now(); // Return the current date if parsing fails
    }
  }
 

}
