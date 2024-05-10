// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ev_pmis_app/screen/dailyreport/daily_report_user/daily_project.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/daily_projectModel.dart';
// import '../models/energy_management.dart';
// import '../models/o&m_model/daily_acdb.dart';
// import '../models/o&m_model/daily_charger.dart';
// import '../models/o&m_model/daily_pss.dart';
// import '../models/o&m_model/daily_rmu.dart';
// import '../models/o&m_model/daily_sfu.dart';
// import '../models/o&m_model/daily_transformer.dart';

// List<int> globalRowIndex = [];

// class SummaryProvider extends ChangeNotifier {
//   Map<String, dynamic> alldate = Map();
//   List<DailyProjectModel> _dailydata = [];
//   List<EnergyManagementModel> _energydata = [];

//   List<dynamic> intervalListData = [];
//   List<dynamic> energyListData = [];

//   List<dynamic> get intervalData => intervalListData;
//   List<dynamic> get energyConsumedData => energyListData;

//   // o&M charger model
//   List<DailyChargerModel> _dailyChargerdata = [];
//   List<DailySfuModel> _sfuChargerdata = [];
//   List<DailyPssModel> _pssChargerdata = [];
//   List<DailyTransformerModel> _transferChargerdata = [];
//   List<DailyrmuModel> _rmuChargerdata = [];
//   List<DailyAcdbModel> _acdbChargerdata = [];

//   List<DailyProjectModel> get dailydata {
//     return _dailydata;
//   }

//   List<EnergyManagementModel> get energyData {
//     return _energydata;
//   }

//   // O&M Management
//   List<DailyChargerModel> get dailyCharger {
//     return _dailyChargerdata;
//   }

//   List<DailySfuModel> get sfuCharger {
//     return _sfuChargerdata;
//   }

//   List<DailyPssModel> get pssCharger {
//     return _pssChargerdata;
//   }

//   List<DailyTransformerModel> get transformerCharger {
//     return _transferChargerdata;
//   }

//   List<DailyrmuModel> get rmuCharger {
//     return _rmuChargerdata;
//   }

//   List<DailyAcdbModel> get acdbCharger {
//     return _acdbChargerdata;
//   }

//   fetchdailydata(
//       String depoName, String userId, DateTime date, DateTime endDate) async {
//     globalRowIndex.clear();
//     final List<DailyProjectModel> loadeddata = [];
//     for (DateTime initialdate = date;
//         initialdate.isBefore(endDate.add(const Duration(days: 1)));
//         initialdate = initialdate.add(const Duration(days: 1))) {
//       print(DateFormat.yMMMMd().format(initialdate));
//       FirebaseFirestore.instance
//           .collection('DailyProject3')
//           .doc(depoName)
//           .collection(DateFormat.yMMMMd().format(initialdate))
//           .doc(userId)
//           .get()
//           .then((value) {
//         if (value.data() != null) {
//           for (int i = 0; i < value.data()!['data'].length; i++) {
//             globalItemLengthList.add(0);
//             isShowPinIcon.add(false);
//             var _data = value.data()!['data'][i];
//             loadeddata.add(DailyProjectModel.fromjson(_data));
//             globalRowIndex.add(i + 1);
//           }
//           _dailydata = loadeddata;
//           notifyListeners();
//         }
//       });
//     }
//   }

//   fetchEnergyData(String cityName, String depoName, String userId,
//       DateTime date, DateTime endDate) async {
//     final List<dynamic> timeIntervalList = [];
//     final List<dynamic> energyConsumedList = [];
//     int currentMonth = DateTime.now().month;
//     String monthName = DateFormat('MMMM').format(DateTime.now());
//     final List<EnergyManagementModel> fetchedData = [];
//     _energydata.clear();
//     timeIntervalList.clear();
//     energyConsumedList.clear();
//     for (DateTime initialdate = endDate;
//         initialdate.isAfter(date.subtract(const Duration(days: 1)));
//         initialdate = initialdate.subtract(const Duration(days: 1))) {
//       // print(date.add(const Duration(days: 1)));
//       // print(DateFormat.yMMMMd().format(initialdate));

//       FirebaseFirestore.instance
//           .collection('EnergyManagementTable')
//           .doc(cityName)
//           .collection('Depots')
//           .doc(depoName)
//           .collection('Year')
//           .doc(DateTime.now().year.toString())
//           .collection('Months')
//           .doc(monthName)
//           .collection('Date')
//           .doc(DateFormat.yMMMMd().format(initialdate))
//           .collection('UserId')
//           .doc(userId)
//           .get()
//           .then((value) {
//         if (value.data() != null) {
//           for (int i = 0; i < value.data()!['data'].length; i++) {
//             var data = value.data()!['data'][i];
//             fetchedData.add(EnergyManagementModel.fromJson(data));
//             timeIntervalList.add(value.data()!['data'][i]['timeInterval']);
//             energyConsumedList.add(value.data()!['data'][i]['energyConsumed']);
//           }
//           _energydata = fetchedData;
//           intervalListData = timeIntervalList;
//           energyListData = energyConsumedList;
//           notifyListeners();
//         } else {
//           intervalListData = timeIntervalList;
//           energyListData = energyConsumedList;

//           notifyListeners();
//         }
//       });
//     }
//   }

//   fetchManagementDailyData(String depoName, String tabletitle, String userId,
//       DateTime date, DateTime endDate) async {
//     final List<DailyChargerModel> loadeddata = [];
//     final List<DailySfuModel> loadedsfu = [];
//     final List<DailyPssModel> loadedpss = [];
//     final List<DailyTransformerModel> loadedtransfer = [];
//     final List<DailyrmuModel> loadedrmu = [];
//     final List<DailyAcdbModel> loadedacdb = [];
//     _dailyChargerdata.clear();
//     _sfuChargerdata.clear();
//     _pssChargerdata.clear();
//     _transferChargerdata.clear();
//     _rmuChargerdata.clear();
//     _acdbChargerdata.clear();
//     for (DateTime initialdate = date;
//         initialdate.isBefore(endDate.add(const Duration(days: 1)));
//         initialdate = initialdate.add(const Duration(days: 1))) {
//       FirebaseFirestore.instance
//           .collection('DailyManagementPage')
//           .doc(depoName)
//           .collection('Checklist Name')
//           .doc(tabletitle)
//           .collection(DateFormat.yMMMMd().format(initialdate))
//           .doc(userId)
//           .get()
//           .then((value) {
//         if (value.data() != null) {
//           print('swswssw${value.data()!['data'].length}');
//           for (int i = 0; i < value.data()!['data'].length; i++) {
//             var _data = value.data()!['data'][i];
//             tabletitle == 'Charger Checklist'
//                 ? loadeddata.add(DailyChargerModel.fromjson(_data))
//                 : tabletitle == 'SFU Checklist'
//                     ? loadedsfu.add(DailySfuModel.fromjson(_data))
//                     : tabletitle == 'PSS Checklist'
//                         ? loadedpss.add(DailyPssModel.fromjson(_data))
//                         : tabletitle == 'Transformer Checklist'
//                             ? loadedtransfer
//                                 .add(DailyTransformerModel.fromjson(_data))
//                             : tabletitle == 'RMU Checklist'
//                                 ? loadedrmu.add(DailyrmuModel.fromjson(_data))
//                                 : loadedacdb
//                                     .add(DailyAcdbModel.fromjson(_data));
//           }

//           if (tabletitle == 'Charger Checklist') {
//             _dailyChargerdata = loadeddata;
//             notifyListeners();
//           } else if (tabletitle == 'SFU Checklist') {
//             _sfuChargerdata = loadedsfu;
//             notifyListeners();
//           } else if (tabletitle == 'PSS Checklist') {
//             _pssChargerdata = loadedpss;
//             notifyListeners();
//           } else if (tabletitle == 'Transformer Checklist') {
//             _transferChargerdata = loadedtransfer;
//             notifyListeners();
//           } else if (tabletitle == 'RMU Checklist') {
//             _rmuChargerdata = loadedrmu;
//             notifyListeners();
//           } else {
//             _acdbChargerdata = loadedacdb;
//             notifyListeners();
//           }
//         }
//       });
//     }
//   }
// }
