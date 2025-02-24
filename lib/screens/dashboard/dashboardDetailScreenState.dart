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
List<dynamic> listOfDate = [];
  @override
 void initState() {
    super.initState();
    print('sel ${selectedStartDate}');
getAllDate(widget.society,widget.flatNo).whenComplete((){
  setState(() {
    isLoading = false;
  });
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
  children: [
    Expanded(
      child: DateOfApplication(
        society: widget.society,
        userId: widget.userId,
        flatNo: widget.flatNo,
        particular: widget.selectedApplicationType,
        listOfDate: listOfDate,
      ),
    ),
  ],
)
,
    );
  }

 

Future<void> getAllDate(String selectedSociety, String selectedFlatno) async {
  try {
    QuerySnapshot flatNumQuerySnapshot; // Declare it here


      flatNumQuerySnapshot = await FirebaseFirestore.instance
          .collection('application')
          .doc(selectedSociety)
          .collection('flatno')
          .doc(selectedFlatno)
          .collection('applicationType')
          .where('dateOfApplication', isNotEqualTo: null)
          .get();
    

    // Now it's accessible here
    List<Map<String, dynamic>> allDate = flatNumQuerySnapshot.docs
        .map((e) => e.data() as Map<String, dynamic>)
        .toList();

    listOfDate.addAll(allDate);

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    print('Error: $e');
  }
}

   
}
