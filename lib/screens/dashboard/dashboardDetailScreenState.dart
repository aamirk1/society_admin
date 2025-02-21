import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/components/customAppBar.dart';
import 'package:society_admin/screens/dashboard/innerScreen/dateOfApplication.dart';

class DashboardDetailScreen extends StatefulWidget {
  const DashboardDetailScreen(
      {super.key,
      required this.flatNo,
      required this.society,
      required this.userId,
      required this.selectedApplicationType});
  final String flatNo;
  final String society;
  final String userId;
  final String selectedApplicationType;

  @override
  State<DashboardDetailScreen> createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailScreen> {
  String selectedStartDate = '';
  String selectedEndDate = '';
  DateTime rangeStartDate = DateTime.now();
  DateTime? rangeEndDate = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2020, 01, 01),
    end: DateTime(2025, 01, 01),
  );

  bool isLoading = true;

  @override
 void initState() {
    super.initState();
// getAllDate(widget.society,widget.flatNo).whenComplete((){
//   setState(() {
//     isLoading = false;
//   });
// });
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
      body: Expanded(
          child: DateOfApplication(
              society: widget.society,
              userId: widget.userId,
              flatNo: widget.flatNo,
              particular: widget.selectedApplicationType)),
    );
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
