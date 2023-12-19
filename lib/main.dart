import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/loginScreen.dart';
import 'package:society_admin/homeScreen/homeScreen.dart';
import 'package:society_admin/homeScreen/side.dart';
import 'package:society_admin/screens/Notice/addNotice.dart';

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Society Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.blueGrey,
              ),
          primaryTextTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.purple,
              ),
          primaryIconTheme: const IconThemeData(
            color: Color.fromARGB(255, 91, 3, 255),
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
        // home: const customSide()
        home: LoginScreen());
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
        return const HomePage();
      case '/addNotice':
      return  AddNotice();
      case '/addMember':
      // return const AddMember();
      case '/societyList':
      // return const societyList();
      case '/committeeList':
      // return const committeeList();
      case '/addBill':
      // return const AddBill();
    }

    return null;
  }
}
