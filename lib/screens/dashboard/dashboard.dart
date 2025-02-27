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
  List<dynamic> flatList =[];
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
        body: isLoading ? Center(child: CircularProgressIndicator(),):
        Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(10),
          child: Card(
            elevation: 10,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                children: [
                  const Row(
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
                          itemCount: particular.length,
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
                                       onTap: () {

                                        final provider = Provider.of<
                                                ApplicationManagementProvider>(
                                            context,
                                            listen: false);
                                        provider.setSelectedApplication(true);

                                        provider.setSelectedFlatNo(particular[index]['flatno']);
                                        provider.setSelectedApplicationType(particular[index]['applicationType']);
                                        provider.setLoadWidget(false);
                                      },
                                      title: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          particular[index]['flatno'],
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
                                      onTap: () {

                                        final provider = Provider.of<
                                                ApplicationManagementProvider>(
                                            context,
                                            listen: false);
                                        provider.setSelectedApplication(true);

                                        provider.setSelectedFlatNo(particular[index]['flatno']);
                                        provider.setSelectedApplicationType(particular[index]['applicationType']);
                                        provider.setLoadWidget(false);
                                      },
                                      title: Text(
                                        particular[index]['applicationType'],
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

// Future<void> getAppType(String selectedSociety) async {
//     try {
//       for (var i = 0; i < flatList.length; i++) {
//       DocumentSnapshot allDataDocumentSnapshot = await FirebaseFirestore.instance
//         .collection('application')
//         .doc(selectedSociety)
//         .collection('flatno')
//         .doc(flatList[i]['flatno'])

//         .get();

//         if (allDataDocumentSnapshot.exists) {
//           Map<String,dynamic> allData = allDataDocumentSnapshot.data() as Map<String, dynamic>;
//           print("alldata $allData");

//         }

//     // List<dynamic> allParticular =
//     //     allDataDocumentSnapshot.docs.map((e) => e.data()).toList();
//     // particular = allParticular;
//     // print('allparticular $particular');
//     // setState(() {
//     //   isLoading = false;
//     // });
//     }
      
//     } catch (e) {
      
//     }
//   }
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
