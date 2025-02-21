// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:society_admin/Provider/applicationManagementProvider.dart';
// import 'package:society_admin/authScreen/common.dart';
// import 'package:society_admin/screens/dashboard/innerScreen/addApplication.dart';

// class CommonScreen extends StatefulWidget {
//    CommonScreen({super.key, required  this.particular, required  this.flat,  this. society, required this. userId});
// String particular;
// String flat;
// String? society;
//  String userId;
//   @override
//   State<CommonScreen> createState() => _CommonScreenState();
// }

// class _CommonScreenState extends State<CommonScreen> {
//   List<dynamic> dateList = [];
//   List<dynamic> applicationdateList = [];
//   List<dynamic> dateofComplainList = [];
//   Map<String, dynamic> allApplicationData = {};
//   String selectedFlatno = '';
//   String selectedApplicationType = '';
//   bool isApplicationLoaded = false;
//   int selectedDateIndex = 0;
//   bool isLoading = true;
//   bool isShowApplication = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : SizedBox(
//                 width: MediaQuery.of(context).size.width * .90,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Column(
//                         children: [
//                           ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: dateList.length,
//                             itemBuilder: (context, index) {
//                               return SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.12,
//                                 child: Card(
//                                   color: primaryColor,
//                                   elevation: 5,
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     child: Padding(
//                                         padding: const EdgeInsets.all(1.0),
//                                         child: ListTile(
//                                           onTap: () {
//                                             selectedFlatno =
//                                                       dateList[index]['flatno'];
//                                                   selectedDateIndex = index;
//                                                   allDatafetch(
//                                                           widget.society!,
//                                                           selectedFlatno,
//                                                           dateofComplainList[
//                                                                   index]
//                                                               .toString())
//                                                       .whenComplete(() {
//                                                     isApplicationLoaded =
//                                                         !isApplicationLoaded;
//                                                     // value
//                                                     //     .setLoadWidget(true);
//                                                     // setState(() {});
//                                                   });
//                                           },
//                                           minVerticalPadding: 0.3,
//                                           title: Center(
//                                             child: Text(
//                                               dateList[index]['flatno'],
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 14,
//                                               ),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ),),
//                                   ),
//                                   //Navigator.push(
//                                   //   context,
//                                   //   MaterialPageRoute(builder: (context) {
//                                   //     return TypeOfApplication(
//                                   //       userId: widget.userId,
//                                   //       society: widget.society,
//                                   //       flatNo: dateList[index]['flatno'],
//                                   //     );
//                                   //   }),
//                                   // );
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
                  
//                     // Consumer<ApplicationManagementProvider>(
//                     //   builder: (context, value, child) {
//                     //     return Expanded(
//                     //       flex: 1,
//                     //       child: SizedBox(
//                     //         height: MediaQuery.of(context).size.height * 0.9,
//                     //         child: Column(
//                     //           children: [
//                     //             ListView.builder(
//                     //               shrinkWrap: true,
//                     //               itemCount: dateofComplainList.length,
//                     //               itemBuilder: (context, index) {
//                     //                 return SizedBox(
//                     //                   height:
//                     //                       MediaQuery.of(context).size.height *
//                     //                           0.12,
//                     //                   child: Card(
//                     //                     color: primaryColor,
//                     //                     elevation: 5,
//                     //                     child: Container(
//                     //                       alignment: Alignment.center,
//                     //                       child: Padding(
//                     //                           padding:
//                     //                               const EdgeInsets.all(1.0),
//                     //                           child: ListTile(
//                     //                             onTap: () {
//                     //                               selectedFlatno =
//                     //                                   dateList[index]['flatno'];
//                     //                               selectedDateIndex = index;
//                     //                               allDatafetch(
//                     //                                       widget.society!,
//                     //                                       selectedFlatno,
//                     //                                       dateofComplainList[
//                     //                                               index]
//                     //                                           .toString())
//                     //                                   .whenComplete(() {
//                     //                                 isApplicationLoaded =
//                     //                                     !isApplicationLoaded;
//                     //                                 value
//                     //                                     .setLoadWidget(true);
//                     //                                 // setState(() {});
//                     //                               });
//                     //                             },
//                     //                             minVerticalPadding: 0.3,
//                     //                             title: Center(
//                     //                               child: Text(
//                     //                                 dateofComplainList[index]
//                     //                                     .toString(),
//                     //                                 style: const TextStyle(
//                     //                                     color: Colors.white,
//                     //                                     fontSize: 14),
//                     //                                 textAlign: TextAlign.center,
//                     //                               ),
//                     //                             ),
//                     //                           )),
//                     //                     ),
//                     //                     //Navigator.push(
//                     //                     //   context,
//                     //                     //   MaterialPageRoute(builder: (context) {
//                     //                     //     return TypeOfApplication(
//                     //                     //       userId: widget.userId,
//                     //                     //       society: widget.society,
//                     //                     //       flatNo: dateList[index]['flatno'],
//                     //                     //     );
//                     //                     //   }),
//                     //                     // );
//                     //                   ),
//                     //                 );
//                     //               },
//                     //             ),
//                     //           ],
//                     //         ),
//                     //       ),
//                     //     );
//                     //   },
//                     // ),
                   
                 
//                   ],
//                 ),
//               ));
  
//   }
//   Future<dynamic> dateOfApplication(String society, String flatNo) async {
//     try {
//       final provider =
//           Provider.of<ApplicationManagementProvider>(context, listen: false);
//       QuerySnapshot flatNumQuerySnapshot = await FirebaseFirestore.instance
//           .collection('Applications')
//           .doc(society)
//           .collection('flatno')
//           .doc(flatNo)
//           .collection('typeofApplications')
//           .doc(widget.particular)
//           .collection('dateOfApplication')
//           .get();

//       if (flatNumQuerySnapshot.docs.isNotEmpty) {
//         List<dynamic> allApplicationType =
//             flatNumQuerySnapshot.docs.map((e) => e.id).toList();

//         dateofComplainList = allApplicationType;
//       } else {
//         dateofComplainList = [];
//       }
//     } catch (e) {
//       print("Error while fetching data $e");
//     }
//   }

//   Future<void> allDatafetch(String society, String flatNo, String date) async {
//     try {
//       final provider =
//           Provider.of<ApplicationManagementProvider>(context, listen: false);
//       DocumentSnapshot fetchallData = await FirebaseFirestore.instance
//           .collection('Applications')
//           .doc(society)
//           .collection('flatno')
//           .doc(flatNo)
//           .collection('typeofApplications')
//           .doc(widget.particular)
//           .collection('dateOfApplication')
//           .doc(date)
//           .get();

//       if (fetchallData.exists) {
//         //allApplicationData = fetchallData.data().toString();
//         allApplicationData = fetchallData.data() as Map<String, dynamic>;
//         print('allApplicationDataFF $allApplicationData');
//       }
//     } catch (e) {
//       print("Error while fetching data $e");
//     }
//   }
// }
