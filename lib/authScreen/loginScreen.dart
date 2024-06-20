// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/authScreen/registerScreen.dart';
import 'package:society_admin/homeScreen/sideBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userFlatNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  List<dynamic> roles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Card(
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Society Manager",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: textColor),
                        textInputAction: TextInputAction.next,
                        controller: userIdController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: primaryColor,
                          )),
                          labelText: 'UserID',
                          labelStyle: TextStyle(
                            color: textColor,
                          ),
                          // enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: primaryColor,
                          )),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter UserID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: textColor),
                        textInputAction: TextInputAction.next,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: textColor,
                          ),
                          // enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: primaryColor,
                          )),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor:
                                        const Color.fromARGB(255, 0, 0, 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.17,
                                        MediaQuery.of(context).size.height *
                                            0.06)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    login(userIdController.text,
                                        passwordController.text, context);
                                  }
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 14, color: white),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const RegisrationScreen();
                                  }));
                                },
                                child: const Text(
                                  'Don\'t have an account? Sign Up',
                                  style: TextStyle(color: white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void storeLoginData(bool isLogin, String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.setBool('isLogin', isLogin);
    prefs.setString('userID', userID);
  }

  Future<void> login(
      String userID, String password, BuildContext context) async {
    try {
      // Fetch the user document from Firestore based on the provided username
      final userDoc = await FirebaseFirestore.instance
          .collection('societyAdmin')
          .doc(userID)
          .get();

      if (userDoc.exists) {
        // Compare the provided password with the stored password
        final storedPassword = userDoc.data()!['password'];
        final fullName = userDoc.data()!['fullName'];

        if (password == storedPassword) {
          storeLoginData(true, userID);

          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('AssignedRole')
              .where("fullName", isEqualTo: fullName)
              .get();

          List<dynamic> mapData =
              querySnapshot.docs.map((doc) => doc.data()).toList();
          if (mapData.isNotEmpty) {
            final society = mapData[0]['societyname'];

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Center(
                  child: Text(
                    "Login Successful!",
                  ),
                ),
              ),
            );

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => customSide(
                    society: society,
                    allRoles: roles,
                    userId: userID,
                  ),
                ),
                (route) => false);
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Center(
                  child: Text(
                    "Unable to login as no role is assigned!",
                  ),
                ),
              ),
            );
          }

          // Navigate to the home screen or perform any other necessary actions
        } else {
          // Incorrect password
          SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('Incorrect password')),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // print('Incorrect password');
        }
      } else {
        // User does not exist
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Center(child: Text('User does not exist'))),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // print('User does not exist');
      }
    } catch (e) {
      // Error occurred
      // ignore: avoid_print
      print('Error: $e');
    }
  }
}
