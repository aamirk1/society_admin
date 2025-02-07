import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/assigned_user_provider.dart';
import 'package:society_admin/Provider/complaintManagementProvider.dart';
import 'package:society_admin/Provider/deleteNoticeProvider.dart';
import 'package:society_admin/Provider/emplist_builder_provider.dart';
import 'package:society_admin/Provider/filteration_provider.dart';
import 'package:society_admin/Provider/gatePassProvider.dart';
import 'package:society_admin/Provider/image_upload_provider.dart';
import 'package:society_admin/Provider/list_builder_provider.dart';
import 'package:society_admin/Provider/menuUserPageProvider.dart';
import 'package:society_admin/Provider/nocManagementProvider.dart';
import 'package:society_admin/Provider/role_page_total_number_provider.dart';
import 'package:society_admin/Provider/upload_ledger_provider.dart';
import 'package:society_admin/Provider/upload_receipt_provider.dart';
import 'package:society_admin/homeScreen/sideBar.dart';
import 'package:society_admin/screens/Notice/addNotice.dart';
import 'package:society_admin/screens/Notice/circularNotice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBTEp34Y0CbkceRElxrh5Y9DNNnF7HwzoE",
    authDomain: "societymanagement-763f1.firebaseapp.com",
    projectId: "societymanagement-763f1",
    storageBucket: "societymanagement-763f1.appspot.com",
    messagingSenderId: "1077685961456",
    appId: "1:1077685961456:web:93d8e1ccc914d9dc747835",
    measurementId: "G-MMYYVSJE7W",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ListBuilderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EmpListBuilderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeleteNoticeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MenuUserPageProvider(),
        ),
        ChangeNotifierProvider(create: (_) => AssignedUserProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => NocManagementProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintManagementProvider()),
        ChangeNotifierProvider(create: (_) => GatePassProvider()),
        ChangeNotifierProvider(create: (_) => RolePageTotalNumProviderAdmin()),
        ChangeNotifierProvider(create: (_) => UploadLedgerProvider()),
        ChangeNotifierProvider(create: (_) => UploadReceiptProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Society Management',
        theme: ThemeData(
          scrollbarTheme: const ScrollbarThemeData(
            thumbColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.light(error: Colors.white),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.blueGrey,
              ),
          primaryTextTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.purple,
              ),
          primaryIconTheme: const IconThemeData(
            color: Color.fromARGB(255, 3, 20, 255),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          final page = _getPageWidget(settings);
          if (page != null) {
            return PageRouteBuilder(
                settings: settings,
                pageBuilder: (_, __, ___) => page,
                transitionsBuilder: (_, anim, __, child) {
                  return FadeTransition(
                    opacity: anim,
                    child: child,
                  );
                });
          }
          return null;
        },
        // home: customSide(
        //   society: 'Chhatrapati Shivaji Maharaj Vastu Sangrahalaya',
        //   allRoles: const ['Treasurer'],
        //   userId: 'SM2211',
        // ),

        home: customSide(
          society: 'JYOTI CO-OPERATIVE HOUSING SOCIETY LIMITED',
          allRoles: const [''],
          userId: 'JU6263',
        ),
        //  LoginScreen(),
      ),
    );
  }

  Widget? _getPageWidget(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }
    final uri = Uri.parse(settings.name!);
    switch (uri.path) {
      // case '/':
      //   return LoginScreen();
      case '/':
        return CircularNotice(
            society: 'society', allRoles: const [], userId: 'userId');
      case '/addNotice':
        return AddNotice(
          userId: 'userId',
        );
      case '/addNoc':
      // return  AddNoc();
      case '/nocManagement':
      // return  NocManagement();
    }

    return null;
  }
}
