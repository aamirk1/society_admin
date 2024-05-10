// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ev_pmis_app/components/loading_pdf.dart';
// import 'package:ev_pmis_app/datasource/o&m_datasource/daily_transformerdatasource.dart';
// import 'package:ev_pmis_app/date_format.dart';
// import 'package:ev_pmis_app/widgets/custom_appbar.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
// import 'package:mailto/mailto.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:printing/printing.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../components/Loading_page.dart';
// import '../../datasource/dailyproject_datasource.dart';
// import '../../datasource/energymanagement_datasource.dart';
// import '../../datasource/monthlyproject_datasource.dart';
// import '../../datasource/o&m_datasource/daily_acdbdatasource.dart';
// import '../../datasource/o&m_datasource/daily_chargerManagement.dart';
// import '../../datasource/o&m_datasource/daily_pssManagement.dart';
// import '../../datasource/o&m_datasource/daily_rmudatasource.dart';
// import '../../datasource/o&m_datasource/daily_sfudatasource.dart';
// import '../../datasource/o&m_datasource/monthly_chargerdatasource.dart';
// import '../../datasource/o&m_datasource/monthly_filter.dart';
// import '../../datasource/safetychecklist_datasource.dart';
// import '../../models/daily_projectModel.dart';
// import '../../models/energy_management.dart';
// import '../../models/monthly_projectModel.dart';
// import '../../models/o&m_model/daily_acdb.dart';
// import '../../models/o&m_model/daily_charger.dart';
// import '../../models/o&m_model/daily_pss.dart';
// import '../../models/o&m_model/daily_rmu.dart';
// import '../../models/o&m_model/daily_sfu.dart';
// import '../../models/o&m_model/daily_transformer.dart';
// import '../../models/o&m_model/monthly_charger.dart';
// import '../../models/o&m_model/monthly_filter.dart';
// import '../../models/safety_checklistModel.dart';
// import '../../provider/checkbox_provider.dart';
// import '../../provider/summary_provider.dart';
// import '../../style.dart';
// import '../../utils/daily_managementlist.dart';
// import '../../widgets/nodata_available.dart';
// import '../qualitychecklist/quality_checklist.dart';

// class ViewSummary extends StatefulWidget {
//   String? depoName;
//   String? cityName;
//   String? id;
//   String? role;
//   String? selectedtab;
//   bool isHeader;
//   String? currentDate;
//   dynamic userId;
//   int? tabIndex;
//   String? titleName;
//   ViewSummary({
//     super.key,
//     required this.depoName,
//     required this.cityName,
//     required this.id,
//     this.role,
//     this.userId,
//     this.selectedtab,
//     this.currentDate,
//     this.isHeader = false,
//     this.tabIndex,
//     this.titleName,
//   });

//   @override
//   State<ViewSummary> createState() => _ViewSummaryState();
// }

// class _ViewSummaryState extends State<ViewSummary> {
//   ProgressDialog? pr;
//   String pathToOpenFile = '';
//   SummaryProvider? _summaryProvider;
//   Future<List<DailyProjectModel>>? _dailydata;
//   Future<List<EnergyManagementModel>>? _energydata;

//   //daily O&M management model
//   Future<List<DailyChargerModel>>? _dailyCharger;
//   Future<List<DailySfuModel>>? _dailySfu;
//   Future<List<DailyPssModel>>? _dailyPss;
//   Future<List<DailyTransformerModel>>? _dailyTransfer;
//   Future<List<DailyrmuModel>>? _dailyRmu;
//   Future<List<DailyAcdbModel>>? _dailyAcdb;

//   DateTime? startdate = DateTime.now();
//   DateTime? enddate = DateTime.now();
//   DateTime? rangestartDate;
//   DateTime? rangeEndDate;
//   Uint8List? pdfData;
//   String? pdfPath;

//   List<MonthlyProjectModel> monthlyProject = <MonthlyProjectModel>[];
//   List<SafetyChecklistModel> safetylisttable = <SafetyChecklistModel>[];
//   late MonthlyDataSource monthlyDataSource;
//   late SafetyChecklistDataSource _safetyChecklistDataSource;
//   late DataGridController _dataGridController;
//   // PMIS daily
//   List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
//   // O&M datasource Intance
//   late MonthlyChargerManagementDataSource _monthlyChargerManagementDataSource;
//   late MonthlyFilterManagementDataSource _monthlyFilterManagementDataSource;

//   // O&M Instance of  monthly management Model
//   List<MonthlyChargerModel> monthlyChargerManagementData =
//       <MonthlyChargerModel>[];
//   List<MonthlyFilterModel> monthlyFilterManagementData = <MonthlyFilterModel>[];

//   // O&M daily Management Model
//   List<DailyChargerModel> dailyChargerData = <DailyChargerModel>[];
//   List<DailySfuModel> dailySfuData = <DailySfuModel>[];
//   List<DailyPssModel> dailyPssData = <DailyPssModel>[];
//   List<DailyTransformerModel> dailyTransferData = <DailyTransformerModel>[];
//   List<DailyrmuModel> dailyRmuData = <DailyrmuModel>[];
//   List<DailyAcdbModel> dailyAcdbData = <DailyAcdbModel>[];

//   List<EnergyManagementModel> energymanagement = <EnergyManagementModel>[];
//   late EnergyManagementDatasource _energyManagementDatasource;
//   late DailyDataSource _dailyDataSource;

//   // O&M daily Management
//   late DailyChargerManagementDataSource _chargerDataSource;
//   late DailySFUManagementDataSource _dailySfuManagementDataSource;
//   late DailyPssManagementDataSource _dailyPssManagementDataSource;
//   late DailyTranformerDataSource _dailyTranformerDataSource;
//   late DailyRmuDataSource _dailyRmuDataSource;
//   late DailyAcdbManagementDataSource _dailyAcdbManagementDataSource;

//   List<dynamic> tabledata2 = [];
//   var alldata;
//   final ScrollController _scrollController = ScrollController();
//   bool sendReport = true;
//   CheckboxProvider? _checkboxProvider;
//   List<GridColumn> columns = [];
// // Define column names and labels for all tabs for monthly management
//   List<List<String>> monthlyColumnNames = [
//     monthlyChargerColumnName,
//     monthlyFilterColumnName,
//   ];

//   List<List<String>> monthlyColumnLabels = [
//     monthlyLabelColumnName,
//     monthlyFilterLabelColumnName,
//   ];

//   // Define column names and labels for all tabs for daily management
//   List<List<String>> tabColumnNames = [
//     chargercolumnNames,
//     sfucolumnNames,
//     psscolumnNames,
//     transformercolumnNames,
//     rmucolumnNames,
//     acdbcolumnNames
//   ];

//   List<List<String>> tabColumnLabels = [
//     chargercolumnLabelNames,
//     sfucolumnLabelNames,
//     psscolumnLabelNames,
//     transformerLabelNames,
//     rmuLabelNames,
//     acdbLabelNames
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _summaryProvider = Provider.of<SummaryProvider>(context, listen: false);
//     _checkboxProvider = Provider.of<CheckboxProvider>(context, listen: false);
//     _checkboxProvider!.fetchCcMaidId();
//     _checkboxProvider!.fetchToMaidId(widget.cityName!);
//     pr = ProgressDialog(context,
//         customBody:
//             Container(height: 200, width: 100, child: const LoadingPdf()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<String> currentColumnNames = widget.id == 'Monthly Management'
//         ? monthlyColumnNames[widget.tabIndex!]
//         : tabColumnNames[widget.tabIndex!];
//     List<String> currentColumnLabels = widget.id == 'Monthly Management'
//         ? monthlyColumnLabels[widget.tabIndex!]
//         : tabColumnLabels[widget.tabIndex!];
//     columns.clear();
//     for (String columnName in currentColumnNames) {
//       columns.add(
//         GridColumn(
//           columnName: columnName,
//           visible: true,
//           allowEditing: columnName == 'Add' ||
//                   columnName == 'Delete' ||
//                   columnName == columnName[0]
//               ? false
//               : true,
//           width: columnName == 'CN'
//               ? MediaQuery.of(context).size.width * 0.2
//               : MediaQuery.of(context).size.width *
//                   0.3, // You can adjust this width as needed
//           label: createColumnLabel(
//             currentColumnLabels[currentColumnNames.indexOf(columnName)],
//           ),
//         ),
//       );
//     }
//     widget.id == 'Daily Management'
//         ? _summaryProvider!.fetchManagementDailyData(widget.depoName!,
//             widget.titleName!, widget.userId, startdate!, enddate!)
//         : widget.id == 'Daily Report'
//             ? _summaryProvider!.fetchdailydata(
//                 widget.depoName!, widget.userId, startdate!, enddate!)
//             : widget.id == 'Energy Management'
//                 ? _summaryProvider!.fetchEnergyData(widget.cityName!,
//                     widget.depoName!, widget.userId, startdate!, enddate!)
//                 : '';

//     return Scaffold(
//         appBar: CustomAppBar(
//           isDownload: true,
//           depoName: widget.depoName,
//           title: widget.id.toString(),
//           height: 60,
//           isSync: false,
//           isCentered: false,
//           downloadFun: downloadPDF,
//           haveSend: true,
//           sendEmail: () {
//             setState(() {
//               sendReport = false;
//             });
//             _showCheckboxDialog(context, _checkboxProvider!, widget.depoName!);
//           },
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: widget.id == 'Daily Report' ||
//                       widget.id == 'Energy Management' ||
//                       widget.id == 'Daily Management'
//                   ? SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 3),
//                                 // width: 200,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(color: blue)),
//                                 child: Row(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                             onPressed: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (context) =>
//                                                     AlertDialog(
//                                                   content: SizedBox(
//                                                     width: 400,
//                                                     height: 500,
//                                                     child: SfDateRangePicker(
//                                                       view: DateRangePickerView
//                                                           .year,
//                                                       showTodayButton: false,
//                                                       showActionButtons: true,
//                                                       selectionMode:
//                                                           DateRangePickerSelectionMode
//                                                               .range,
//                                                       onSelectionChanged:
//                                                           (DateRangePickerSelectionChangedArgs
//                                                               args) {
//                                                         if (args.value
//                                                             is PickerDateRange) {
//                                                           rangestartDate = args
//                                                               .value.startDate;
//                                                           rangeEndDate = args
//                                                               .value.endDate;
//                                                         }
//                                                       },
//                                                       onSubmit: (value) {
//                                                         dailyproject.clear();
//                                                         setState(() {
//                                                           startdate =
//                                                               DateTime.parse(
//                                                                   rangestartDate
//                                                                       .toString());
//                                                           enddate = DateTime
//                                                               .parse(rangeEndDate
//                                                                   .toString());
//                                                         });
//                                                         Navigator.pop(context);
//                                                       },
//                                                       onCancel: () {
//                                                         Navigator.pop(context);
//                                                       },
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             icon: const Icon(Icons.today)),
//                                         Text(widget.id == 'Monthly Report' ||
//                                                 widget.id ==
//                                                     'Monthly Management'
//                                             ? DateFormat.yMMMM()
//                                                 .format(startdate!)
//                                             : DateFormat.yMMMMd()
//                                                 .format(startdate!))
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 // width: 180,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(color: blue)),
//                                 child: Row(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           DateFormat.yMMMMd().format(enddate!),
//                                           textAlign: TextAlign.center,
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           width: 150,
//                           height: 40,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(color: blue)),
//                           child: Row(
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         content: SizedBox(
//                                           width: 400,
//                                           height: 500,
//                                           child: SfDateRangePicker(
//                                             view: DateRangePickerView.year,
//                                             showTodayButton: false,
//                                             showActionButtons: true,
//                                             selectionMode:
//                                                 DateRangePickerSelectionMode
//                                                     .single,
//                                             onSelectionChanged:
//                                                 (DateRangePickerSelectionChangedArgs
//                                                     args) {
//                                               if (args.value
//                                                   is PickerDateRange) {
//                                                 rangestartDate =
//                                                     args.value.startDate;
//                                               }
//                                             },
//                                             onSubmit: (value) {
//                                               setState(() {
//                                                 startdate = DateTime.parse(
//                                                     value.toString());
//                                               });
//                                               Navigator.pop(context);
//                                             },
//                                             onCancel: () {
//                                               Navigator.pop(context);
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   icon: const Icon(Icons.today)),
//                               Text(widget.id == 'Monthly Report' ||
//                                       widget.id == 'Monthly Management'
//                                   ? DateFormat.yMMMM().format(startdate!)
//                                   : DateFormat.yMMMMd().format(startdate!))
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//             widget.id == 'Monthly Report'
//                 ? Expanded(
//                     child: StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('MonthlyProjectReport2')
//                             .doc('${widget.depoName}')
//                             // .collection('AllMonthData')
//                             .collection('userId')
//                             .doc(widget.userId)
//                             .collection('Monthly Data')
//                             // .collection('MonthData')
//                             .doc(DateFormat.yMMM().format(startdate!))
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const LoadingPage();
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.exists == false) {
//                             return const NodataAvailable();
//                           } else {
//                             alldata = snapshot.data!['data'] as List<dynamic>;
//                             monthlyProject.clear();
//                             alldata.forEach((element) {
//                               monthlyProject
//                                   .add(MonthlyProjectModel.fromjson(element));
//                               monthlyDataSource =
//                                   MonthlyDataSource(monthlyProject, context);
//                               _dataGridController = DataGridController();
//                             });
//                             return Column(
//                               children: [
//                                 Expanded(
//                                     child: SfDataGridTheme(
//                                   data: SfDataGridThemeData(
//                                       headerColor: white, gridLineColor: blue),
//                                   child: SfDataGrid(
//                                       source: monthlyDataSource,
//                                       allowEditing: false,
//                                       frozenColumnsCount: 1,
//                                       gridLinesVisibility:
//                                           GridLinesVisibility.both,
//                                       headerGridLinesVisibility:
//                                           GridLinesVisibility.both,
//                                       selectionMode: SelectionMode.single,
//                                       navigationMode: GridNavigationMode.cell,
//                                       columnWidthMode: ColumnWidthMode.auto,
//                                       editingGestureType:
//                                           EditingGestureType.tap,
//                                       controller: _dataGridController,
//                                       onQueryRowHeight: (details) {
//                                         return details.getIntrinsicRowHeight(
//                                             details.rowIndex);
//                                       },
//                                       columns: [
//                                         GridColumn(
//                                           columnName: 'ActivityNo',
//                                           autoFitPadding: tablepadding,
//                                           allowEditing: true,
//                                           width: 80,
//                                           label: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                               'Sr. No ',
//                                               overflow:
//                                                   TextOverflow.values.first,
//                                               textAlign: TextAlign.center,
//                                               style: tableheaderwhitecolor,
//                                             ),
//                                           ),
//                                         ),
//                                         GridColumn(
//                                           columnName: 'ActivityDetails',
//                                           autoFitPadding: tablepadding,
//                                           allowEditing: true,
//                                           width: 240,
//                                           label: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             alignment: Alignment.center,
//                                             child: Text('Activities Details',
//                                                 textAlign: TextAlign.center,
//                                                 overflow:
//                                                     TextOverflow.values.first,
//                                                 style: tableheaderwhitecolor),
//                                           ),
//                                         ),
//                                         GridColumn(
//                                           columnName: 'Progress',
//                                           autoFitPadding: tablepadding,
//                                           allowEditing: true,
//                                           width: 250,
//                                           label: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             alignment: Alignment.center,
//                                             child: Text('Progress',
//                                                 overflow:
//                                                     TextOverflow.values.first,
//                                                 style: tableheaderwhitecolor
//                                                 //    textAlign: TextAlign.center,
//                                                 ),
//                                           ),
//                                         ),
//                                         GridColumn(
//                                           columnName: 'Status',
//                                           autoFitPadding: tablepadding,
//                                           allowEditing: true,
//                                           width: 250,
//                                           label: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             alignment: Alignment.center,
//                                             child: Text('Remark/Status',
//                                                 overflow:
//                                                     TextOverflow.values.first,
//                                                 style: tableheaderwhitecolor
//                                                 //    textAlign: TextAlign.center,
//                                                 ),
//                                           ),
//                                         ),
//                                         GridColumn(
//                                           columnName: 'Action',
//                                           autoFitPadding: tablepadding,
//                                           allowEditing: true,
//                                           width: 250,
//                                           label: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                                 'Next Month Action Plan',
//                                                 overflow:
//                                                     TextOverflow.values.first,
//                                                 style: tableheaderwhitecolor
//                                                 //    textAlign: TextAlign.center,
//                                                 ),
//                                           ),
//                                         ),
//                                       ]),
//                                 )),
//                               ],
//                             );
//                           }
//                         }),
//                   )
//                 : widget.id == 'Daily Report'
//                     ? Expanded(
//                         child: Consumer<SummaryProvider>(
//                           builder: (context, value, child) {
//                             return FutureBuilder(
//                                 future: _dailydata,
//                                 builder: (context, snapshot) {
//                                   if (value.dailydata.isNotEmpty) {
//                                     dailyproject = value.dailydata;
//                                     _dailyDataSource = DailyDataSource(
//                                         dailyproject,
//                                         context,
//                                         widget.cityName!,
//                                         widget.depoName!,
//                                         widget.userId,
//                                         selecteddate.toString());

//                                     _dataGridController = DataGridController();

//                                     return SfDataGridTheme(
//                                       data: SfDataGridThemeData(
//                                           headerColor: white,
//                                           gridLineColor: blue),
//                                       child: SfDataGrid(
//                                           source: _dailyDataSource,
//                                           allowEditing: false,
//                                           frozenColumnsCount: 2,
//                                           gridLinesVisibility:
//                                               GridLinesVisibility.both,
//                                           headerGridLinesVisibility:
//                                               GridLinesVisibility.both,
//                                           selectionMode: SelectionMode.single,
//                                           navigationMode:
//                                               GridNavigationMode.cell,
//                                           columnWidthMode: ColumnWidthMode.auto,
//                                           editingGestureType:
//                                               EditingGestureType.tap,
//                                           controller: _dataGridController,
//                                           onQueryRowHeight: (details) {
//                                             return details
//                                                 .getIntrinsicRowHeight(
//                                                     details.rowIndex);
//                                           },
//                                           columns: [
//                                             GridColumn(
//                                               columnName: 'Date',
//                                               visible: true,
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: true,
//                                               width: 150,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('Date',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     textAlign: TextAlign.center,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               visible: false,
//                                               columnName: 'SiNo',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: true,
//                                               width: 70,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('SI No.',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     textAlign: TextAlign.center,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               columnName: 'TypeOfActivity',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: true,
//                                               width: 200,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('Type of Activity',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               columnName: 'ActivityDetails',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: true,
//                                               width: 220,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('Activity Details',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               columnName: 'Progress',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: true,
//                                               width: 320,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('Progress',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               columnName: 'Status',
//                                               allowEditing: true,
//                                               width: 320,
//                                               label: Container(
//                                                 alignment: Alignment.center,
//                                                 child: Text('Remark / Status',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               visible: false,
//                                               columnName: 'upload',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: false,
//                                               width: 150,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('Upload Image',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               columnName: 'view',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: false,
//                                               width: 120,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('View Image',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               visible: false,
//                                               columnName: 'Add',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: false,
//                                               width: 120,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('Add Row',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                             GridColumn(
//                                               columnName: 'Delete',
//                                               autoFitPadding: tablepadding,
//                                               allowEditing: true,
//                                               visible: false,
//                                               width: 120,
//                                               label: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 alignment: Alignment.center,
//                                                 child: Text('Delete Row',
//                                                     overflow: TextOverflow
//                                                         .values.first,
//                                                     style: tableheaderwhitecolor
//                                                     //    textAlign: TextAlign.center,
//                                                     ),
//                                               ),
//                                             ),
//                                           ]),
//                                     );
//                                   } else {
//                                     return const Center(
//                                       child: Text(
//                                           'No Data Available For Selected Date'),
//                                     );
//                                   }
//                                 }

//                                 //1              },
//                                 );
//                           },
//                         ),
//                       )
//                     : widget.id == 'Quality Checklist'
//                         ? Expanded(
//                             child: QualityChecklist(
//                                 currentDate:
//                                     DateFormat.yMMMMd().format(startdate!),
//                                 isHeader: widget.isHeader,
//                                 cityName: widget.cityName,
//                                 depoName: widget.depoName),
//                           )
//                         : widget.id == 'Daily Management'
//                             ? Expanded(
//                                 child: Consumer<SummaryProvider>(
//                                   builder: (context, value, child) {
//                                     return FutureBuilder(
//                                         future: widget.tabIndex == 0
//                                             ? _dailyCharger
//                                             : widget.tabIndex == 1
//                                                 ? _dailySfu
//                                                 : widget.tabIndex == 2
//                                                     ? _dailyPss
//                                                     : widget.tabIndex == 3
//                                                         ? _dailyTransfer
//                                                         : widget.tabIndex == 4
//                                                             ? _dailyRmu
//                                                             : _dailyAcdb,
//                                         builder: (context, snapshot) {
//                                           if (value.dailyCharger.isNotEmpty ||
//                                               value.sfuCharger.isNotEmpty ||
//                                               value.pssCharger.isNotEmpty ||
//                                               value.transformerCharger
//                                                   .isNotEmpty ||
//                                               value.rmuCharger.isNotEmpty ||
//                                               value.acdbCharger.isNotEmpty) {
//                                             dailyChargerData =
//                                                 value.dailyCharger;

//                                             dailySfuData = value.sfuCharger;
//                                             dailyPssData = value.pssCharger;
//                                             dailyTransferData =
//                                                 value.transformerCharger;
//                                             dailyRmuData = value.rmuCharger;
//                                             dailyAcdbData = value.acdbCharger;

//                                             _chargerDataSource =
//                                                 DailyChargerManagementDataSource(
//                                                     dailyChargerData,
//                                                     context,
//                                                     widget.cityName!,
//                                                     widget.depoName!,
//                                                     selecteddate!.toString(),
//                                                     widget.userId);

//                                             _dailySfuManagementDataSource =
//                                                 DailySFUManagementDataSource(
//                                                     dailySfuData,
//                                                     context,
//                                                     widget.cityName!,
//                                                     widget.depoName!,
//                                                     selecteddate!.toString(),
//                                                     widget.userId);

//                                             _dailyPssManagementDataSource =
//                                                 DailyPssManagementDataSource(
//                                                     dailyPssData,
//                                                     context,
//                                                     widget.cityName!,
//                                                     widget.depoName!,
//                                                     selecteddate!.toString(),
//                                                     widget.userId);

//                                             _dailyTranformerDataSource =
//                                                 DailyTranformerDataSource(
//                                                     dailyTransferData,
//                                                     context,
//                                                     widget.cityName!,
//                                                     widget.depoName!,
//                                                     selecteddate!.toString(),
//                                                     widget.userId);

//                                             _dailyRmuDataSource =
//                                                 DailyRmuDataSource(
//                                                     dailyRmuData,
//                                                     context,
//                                                     widget.cityName!,
//                                                     widget.depoName!,
//                                                     selecteddate!.toString(),
//                                                     widget.userId);

//                                             _dailyAcdbManagementDataSource =
//                                                 DailyAcdbManagementDataSource(
//                                                     dailyAcdbData,
//                                                     context,
//                                                     widget.cityName!,
//                                                     widget.depoName!,
//                                                     selecteddate!.toString(),
//                                                     widget.userId);

//                                             _dataGridController =
//                                                 DataGridController();

//                                             return SfDataGridTheme(
//                                                 data: SfDataGridThemeData(
//                                                     headerColor: white,
//                                                     gridLineColor: blue),
//                                                 child: SfDataGrid(
//                                                     source: widget.tabIndex == 0
//                                                         ? _chargerDataSource
//                                                         : widget.tabIndex == 1
//                                                             ? _dailySfuManagementDataSource
//                                                             : widget.tabIndex ==
//                                                                     2
//                                                                 ? _dailyPssManagementDataSource
//                                                                 : widget.tabIndex ==
//                                                                         3
//                                                                     ? _dailyTranformerDataSource
//                                                                     : widget.tabIndex ==
//                                                                             4
//                                                                         ? _dailyRmuDataSource
//                                                                         : _dailyAcdbManagementDataSource,
//                                                     allowEditing: false,
//                                                     frozenColumnsCount: 2,
//                                                     gridLinesVisibility:
//                                                         GridLinesVisibility
//                                                             .both,
//                                                     headerGridLinesVisibility:
//                                                         GridLinesVisibility
//                                                             .both,
//                                                     selectionMode:
//                                                         SelectionMode.single,
//                                                     navigationMode:
//                                                         GridNavigationMode.cell,
//                                                     columnWidthMode:
//                                                         ColumnWidthMode.auto,
//                                                     editingGestureType:
//                                                         EditingGestureType.tap,
//                                                     controller:
//                                                         _dataGridController,
//                                                     onQueryRowHeight:
//                                                         (details) {
//                                                       return details
//                                                           .getIntrinsicRowHeight(
//                                                               details.rowIndex);
//                                                     },
//                                                     columns: columns));
//                                           } else {
//                                             return const Center(
//                                               child: Text(
//                                                   'No Data Available For Selected Date'),
//                                             );
//                                           }
//                                         }

//                                         //1              },
//                                         );
//                                   },
//                                 ),
//                               )
//                             : widget.id == 'Monthly Management'
//                                 ? Expanded(
//                                     child: StreamBuilder(
//                                         stream: FirebaseFirestore.instance
//                                             .collection('MonthlyManagementPage')
//                                             .doc(widget.depoName)
//                                             .collection('Checklist Name')
//                                             .doc(widget.titleName)
//                                             .collection(DateFormat.yMMM()
//                                                 .format(startdate!))
//                                             .doc(widget.userId)
//                                             .snapshots(),
//                                         builder: (context, snapshot) {
//                                           if (snapshot.connectionState ==
//                                               ConnectionState.waiting) {
//                                             return const LoadingPage();
//                                           } else if (!snapshot.hasData ||
//                                               snapshot.data!.exists == false) {
//                                             return const NodataAvailable();
//                                           } else {
//                                             alldata = snapshot.data!['data']
//                                                 as List<dynamic>;
//                                             monthlyChargerManagementData
//                                                 .clear();
//                                             monthlyFilterManagementData.clear();

//                                             if (widget.tabIndex == 0) {
//                                               alldata.forEach((element) {
//                                                 monthlyChargerManagementData
//                                                     .add(MonthlyChargerModel
//                                                         .fromjson(element));

//                                                 _monthlyChargerManagementDataSource =
//                                                     MonthlyChargerManagementDataSource(
//                                                         monthlyChargerManagementData,
//                                                         context,
//                                                         widget.cityName!,
//                                                         widget.depoName!,
//                                                         DateFormat.yMMM()
//                                                             .format(startdate!),
//                                                         widget.userId);
//                                                 _dataGridController =
//                                                     DataGridController();
//                                               });
//                                             } else {
//                                               alldata.forEach((element) {
//                                                 monthlyFilterManagementData.add(
//                                                     MonthlyFilterModel.fromjson(
//                                                         element));

//                                                 _monthlyFilterManagementDataSource =
//                                                     MonthlyFilterManagementDataSource(
//                                                         monthlyFilterManagementData,
//                                                         context,
//                                                         widget.cityName!,
//                                                         widget.depoName!,
//                                                         DateFormat.yMMM()
//                                                             .format(startdate!),
//                                                         widget.userId);
//                                                 _dataGridController =
//                                                     DataGridController();
//                                               });
//                                             }
//                                             return Column(children: [
//                                               Expanded(
//                                                   child: SfDataGridTheme(
//                                                       data: SfDataGridThemeData(
//                                                           headerColor: white,
//                                                           gridLineColor: blue),
//                                                       child: SfDataGrid(
//                                                           source: widget.tabIndex ==
//                                                                   0
//                                                               ? _monthlyChargerManagementDataSource
//                                                               : _monthlyFilterManagementDataSource,
//                                                           allowEditing: false,
//                                                           frozenColumnsCount: 1,
//                                                           gridLinesVisibility:
//                                                               GridLinesVisibility
//                                                                   .both,
//                                                           headerGridLinesVisibility:
//                                                               GridLinesVisibility
//                                                                   .both,
//                                                           selectionMode:
//                                                               SelectionMode
//                                                                   .single,
//                                                           navigationMode:
//                                                               GridNavigationMode
//                                                                   .cell,
//                                                           columnWidthMode:
//                                                               ColumnWidthMode
//                                                                   .auto,
//                                                           editingGestureType:
//                                                               EditingGestureType
//                                                                   .tap,
//                                                           controller:
//                                                               _dataGridController,
//                                                           onQueryRowHeight:
//                                                               (details) {
//                                                             return details
//                                                                 .getIntrinsicRowHeight(
//                                                                     details
//                                                                         .rowIndex);
//                                                           },
//                                                           columns: columns)))
//                                             ]);
//                                           }
//                                         }),
//                                   )
//                                 : widget.id == 'Energy Management'
//                                     ? Expanded(
//                                         child: Consumer<SummaryProvider>(
//                                           builder: (context, value, child) {
//                                             return FutureBuilder(
//                                               future: _energydata,
//                                               builder: (context, snapshot) {
//                                                 if (snapshot.hasData) {
//                                                   if (snapshot.data == null ||
//                                                       snapshot.data!.length ==
//                                                           0) {
//                                                     return const Center(
//                                                       child: Text(
//                                                         "No Data Found!!",
//                                                         style: TextStyle(
//                                                             fontSize: 25.0),
//                                                       ),
//                                                     );
//                                                   } else {
//                                                     return const LoadingPage();
//                                                   }
//                                                 } else {
//                                                   energymanagement =
//                                                       value.energyData;

//                                                   _energyManagementDatasource =
//                                                       EnergyManagementDatasource(
//                                                           energymanagement,
//                                                           context,
//                                                           widget.userId,
//                                                           widget.cityName,
//                                                           widget.depoName);

//                                                   _dataGridController =
//                                                       DataGridController();

//                                                   return Column(
//                                                     children: [
//                                                       Container(
//                                                         margin: const EdgeInsets
//                                                             .all(5.0),
//                                                         height: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .height *
//                                                             0.48,
//                                                         child: SfDataGridTheme(
//                                                             data: SfDataGridThemeData(
//                                                                 gridLineColor:
//                                                                     blue,
//                                                                 gridLineStrokeWidth:
//                                                                     2,
//                                                                 frozenPaneLineColor:
//                                                                     blue,
//                                                                 frozenPaneLineWidth:
//                                                                     3),
//                                                             child: SfDataGrid(
//                                                               source:
//                                                                   _energyManagementDatasource,
//                                                               allowEditing:
//                                                                   false,
//                                                               frozenColumnsCount:
//                                                                   1,
//                                                               gridLinesVisibility:
//                                                                   GridLinesVisibility
//                                                                       .both,
//                                                               headerGridLinesVisibility:
//                                                                   GridLinesVisibility
//                                                                       .both,
//                                                               headerRowHeight:
//                                                                   40,

//                                                               selectionMode:
//                                                                   SelectionMode
//                                                                       .single,
//                                                               navigationMode:
//                                                                   GridNavigationMode
//                                                                       .cell,
//                                                               columnWidthMode:
//                                                                   ColumnWidthMode
//                                                                       .auto,
//                                                               editingGestureType:
//                                                                   EditingGestureType
//                                                                       .tap,
//                                                               controller:
//                                                                   _dataGridController,
//                                                               // onQueryRowHeight:
//                                                               //     (details) {
//                                                               //   return details
//                                                               //       .getIntrinsicRowHeight(
//                                                               //           details
//                                                               //               .rowIndex);
//                                                               // },
//                                                               columns: [
//                                                                 GridColumn(
//                                                                   visible: true,
//                                                                   columnName:
//                                                                       'srNo',
//                                                                   allowEditing:
//                                                                       false,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Sr No',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor
//                                                                         //    textAlign: TextAlign.center,
//                                                                         ),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'DepotName',
//                                                                   width: 180,
//                                                                   allowEditing:
//                                                                       false,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Depot Name',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'VehicleNo',
//                                                                   width: 180,
//                                                                   allowEditing:
//                                                                       true,
//                                                                   label:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets.all(
//                                                                             8.0),
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Vehicle No',
//                                                                         textAlign:
//                                                                             TextAlign
//                                                                                 .center,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'pssNo',
//                                                                   width: 80,
//                                                                   allowEditing:
//                                                                       true,
//                                                                   label:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets.all(
//                                                                             8.0),
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'PSS No',
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'chargerId',
//                                                                   width: 80,
//                                                                   allowEditing:
//                                                                       true,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Charger ID',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'startSoc',
//                                                                   allowEditing:
//                                                                       true,
//                                                                   width: 80,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Start SOC',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'endSoc',
//                                                                   allowEditing:
//                                                                       true,
//                                                                   columnWidthMode:
//                                                                       ColumnWidthMode
//                                                                           .fitByCellValue,
//                                                                   width: 80,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'End SOC',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'startDate',
//                                                                   allowEditing:
//                                                                       false,
//                                                                   width: 230,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Start Date & Time',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'endDate',
//                                                                   allowEditing:
//                                                                       false,
//                                                                   width: 230,
//                                                                   label:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets.all(
//                                                                             8.0),
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child:
//                                                                         Container(
//                                                                       alignment:
//                                                                           Alignment
//                                                                               .center,
//                                                                       child: Text(
//                                                                           'End Date & Time',
//                                                                           overflow: TextOverflow
//                                                                               .values
//                                                                               .first,
//                                                                           style:
//                                                                               tableheaderwhitecolor),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'totalTime',
//                                                                   allowEditing:
//                                                                       false,
//                                                                   width: 180,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Total time of Charging',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'energyConsumed',
//                                                                   allowEditing:
//                                                                       true,
//                                                                   width: 160,
//                                                                   label:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets.all(
//                                                                             8.0),
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Engery Consumed (inkW)',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         textAlign:
//                                                                             TextAlign
//                                                                                 .center,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'timeInterval',
//                                                                   allowEditing:
//                                                                       false,
//                                                                   width: 150,
//                                                                   label:
//                                                                       Container(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Interval',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'Add',
//                                                                   visible:
//                                                                       false,
//                                                                   autoFitPadding:
//                                                                       const EdgeInsets
//                                                                               .all(
//                                                                           8.0),
//                                                                   allowEditing:
//                                                                       false,
//                                                                   width: 120,
//                                                                   label:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets.all(
//                                                                             8.0),
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Add Row',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor
//                                                                         //    textAlign: TextAlign.center,
//                                                                         ),
//                                                                   ),
//                                                                 ),
//                                                                 GridColumn(
//                                                                   columnName:
//                                                                       'Delete',
//                                                                   visible:
//                                                                       false,
//                                                                   autoFitPadding:
//                                                                       const EdgeInsets
//                                                                               .all(
//                                                                           8.0),
//                                                                   allowEditing:
//                                                                       false,
//                                                                   width: 120,
//                                                                   label:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets.all(
//                                                                             8.0),
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .center,
//                                                                     child: Text(
//                                                                         'Delete Row',
//                                                                         overflow: TextOverflow
//                                                                             .values
//                                                                             .first,
//                                                                         style:
//                                                                             tableheaderwhitecolor),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             )),
//                                                       ),
//                                                       Consumer<SummaryProvider>(
//                                                           builder: (context,
//                                                               value, child) {
//                                                         return Container(
//                                                           margin:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   bottom: 5.0),
//                                                           height: 300,
//                                                           width: MediaQuery.of(
//                                                                   context)
//                                                               .size
//                                                               .width,
//                                                           child: Scrollbar(
//                                                             thickness: 3,
//                                                             radius: const Radius
//                                                                 .circular(
//                                                               1,
//                                                             ),
//                                                             thumbVisibility:
//                                                                 true,
//                                                             trackVisibility:
//                                                                 true,
//                                                             interactive: true,
//                                                             scrollbarOrientation:
//                                                                 ScrollbarOrientation
//                                                                     .bottom,
//                                                             controller:
//                                                                 _scrollController,
//                                                             child: ListView
//                                                                 .builder(
//                                                                     scrollDirection:
//                                                                         Axis
//                                                                             .horizontal,
//                                                                     controller:
//                                                                         _scrollController,
//                                                                     itemCount:
//                                                                         1,
//                                                                     shrinkWrap:
//                                                                         true,
//                                                                     itemBuilder:
//                                                                         (context,
//                                                                             index) {
//                                                                       return Container(
//                                                                         height:
//                                                                             250,
//                                                                         margin: const EdgeInsets.only(
//                                                                             top:
//                                                                                 10.0),
//                                                                         width: _energyManagementDatasource.dataGridRows.length *
//                                                                             110,
//                                                                         child:
//                                                                             BarChart(
//                                                                           swapAnimationCurve:
//                                                                               Curves.linear,
//                                                                           swapAnimationDuration:
//                                                                               const Duration(milliseconds: 1000),
//                                                                           BarChartData(
//                                                                             backgroundColor:
//                                                                                 white,
//                                                                             barTouchData:
//                                                                                 BarTouchData(
//                                                                               enabled: true,
//                                                                               allowTouchBarBackDraw: true,
//                                                                               touchTooltipData: BarTouchTooltipData(
//                                                                                 tooltipRoundedRadius: 5,
//                                                                                 tooltipBgColor: Colors.transparent,
//                                                                                 tooltipMargin: 5,
//                                                                               ),
//                                                                             ),
//                                                                             minY:
//                                                                                 0,
//                                                                             titlesData:
//                                                                                 FlTitlesData(
//                                                                               bottomTitles: AxisTitles(
//                                                                                 sideTitles: SideTitles(
//                                                                                   showTitles: true,
//                                                                                   getTitlesWidget: (data1, meta) {
//                                                                                     return Text(
//                                                                                       value.intervalData[data1.toInt()].toString(),
//                                                                                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                                                                                     );
//                                                                                   },
//                                                                                 ),
//                                                                               ),
//                                                                               rightTitles: AxisTitles(
//                                                                                 sideTitles: SideTitles(showTitles: false),
//                                                                               ),
//                                                                               topTitles: AxisTitles(
//                                                                                 sideTitles: SideTitles(
//                                                                                   showTitles: false,
//                                                                                   getTitlesWidget: (data2, meta) {
//                                                                                     return Text(
//                                                                                       value.energyConsumedData[data2.toInt()],
//                                                                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                                                                     );
//                                                                                   },
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                             gridData:
//                                                                                 FlGridData(
//                                                                               drawHorizontalLine: false,
//                                                                               drawVerticalLine: false,
//                                                                             ),
//                                                                             borderData:
//                                                                                 FlBorderData(
//                                                                               border: const Border(
//                                                                                 left: BorderSide(),
//                                                                                 bottom: BorderSide(),
//                                                                               ),
//                                                                             ),
//                                                                             maxY: (value.intervalData.isEmpty && value.energyConsumedData.isEmpty)
//                                                                                 ? 50000.0
//                                                                                 : value.energyConsumedData.reduce((max, current) => max > current ? max : current + 5000.0),
//                                                                             barGroups:
//                                                                                 barChartGroupData(value.energyConsumedData),
//                                                                           ),
//                                                                         ),
//                                                                       );
//                                                                     }),
//                                                           ),
//                                                         );
//                                                       })
//                                                     ],
//                                                   );
//                                                 }
//                                               },
//                                             );
//                                           },
//                                         ),
//                                       )
//                                     : Expanded(
//                                         child: StreamBuilder(
//                                           stream: FirebaseFirestore.instance
//                                               .collection(
//                                                   'SafetyChecklistTable2')
//                                               .doc(widget.depoName!)
//                                               .collection('userId')
//                                               .doc(widget.userId)
//                                               .collection('date')
//                                               .doc(DateFormat.yMMMMd()
//                                                   .format(startdate!))
//                                               .snapshots(),
//                                           builder: (context, snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return const LoadingPage();
//                                             }
//                                             if (!snapshot.hasData ||
//                                                 snapshot.data!.exists ==
//                                                     false) {
//                                               return const NodataAvailable();
//                                             } else {
//                                               alldata = '';
//                                               alldata = snapshot.data!['data']
//                                                   as List<dynamic>;
//                                               safetylisttable.clear();
//                                               alldata.forEach((element) {
//                                                 safetylisttable.add(
//                                                     SafetyChecklistModel
//                                                         .fromJson(element));
//                                                 _safetyChecklistDataSource =
//                                                     SafetyChecklistDataSource(
//                                                         safetylisttable,
//                                                         widget.cityName!,
//                                                         widget.depoName!,
//                                                         widget.userId,
//                                                         DateFormat.yMMMMd()
//                                                             .format(
//                                                                 startdate!));
//                                                 _dataGridController =
//                                                     DataGridController();
//                                               });
//                                               return SfDataGridTheme(
//                                                 data: SfDataGridThemeData(
//                                                     gridLineColor: blue,
//                                                     gridLineStrokeWidth: 2,
//                                                     frozenPaneLineColor: blue,
//                                                     frozenPaneLineWidth: 3),
//                                                 child: SfDataGrid(
//                                                   source:
//                                                       _safetyChecklistDataSource,
//                                                   //key: key,
//                                                   allowEditing: false,
//                                                   frozenColumnsCount: 1,
//                                                   gridLinesVisibility:
//                                                       GridLinesVisibility.both,
//                                                   headerGridLinesVisibility:
//                                                       GridLinesVisibility.both,
//                                                   selectionMode:
//                                                       SelectionMode.single,
//                                                   navigationMode:
//                                                       GridNavigationMode.cell,
//                                                   columnWidthMode:
//                                                       ColumnWidthMode.auto,
//                                                   editingGestureType:
//                                                       EditingGestureType.tap,
//                                                   controller:
//                                                       _dataGridController,
//                                                   onQueryRowHeight: (details) {
//                                                     return details
//                                                         .getIntrinsicRowHeight(
//                                                             details.rowIndex);
//                                                   },
//                                                   columns: [
//                                                     GridColumn(
//                                                       columnName: 'srNo',
//                                                       autoFitPadding:
//                                                           tablepadding,
//                                                       allowEditing: true,
//                                                       width: 80,
//                                                       label: Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 horizontal:
//                                                                     8.0),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text('Sr No',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .values
//                                                                     .first,
//                                                             style:
//                                                                 tableheaderwhitecolor),
//                                                       ),
//                                                     ),
//                                                     GridColumn(
//                                                       width: 550,
//                                                       columnName: 'Details',
//                                                       allowEditing: true,
//                                                       label: Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 horizontal:
//                                                                     8.0),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text(
//                                                             'Details of Enclosure ',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .values
//                                                                     .first,
//                                                             style:
//                                                                 tableheaderwhitecolor),
//                                                       ),
//                                                     ),
//                                                     GridColumn(
//                                                       columnName: 'Status',
//                                                       allowEditing: true,
//                                                       width: 230,
//                                                       label: Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text(
//                                                             'Status of Submission of information/ documents ',
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               fontSize: 16,
//                                                               color: white,
//                                                             )),
//                                                       ),
//                                                     ),
//                                                     GridColumn(
//                                                       columnName: 'Remark',
//                                                       allowEditing: true,
//                                                       width: 230,
//                                                       label: Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 horizontal:
//                                                                     8.0),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text('Remarks',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .values
//                                                                     .first,
//                                                             style:
//                                                                 tableheaderwhitecolor),
//                                                       ),
//                                                     ),
//                                                     GridColumn(
//                                                       columnName: 'Photo',
//                                                       allowEditing: false,
//                                                       visible: false,
//                                                       width: 160,
//                                                       label: Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 horizontal:
//                                                                     8.0),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text(
//                                                             'Upload Photo',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .values
//                                                                     .first,
//                                                             style:
//                                                                 tableheaderwhitecolor),
//                                                       ),
//                                                     ),
//                                                     GridColumn(
//                                                       columnName: 'ViewPhoto',
//                                                       allowEditing: false,
//                                                       width: 180,
//                                                       label: Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 horizontal:
//                                                                     8.0),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text(
//                                                             'View Photo',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .values
//                                                                     .first,
//                                                             style:
//                                                                 tableheaderwhitecolor),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       )
//           ],
//         ));
//   }

//   Future<Uint8List> _generateEnergyPDF() async {
//     final headerStyle =
//         pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

//     final fontData1 =
//         await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
//     final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

//     const cellStyle = pw.TextStyle(
//       color: PdfColors.black,
//       fontSize: 14,
//     );

//     final profileImage = pw.MemoryImage(
//       (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
//     );

//     List<pw.TableRow> rows = [];

//     rows.add(
//       pw.TableRow(
//         children: [
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Depot Name',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.only(
//                   top: 4, bottom: 4, left: 2, right: 2),
//               child: pw.Center(
//                   child: pw.Text('Vehicle No',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('PSS No.',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Charger Id',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Start SOC',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'End SOC',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Start Date & Time',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'End Date & Time',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Total time of charging',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Energy Consumed',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Interval',
//               ))),
//         ],
//       ),
//     );

//     if (energymanagement.isNotEmpty) {
//       for (EnergyManagementModel mapData in energymanagement) {
//         //Text Rows of PDF Table
//         rows.add(pw.TableRow(children: [
//           pw.Container(
//               padding: const pw.EdgeInsets.all(3.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.depotName.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(5.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.vehicleNo,
//                       style: const pw.TextStyle(
//                         fontSize: 13,
//                       )))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.pssNo.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.chargerId.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.startSoc.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.endSoc.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.startDate.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.endDate.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.totalTime.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.energyConsumed.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.timeInterval.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//         ]));
//       }
//     }

//     final pdf = pw.Document(
//       pageMode: PdfPageMode.outlines,
//     );

//     //First Half Page

//     pdf.addPage(
//       pw.MultiPage(
//         theme: pw.ThemeData.withFont(
//             base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
//         pageFormat: const PdfPageFormat(1300, 900,
//             marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
//         orientation: pw.PageOrientation.natural,
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         header: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               decoration: const pw.BoxDecoration(
//                   border: pw.Border(
//                       bottom:
//                           pw.BorderSide(width: 0.5, color: PdfColors.grey))),
//               child: pw.Column(children: [
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('Demand Energy Report',
//                           textScaleFactor: 2,
//                           style: const pw.TextStyle(color: PdfColors.blue700)),
//                       pw.Container(
//                         width: 120,
//                         height: 120,
//                         child: pw.Image(profileImage),
//                       ),
//                     ]),
//               ]));
//         },
//         footer: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//               child: pw.Text('User ID - ${widget.userId}',
//                   // 'Page ${context.pageNumber} of ${context.pagesCount}',
//                   style: pw.Theme.of(context)
//                       .defaultTextStyle
//                       .copyWith(color: PdfColors.black)));
//         },
//         build: (pw.Context context) => <pw.Widget>[
//           pw.Column(children: [
//             pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Place : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text: '${widget.cityName} / ${widget.depoName}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Date : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text:
//                             '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     pw.TextSpan(
//                         text: 'UserID : ${widget.userId}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15)),
//                   ])),
//                 ]),
//             pw.SizedBox(height: 20)
//           ]),
//           pw.SizedBox(height: 10),
//           pw.Table(
//               columnWidths: {
//                 0: const pw.FixedColumnWidth(100),
//                 1: const pw.FixedColumnWidth(50),
//                 2: const pw.FixedColumnWidth(50),
//                 3: const pw.FixedColumnWidth(50),
//                 4: const pw.FixedColumnWidth(70),
//                 5: const pw.FixedColumnWidth(70),
//                 6: const pw.FixedColumnWidth(70),
//                 7: const pw.FixedColumnWidth(70),
//                 8: const pw.FixedColumnWidth(70),
//                 9: const pw.FixedColumnWidth(70),
//                 10: const pw.FixedColumnWidth(70),
//               },
//               defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
//               tableWidth: pw.TableWidth.max,
//               border: pw.TableBorder.all(),
//               children: rows)
//         ],
//       ),
//     );

//     pdfData = await pdf.save();
//     pdfPath = 'DemandEnergyReport.pdf';

//     return pdfData!;
//   }

//   Future<Uint8List> _generateSafetyPDF() async {
//     bool isImageEmpty = false;
//     pr!.show();

//     final headerStyle =
//         pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

//     final fontData1 =
//         await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
//     final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

//     const cellStyle = pw.TextStyle(
//       color: PdfColors.black,
//       fontSize: 14,
//     );

//     final profileImage = pw.MemoryImage(
//       (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
//     );

//     final selectedDate = DateFormat.yMMMMd().format(startdate!);

//     DocumentSnapshot safetyFieldDocSanpshot = await FirebaseFirestore.instance
//         .collection('SafetyFieldData2')
//         .doc('${widget.depoName}')
//         .collection('userId')
//         .doc(widget.userId)
//         .collection('date')
//         .doc(selectedDate)
//         .get();

//     Map<String, dynamic> safetyMapData =
//         safetyFieldDocSanpshot.data() as Map<String, dynamic>;

//     List<List<dynamic>> fieldData = [
//       ['Installation Date', safetyMapData['InstallationDate']],
//       ['Enegization Date', safetyMapData['EnegizationDate']],
//       ['On Boarding Date', safetyMapData['BoardingDate']],
//       ['TPNo : ', '${safetyMapData['TPNo']}'],
//       ['Rev :', '${safetyMapData['Rev']}'],
//       ['Bus Depot Location :', '${safetyMapData['DepotLocation']}'],
//       ['Address :', '${safetyMapData['Address']}'],
//       ['Contact no / Mail Id :', '${safetyMapData['ContactNo']}'],
//       ['Latitude & Longitude :', '${safetyMapData['Latitude']}'],
//       ['State :', '${safetyMapData['State']}'],
//       ['Charger Type : ', '${safetyMapData['ChargerType']}'],
//       ['Conducted By :', '${safetyMapData['ConductedBy']}']
//     ];

//     List<pw.TableRow> rows = [];

//     rows.add(
//       pw.TableRow(
//         children: [
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Sr No',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.only(
//                   top: 4, bottom: 4, left: 2, right: 2),
//               child: pw.Center(
//                   child: pw.Text('Details',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Status',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Remark',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Image5',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Image6',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Image7',
//               ))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Image8',
//               ))),
//         ],
//       ),
//     );

//     List<pw.Widget> imageUrls = [];

//     for (SafetyChecklistModel mapData in safetylisttable) {
//       print('Date - ${DateFormat.yMMMMd().format(startdate!)}');

//       String images_Path =
//           'SafetyChecklist/${widget.cityName}/${widget.depoName}/${widget.userId}/${DateFormat.yMMMMd().format(startdate!)}/${mapData.srNo}';

//       ListResult result =
//           await FirebaseStorage.instance.ref().child(images_Path).listAll();

//       if (result.items.isNotEmpty) {
//         for (var image in result.items) {
//           String downloadUrl = await image.getDownloadURL();
//           if (image.name.endsWith('.pdf')) {
//             imageUrls.add(
//               pw.Container(
//                 alignment: pw.Alignment.center,
//                 padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                 width: 60,
//                 height: 100,
//                 child: pw.UrlLink(
//                     child: pw.Text(
//                       image.name,
//                       style: const pw.TextStyle(
//                         color: PdfColors.blue,
//                       ),
//                     ),
//                     destination: downloadUrl),
//               ),
//             );
//           } else {
//             final myImage = await networkImage(
//               downloadUrl,
//             );
//             imageUrls.add(
//               pw.Container(
//                   padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   width: 60,
//                   height: 100,
//                   child: pw.Center(
//                     child: pw.Image(myImage),
//                   )),
//             );
//           }
//         }

//         if (imageUrls.length > 4) {
//           int imageLoop = 12 - imageUrls.length;
//           for (int i = 0; i < imageLoop; i++) {
//             imageUrls.add(
//               pw.Container(
//                   padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   width: 60,
//                   height: 100,
//                   child: pw.Text('')),
//             );
//           }
//         } else if (imageUrls.length < 4) {
//           int imageLoop = 4 - imageUrls.length;
//           for (int i = 0; i < imageLoop; i++) {
//             imageUrls.add(
//               pw.Container(
//                   padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   width: 60,
//                   height: 100,
//                   child: pw.Text('')),
//             );
//           }
//         }
//       } else {
//         isImageEmpty = true;
//       }

//       result.items.clear();

//       //Text Rows of PDF Table
//       rows.add(
//         pw.TableRow(children: [
//           pw.Container(
//               padding: const pw.EdgeInsets.all(3.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.srNo.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(5.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.details.toString(),
//                       style: const pw.TextStyle(
//                         fontSize: 13,
//                       )))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.status,
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.remark.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           isImageEmpty
//               ? pw.Container()
//               : pw.Center(
//                   child: imageUrls[0],
//                 ),
//           isImageEmpty
//               ? pw.Container()
//               : pw.Center(
//                   child: imageUrls[1],
//                 ),
//           isImageEmpty
//               ? pw.Container()
//               : pw.Center(
//                   child: imageUrls[2],
//                 ),
//           isImageEmpty
//               ? pw.Container()
//               : pw.Center(
//                   child: imageUrls[3],
//                 ),
//         ]),
//       );

//       if (imageUrls.length > 4) {
//         //Image Rows of PDF Table
//         rows.add(
//           pw.TableRow(
//             children: [
//               pw.Container(
//                 padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                 child: pw.Text(
//                   '',
//                 ),
//               ),
//               pw.Container(
//                   padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   width: 60,
//                   height: 100,
//                   child: pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//                       children: [
//                         imageUrls[4],
//                         imageUrls[5],
//                       ])),
//               imageUrls[6],
//               imageUrls[7],
//               imageUrls[8],
//               imageUrls[9],
//               imageUrls[10],
//               imageUrls[11],
//             ],
//           ),
//         );
//       }
//       imageUrls.clear();
//     }

//     final pdf = pw.Document(
//       pageMode: PdfPageMode.outlines,
//     );

//     pdf.addPage(
//       pw.MultiPage(
//         theme: pw.ThemeData.withFont(
//             base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
//         pageFormat: const PdfPageFormat(1300, 900,
//             marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
//         orientation: pw.PageOrientation.landscape,
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         // mainAxisAlignment: pw.MainAxisAlignment.start,
//         header: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               decoration: const pw.BoxDecoration(
//                   border: pw.Border(
//                       bottom:
//                           pw.BorderSide(width: 0.5, color: PdfColors.grey))),
//               child: pw.Column(children: [
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('Safety Report',
//                           textScaleFactor: 2,
//                           style: const pw.TextStyle(color: PdfColors.blue700)),
//                       pw.Container(
//                         width: 120,
//                         height: 120,
//                         child: pw.Image(profileImage),
//                       ),
//                     ]),
//               ]));
//         },
//         footer: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//               child: pw.Text('UserID - ${widget.userId}',
//                   textScaleFactor: 1.5,
//                   // 'Page ${context.pageNumber} of ${context.pagesCount}',
//                   style: pw.Theme.of(context)
//                       .defaultTextStyle
//                       .copyWith(color: PdfColors.black)));
//         },
//         build: (pw.Context context) => <pw.Widget>[
//           pw.Column(children: [
//             pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Place : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text: '${widget.cityName} / ${widget.depoName}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Date : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text: date,
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'UserID : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text: widget.userId,
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                 ]),
//             pw.SizedBox(height: 20)
//           ]),
//           pw.SizedBox(height: 10),
//           pw.Table.fromTextArray(
//             columnWidths: {
//               0: const pw.FixedColumnWidth(100),
//               1: const pw.FixedColumnWidth(100),
//             },
//             headers: ['Details', 'Values'],
//             headerStyle: headerStyle,
//             headerPadding: const pw.EdgeInsets.all(10.0),
//             data: fieldData,
//             cellHeight: 35,
//             cellStyle: cellStyle,
//           )
//         ],
//       ),
//     );

//     //First Half Page

//     pdf.addPage(
//       pw.MultiPage(
//         theme: pw.ThemeData.withFont(
//             base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
//         pageFormat: const PdfPageFormat(1300, 900,
//             marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
//         orientation: pw.PageOrientation.natural,
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         header: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               decoration: const pw.BoxDecoration(
//                   border: pw.Border(
//                       bottom:
//                           pw.BorderSide(width: 0.5, color: PdfColors.grey))),
//               child: pw.Column(children: [
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('Safety Report',
//                           textScaleFactor: 2,
//                           style: const pw.TextStyle(color: PdfColors.blue700)),
//                       pw.Container(
//                         width: 120,
//                         height: 120,
//                         child: pw.Image(profileImage),
//                       ),
//                     ]),
//               ]));
//         },
//         footer: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//               child: pw.Text('User ID - ${widget.userId}',
//                   // 'Page ${context.pageNumber} of ${context.pagesCount}',
//                   style: pw.Theme.of(context)
//                       .defaultTextStyle
//                       .copyWith(color: PdfColors.black)));
//         },
//         build: (pw.Context context) => <pw.Widget>[
//           pw.Column(children: [
//             pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Place : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text: '${widget.cityName} / ${widget.depoName}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Date : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text:
//                             '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     pw.TextSpan(
//                         text: 'UserID : ${widget.userId}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15)),
//                   ])),
//                 ]),
//             pw.SizedBox(height: 20)
//           ]),
//           pw.SizedBox(height: 10),
//           pw.Table(
//               columnWidths: {
//                 0: const pw.FixedColumnWidth(30),
//                 1: const pw.FixedColumnWidth(160),
//                 2: const pw.FixedColumnWidth(70),
//                 3: const pw.FixedColumnWidth(70),
//                 4: const pw.FixedColumnWidth(70),
//                 5: const pw.FixedColumnWidth(70),
//                 6: const pw.FixedColumnWidth(70),
//                 7: const pw.FixedColumnWidth(70),
//               },
//               defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
//               tableWidth: pw.TableWidth.max,
//               border: pw.TableBorder.all(),
//               children: rows)
//         ],
//       ),
//     );

//     pdfData = await pdf.save();
//     pdfPath = 'SafetyReport.pdf';
//     pr!.hide();

//     return pdfData!;
//   }

//   Future<Uint8List> _generateDailyPDF() async {
//     print('generating daily pdf');
//     pr!.style(
//       progressWidgetAlignment: Alignment.center,
//       // message: 'Loading Data....',
//       borderRadius: 10.0,
//       backgroundColor: Colors.white,
//       progressWidget: const LoadingPdf(),
//       elevation: 10.0,
//       insetAnimCurve: Curves.easeInOut,
//       maxProgress: 100.0,
//       progressTextStyle: const TextStyle(
//           color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
//       messageTextStyle: const TextStyle(
//           color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
//     );

//     final summaryProvider =
//         Provider.of<SummaryProvider>(context, listen: false);
//     dailyproject = summaryProvider.dailydata;

//     final headerStyle =
//         pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

//     final fontData1 =
//         await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
//     final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

//     final profileImage = pw.MemoryImage(
//       (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
//     );

//     List<pw.TableRow> rows = [];

//     rows.add(pw.TableRow(children: [
//       pw.Container(
//         padding: const pw.EdgeInsets.all(2.0),
//         child: pw.Center(
//           child: pw.Text(
//             'Sr No',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       pw.Container(
//         padding: const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
//         child: pw.Center(
//           child: pw.Text(
//             'Date',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       pw.Container(
//         padding: const pw.EdgeInsets.all(2.0),
//         child: pw.Center(
//           child: pw.Text(
//             'Type of Activity',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       pw.Container(
//         padding: const pw.EdgeInsets.all(2.0),
//         child: pw.Center(
//           child: pw.Text(
//             'Activity Details',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       pw.Container(
//         padding: const pw.EdgeInsets.all(2.0),
//         child: pw.Center(
//           child: pw.Text(
//             'Progress',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       pw.Container(
//         padding: const pw.EdgeInsets.all(2.0),
//         child: pw.Center(
//           child: pw.Text(
//             'Remark / Status',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       pw.Container(
//           padding: const pw.EdgeInsets.all(2.0),
//           child: pw.Center(
//             child: pw.Text(
//               'Image1',
//               style: pw.TextStyle(
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           )),
//       pw.Container(
//         padding: const pw.EdgeInsets.all(2.0),
//         child: pw.Center(
//           child: pw.Text(
//             'Image2',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     ]));

//     List<pw.Widget> imageUrls = [];

//     for (int i = 0; i < dailyproject.length; i++) {
//       String imagesPath =
//           '/Daily Report/${widget.cityName}/${widget.depoName}/${widget.userId}/${dailyproject[i].date}/${globalRowIndex[i]}';
//       print(imagesPath);

//       ListResult result =
//           await FirebaseStorage.instance.ref().child(imagesPath).listAll();

//       if (result.items.isNotEmpty) {
//         for (var image in result.items) {
//           String downloadUrl = await image.getDownloadURL();
//           if (image.name.endsWith('.pdf')) {
//             imageUrls.add(
//               pw.Container(
//                 width: 60,
//                 alignment: pw.Alignment.center,
//                 padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                 child: pw.UrlLink(
//                   child: pw.Text(
//                     image.name,
//                     style: const pw.TextStyle(
//                       color: PdfColors.blue,
//                     ),
//                   ),
//                   destination: downloadUrl,
//                 ),
//               ),
//             );
//           } else {
//             final myImage = await networkImage(
//               downloadUrl,
//             );
//             imageUrls.add(
//               pw.Container(
//                 padding: const pw.EdgeInsets.only(
//                   top: 8.0,
//                   bottom: 8.0,
//                 ),
//                 width: 60,
//                 height: 80,
//                 child: pw.Center(
//                   child: pw.Image(
//                     myImage,
//                   ),
//                 ),
//               ),
//             );
//           }
//         }

//         if (imageUrls.length < 2) {
//           int imageLoop = 2 - imageUrls.length;
//           for (int i = 0; i < imageLoop; i++) {
//             imageUrls.add(
//               pw.Container(
//                   padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   width: 60,
//                   height: 80,
//                   child: pw.Text('')),
//             );
//           }
//         } else if (imageUrls.length > 2) {
//           int imageLoop = 10 - imageUrls.length;
//           for (int i = 0; i < imageLoop; i++) {
//             imageUrls.add(
//               pw.Container(
//                   padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   width: 80,
//                   height: 100,
//                   child: pw.Text('')),
//             );
//           }
//         }
//       } else {
//         for (int i = 0; i < 2; i++) {
//           imageUrls.add(
//             pw.Container(
//               padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//               width: 60,
//               height: 80,
//               child: pw.Text(
//                 '',
//               ),
//             ),
//           );
//         }
//       }
//       result.items.clear();

//       //Text Rows of PDF Table
//       rows.add(pw.TableRow(children: [
//         pw.Container(
//             padding: const pw.EdgeInsets.all(3.0),
//             child: pw.Center(
//                 child: pw.Text((i + 1).toString(),
//                     style: const pw.TextStyle(fontSize: 14)))),
//         pw.Container(
//             padding: const pw.EdgeInsets.all(2.0),
//             child: pw.Center(
//                 child: pw.Text(dailyproject[i].date.toString(),
//                     style: const pw.TextStyle(fontSize: 14)))),
//         pw.Container(
//             padding: const pw.EdgeInsets.all(2.0),
//             child: pw.Center(
//                 child: pw.Text(dailyproject[i].typeOfActivity.toString(),
//                     style: const pw.TextStyle(fontSize: 14)))),
//         pw.Container(
//             padding: const pw.EdgeInsets.all(2.0),
//             child: pw.Center(
//                 child: pw.Text(dailyproject[i].activityDetails.toString(),
//                     style: const pw.TextStyle(fontSize: 14)))),
//         pw.Container(
//             padding: const pw.EdgeInsets.all(2.0),
//             child: pw.Center(
//                 child: pw.Text(dailyproject[i].progress.toString(),
//                     style: const pw.TextStyle(fontSize: 14)))),
//         pw.Container(
//             padding: const pw.EdgeInsets.all(2.0),
//             child: pw.Center(
//                 child: pw.Text(dailyproject[i].status.toString(),
//                     style: const pw.TextStyle(fontSize: 14)))),
//         imageUrls[0],
//         imageUrls[1]
//       ]));

//       if (imageUrls.length - 2 > 0) {
//         //Image Rows of PDF Table
//         rows.add(pw.TableRow(children: [
//           pw.Container(
//               padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//               child: pw.Text('')),
//           pw.Container(
//               padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
//               width: 60,
//               height: 100,
//               child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//                   children: [
//                     imageUrls[2],
//                     imageUrls[3],
//                   ])),
//           imageUrls[4],
//           imageUrls[5],
//           imageUrls[6],
//           imageUrls[7],
//           imageUrls[8],
//           imageUrls[9]
//         ]));
//       }
//       imageUrls.clear();
//     }

//     final pdf = pw.Document(
//       pageMode: PdfPageMode.outlines,
//     );

//     //First Half Page

//     pdf.addPage(
//       pw.MultiPage(
//         maxPages: 100,
//         theme: pw.ThemeData.withFont(
//             base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
//         pageFormat: const PdfPageFormat(1300, 900,
//             marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
//         orientation: pw.PageOrientation.natural,
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         header: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               decoration: const pw.BoxDecoration(
//                   border: pw.Border(
//                       bottom:
//                           pw.BorderSide(width: 0.5, color: PdfColors.grey))),
//               child: pw.Column(children: [
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('Daily Report Table',
//                           textScaleFactor: 2,
//                           style: const pw.TextStyle(color: PdfColors.blue700)),
//                       pw.Container(
//                         width: 120,
//                         height: 120,
//                         child: pw.Image(profileImage),
//                       ),
//                     ]),
//               ]));
//         },
//         footer: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//               child: pw.Text('User ID - ${widget.userId}',
//                   // 'Page ${context.pageNumber} of ${context.pagesCount}',
//                   style: pw.Theme.of(context)
//                       .defaultTextStyle
//                       .copyWith(color: PdfColors.black)));
//         },
//         build: (pw.Context context) => <pw.Widget>[
//           pw.Column(children: [
//             pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Place : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text: '${widget.cityName} / ${widget.depoName}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Date : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text:
//                             '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     pw.TextSpan(
//                         text: 'UserID : ${widget.userId}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15)),
//                   ])),
//                 ]),
//             pw.SizedBox(height: 20)
//           ]),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             columnWidths: {
//               0: const pw.FixedColumnWidth(30),
//               1: const pw.FixedColumnWidth(160),
//               2: const pw.FixedColumnWidth(70),
//               3: const pw.FixedColumnWidth(70),
//               4: const pw.FixedColumnWidth(70),
//               5: const pw.FixedColumnWidth(70),
//               6: const pw.FixedColumnWidth(70),
//               7: const pw.FixedColumnWidth(70),
//             },
//             defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
//             tableWidth: pw.TableWidth.max,
//             border: pw.TableBorder.all(),
//             children: rows,
//           )
//         ],
//       ),
//     );

//     pdfData = await pdf.save();
//     pdfPath = 'Daily Report.pdf';

//     return pdfData!;
//   }

//   Future<Uint8List> _generateMonthlyPdf() async {
//     final headerStyle =
//         pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

//     final fontData1 =
//         await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
//     final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

//     const cellStyle = pw.TextStyle(
//       color: PdfColors.black,
//       fontSize: 14,
//     );

//     final profileImage = pw.MemoryImage(
//       (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
//     );

//     List<pw.TableRow> rows = [];

//     rows.add(
//       pw.TableRow(
//         children: [
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Sr No',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.only(
//                   top: 4, bottom: 4, left: 2, right: 2),
//               child: pw.Center(
//                   child: pw.Text('Activity Details',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Progress',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text('Remark/Status',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(
//                 'Next Month Action Plan',
//               ))),
//         ],
//       ),
//     );

//     if (monthlyProject.isNotEmpty) {
//       for (MonthlyProjectModel mapData in monthlyProject) {
//         // String selectedDate = DateFormat.yMMMMd().format(startdate!);

//         //Text Rows of PDF Table

//         rows.add(pw.TableRow(children: [
//           pw.Container(
//               padding: const pw.EdgeInsets.all(3.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.activityNo.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(5.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.activityDetails.toString(),
//                       style: const pw.TextStyle(
//                         fontSize: 13,
//                       )))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.progress.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.status.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//           pw.Container(
//               padding: const pw.EdgeInsets.all(2.0),
//               child: pw.Center(
//                   child: pw.Text(mapData.action.toString(),
//                       style: const pw.TextStyle(fontSize: 13)))),
//         ]));
//       }
//     }

//     final pdf = pw.Document(
//       pageMode: PdfPageMode.outlines,
//     );

//     //First Half Page

//     pdf.addPage(
//       pw.MultiPage(
//         theme: pw.ThemeData.withFont(
//             base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
//         pageFormat: const PdfPageFormat(1300, 900,
//             marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
//         orientation: pw.PageOrientation.natural,
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         header: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//               decoration: const pw.BoxDecoration(
//                   border: pw.Border(
//                       bottom:
//                           pw.BorderSide(width: 0.5, color: PdfColors.grey))),
//               child: pw.Column(children: [
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('Monthly Report',
//                           textScaleFactor: 2,
//                           style: const pw.TextStyle(color: PdfColors.blue700)),
//                       pw.Container(
//                         width: 120,
//                         height: 120,
//                         child: pw.Image(profileImage),
//                       ),
//                     ]),
//               ]));
//         },
//         footer: (pw.Context context) {
//           return pw.Container(
//               alignment: pw.Alignment.centerRight,
//               margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//               child: pw.Text('User ID - ${widget.userId}',
//                   // 'Page ${context.pageNumber} of ${context.pagesCount}',
//                   style: pw.Theme.of(context)
//                       .defaultTextStyle
//                       .copyWith(color: PdfColors.black)));
//         },
//         build: (pw.Context context) => <pw.Widget>[
//           pw.Column(children: [
//             pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Place : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text: '${widget.cityName} / ${widget.depoName}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     const pw.TextSpan(
//                         text: 'Date : ',
//                         style:
//                             pw.TextStyle(color: PdfColors.black, fontSize: 17)),
//                     pw.TextSpan(
//                         text:
//                             '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15))
//                   ])),
//                   pw.RichText(
//                       text: pw.TextSpan(children: [
//                     pw.TextSpan(
//                         text: 'UserID : ${widget.userId}',
//                         style: const pw.TextStyle(
//                             color: PdfColors.blue700, fontSize: 15)),
//                   ])),
//                 ]),
//             pw.SizedBox(height: 20)
//           ]),
//           pw.SizedBox(height: 10),
//           pw.Table(
//               columnWidths: {
//                 0: const pw.FixedColumnWidth(30),
//                 1: const pw.FixedColumnWidth(160),
//                 2: const pw.FixedColumnWidth(70),
//                 3: const pw.FixedColumnWidth(70),
//                 4: const pw.FixedColumnWidth(70),
//                 5: const pw.FixedColumnWidth(70),
//                 6: const pw.FixedColumnWidth(70),
//                 7: const pw.FixedColumnWidth(70),
//               },
//               defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
//               tableWidth: pw.TableWidth.max,
//               border: pw.TableBorder.all(),
//               children: rows)
//         ],
//       ),
//     );

//     pdfData = await pdf.save();
//     pdfPath = 'MonthlyReport.pdf';

//     // Save the PDF file to device storage
//     if (kIsWeb) {
//     } else {
//       const Text('Sorry it is not ready for mobile platform');
//     }

//     return pdfData!;
//   }

//   Future<void> downloadPDF() async {
//     if (await Permission.manageExternalStorage.request().isGranted) {
//       final pr = ProgressDialog(context);

//       pr.style(
//         progressWidgetAlignment: Alignment.center,
//         message: 'Downloading file...',
//         borderRadius: 10.0,
//         backgroundColor: Colors.white,
//         progressWidget: const LoadingPdf(),
//         elevation: 10.0,
//         insetAnimCurve: Curves.easeInOut,
//         maxProgress: 100.0,
//         progressTextStyle: const TextStyle(
//             color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
//         messageTextStyle: const TextStyle(
//             color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
//       );

//       await pr.show();

//       final pdfData = widget.id == 'Daily Report'
//           ? await _generateDailyPDF()
//           : widget.id == 'Monthly Report'
//               ? await _generateMonthlyPdf()
//               : widget.id == 'Safety Checklist Report'
//                   ? await _generateSafetyPDF()
//                   : await _generateEnergyPDF();

//       String fileName = widget.id == 'Daily Report'
//           ? 'DailyReport.pdf'
//           : widget.id == 'Monthly Report'
//               ? 'MonthlyReport.pdf'
//               : widget.id == 'Safety Checklist Report'
//                   ? 'SafetyChecklist.pdf'
//                   : widget.id == 'Energy Management'
//                       ? 'EnergyManagement.pdf'
//                       : '';

//       final savedPDFFile = await savePDFToFile(pdfData, fileName);

//       await pr.hide();

//       const AndroidNotificationDetails androidNotificationDetails =
//           AndroidNotificationDetails(
//               'repeating channel id', 'repeating channel name',
//               channelDescription: 'repeating description');
//       const NotificationDetails notificationDetails =
//           NotificationDetails(android: androidNotificationDetails);
//       await FlutterLocalNotificationsPlugin().show(
//           0, '${widget.id} Downloaded', 'Tap to open', notificationDetails,
//           payload: pathToOpenFile);
//     }
//   }

//   Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
//     final documentDirectory = (await DownloadsPath.downloadsDirectory())?.path;
//     File file = File('$documentDirectory/$fileName');

//     int counter = 1;
//     String newFilePath = file.path;
//     pathToOpenFile = newFilePath;

//     while (await file.exists()) {
//       String newName =
//           '${fileName.substring(0, fileName.lastIndexOf('.'))}-$counter${fileName.substring(fileName.lastIndexOf('.'))}';
//       file = File('$documentDirectory/$newName');
//       pathToOpenFile = file.path;
//       counter++;
//     }
//     await file.writeAsBytes(pdfData);
//     return file;
//   }

//   _showCheckboxDialog(BuildContext context, CheckboxProvider checkboxProvider,
//       String depoName) {
//     checkboxProvider.myCcBooleanValue.clear();
//     checkboxProvider.myToBooleanValue.clear();
//     checkboxProvider.myCcBooleanValue.add(false);
//     checkboxProvider.myToBooleanValue.add(false);
//     checkboxProvider.ccValue.clear();
//     checkboxProvider.toValue.clear();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Consumer<CheckboxProvider>(
//           builder: (context, value, child) {
//             return Container(
//               padding: const EdgeInsetsDirectional.all(0),
//               margin: const EdgeInsets.all(10),
//               width: MediaQuery.of(context).size.width,
//               child: AlertDialog(
//                 title: Text('Choose Required Filled For Email',
//                     style: appTextStyle),
//                 content: Column(mainAxisSize: MainAxisSize.max, children: [
//                   Expanded(
//                     child: Column(children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         child: Text(
//                           'Choose To',
//                           style: appTextStyle,
//                           textAlign: TextAlign.start,
//                         ),
//                       ),
//                       ...List.generate(
//                         value.myToMailValue.length,
//                         (index) {
//                           // print('iji$index');

//                           for (int i = 0;
//                               i <= value.myToMailValue.length;
//                               i++) {
//                             checkboxProvider.defaultToBooleanValue.add(false);
//                           }

//                           return Flexible(
//                             child: Row(
//                               children: [
//                                 Checkbox(
//                                   // title: Text(value.myCcMailValue[index]),
//                                   value: value.myToBooleanValue[index],
//                                   onChanged: (bool? newboolean) {
//                                     if (newboolean != null) {
//                                       checkboxProvider.setMyToBooleanValue(
//                                           index, newboolean);
//                                     }

//                                     if (value.myToBooleanValue[index] != null &&
//                                         value.myToBooleanValue[index] == true) {
//                                       print('index$index');
//                                       checkboxProvider.getCurrentToValue(
//                                           index, value.myToMailValue[index]);
//                                     } else {
//                                       value.toValue
//                                           .remove(value.myToMailValue[index]);
//                                     }
//                                     print(value.ccValue);
//                                   },
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     value.myToMailValue[index],
//                                     style: appTextStyle,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ]),
//                   ),
//                   widget.role == 'projectManager'
//                       ? Expanded(
//                           child: Column(children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width,
//                               child: Text(
//                                 'Choose Cc',
//                                 style: appTextStyle,
//                                 textAlign: TextAlign.start,
//                               ),
//                             ),
//                             ...List.generate(
//                               value.myCcMailValue.length,
//                               (index) {
//                                 // print('iji$index');
//                                 for (int i = 0;
//                                     i <= value.myCcMailValue.length;
//                                     i++) {
//                                   checkboxProvider.defaultCcBooleanValue
//                                       .add(false);
//                                 }
//                                 return Flexible(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Checkbox(
//                                         value: value.myCcBooleanValue[index],
//                                         onChanged: (bool? newboolean) {
//                                           if (newboolean != null) {
//                                             checkboxProvider
//                                                 .setMyCcBooleanValue(
//                                                     index, newboolean);
//                                           }
//                                           if (value.myCcBooleanValue[index] !=
//                                                   null &&
//                                               value.myCcBooleanValue[index] ==
//                                                   true) {
//                                             print('index$index');
//                                             checkboxProvider.getCurrentCcValue(
//                                                 index,
//                                                 value.myCcMailValue[index]);
//                                           } else {
//                                             value.ccValue.remove(
//                                                 value.myCcMailValue[index]);
//                                           }
//                                         },
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           value.myCcMailValue[index],
//                                           style: appTextStyle,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ]),
//                         )
//                       : Container()
//                 ]),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('Close'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Do something with the checked items
//                       print(checkboxProvider.ccValue);
//                       widget.id == 'Daily Report'
//                           ? _generateDailyPDF().whenComplete(() {
//                               savePdfAndSendEmail(
//                                   pdfData!,
//                                   pdfPath!,
//                                   'Daily Project Details of $depoName',
//                                   'Todays+Daily+Report',
//                                   checkboxProvider.toValue,
//                                   checkboxProvider.ccValue);
//                               Navigator.pop(context);
//                             })
//                           : widget.id == 'Monthly Report'
//                               ? _generateMonthlyPdf().whenComplete(() {
//                                   savePdfAndSendEmail(
//                                       pdfData!,
//                                       pdfPath!,
//                                       'Daily Project Details of $depoName',
//                                       'Todays+Daily+Report',
//                                       checkboxProvider.toValue,
//                                       checkboxProvider.ccValue);
//                                 })
//                               : _generateEnergyPDF().whenComplete(() {
//                                   savePdfAndSendEmail(
//                                       pdfData!,
//                                       pdfPath!,
//                                       'Daily Project Details of $depoName',
//                                       'Todays+Daily+Report',
//                                       checkboxProvider.toValue,
//                                       checkboxProvider.ccValue);
//                                 });

//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('Send'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<String> uploadPdf(List<int> pdfData, String pdfPath) async {
//     // Upload the PDF data to Firebase Storage
//     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//         .ref('Downloaded File')
//         .child(widget.userId)
//         .child(widget.depoName!)
//         // .child(path)
//         .child(pdfPath);
//     await ref.putData(Uint8List.fromList(pdfData));

//     // Get the download URL for the uploaded PDF file
//     return await ref.getDownloadURL();
//   }

//   Future<void> savePdfAndSendEmail(
//       List<int> pdfData,
//       String pdfPath,
//       String subject,
//       String body,
//       List<String> toRecipients,
//       List<String> ccRecipients) async {
//     showCupertinoDialog(
//       context: context,
//       builder: (context) => const CupertinoAlertDialog(
//         content: SizedBox(
//           height: 50,
//           width: 50,
//           child: Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//     // Upload the PDF data to Firebase Storage
//     String pdfUrl = await uploadPdf(pdfData, pdfPath);

//     // Send email with the PDF URL as an attachment

//     sendEmail('subject', body, pdfUrl, toRecipients, ccRecipients);
//     Navigator.pop(context);
//   }

//   sendEmail(String subject, String body, String attachmentUrl,
//       List<String> toRecipients, List<String> ccRecipients) async {
//     // Construct the mailto URL
//     // String filePath = path.url.basename(attachmentUrl);
//     String encodedSubject = Uri.decodeComponent(subject);
//     String encodedBody = Uri.decodeComponent(body);
//     // String encodedAttachmentUrl = attachmentUrl;
//     String toParameter = toRecipients.map((cc) => cc).join(',');
//     String ccParameter = ccRecipients.map((cc) => cc).join(',');

//     funcOpenMailComposer(toRecipients, ccRecipients, encodedSubject,
//         'Attachment: $attachmentUrl');
//     // final Uri emailUri = Uri(
//     //   scheme: 'mailto',
//     //   path: '', // email address goes here
//     //   queryParameters: {
//     //     'subject': encodedSubject,
//     //     'body': 'Attachment: $attachmentUrl',
//     //     // 'attachment': attachmentUrl,
//     //     //encodedAttachmentUrl, // attachment url if needed
//     //     'to': toParameter,
//     //     'cc': ccParameter,
//     //   },
//     // );
//     // print('gfgfh&$ccParameter');
//     // print('Email$emailUri');
//     // if (await canLaunchUrl(emailUri)) {
//     //   await launchUrl(emailUri);
//     // } else {
//     //   // Handle the case where the email client cannot be launched
//     //   throw 'Could not launch email';
//     // }

//     // Encode and launch the mailto URL
//     // html.window.open(params.toString(), 'email');
//   }

//   void funcOpenMailComposer(List<String> toReceppients,
//       List<String> ccRecipients, String subject, String body) async {
//     final mailtoLink = Mailto(
//       to: toReceppients,
//       cc: ccRecipients,
//       subject: '',
//       body: body,
//     );
//     await launchUrl(Uri.parse(mailtoLink.toString()));                                  
//   }
// }

// List<BarChartGroupData> barChartGroupData(List<dynamic> data) {
//   return List.generate(
//     data.length,
//     ((index) {
//       return BarChartGroupData(
//         x: index,
//         showingTooltipIndicators: [0],
//         barRods: [
//           BarChartRodData(
//               borderSide: BorderSide(color: white),
//               backDrawRodData: BackgroundBarChartRodData(
//                 toY: 0,
//                 fromY: 0,
//                 show: true,
//               ),
//               gradient: const LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 16, 81, 231),
//                   Color.fromARGB(255, 190, 207, 252)
//                 ],
//               ),
//               width: 8,
//               borderRadius: BorderRadius.circular(2),
//               toY: double.parse(data[index].toString())),
//         ],
//       );
//     }),
//   );
// }

// Widget createColumnLabel(String labelText) {
//   return Container(
//     alignment: Alignment.center,
//     child: Text(labelText,
//         overflow: TextOverflow.values.first,
//         textAlign: TextAlign.center,
//         style: tableheader),
//   );
// }
