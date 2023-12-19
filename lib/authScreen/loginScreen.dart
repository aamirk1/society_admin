// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:society_admin/homeScreen/side.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userFlatNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Society",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "Manager",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Welcome Back',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.next,
                      controller: mobileController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        labelText: 'Mobile No.',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        // enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Mobile No.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.done,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        // enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromARGB(255, 0, 0, 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login(mobileController.text,
                                  passwordController.text, context);
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void storeLoginData(bool isLogin, String phoneNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('phoneNum');
    prefs.setBool('isLogin', isLogin);
    prefs.setString('phoneNum', phoneNum);
  }

  Future<void> login(
      String mobile, String password, BuildContext context) async {
    try {
      // Fetch the user document from Firestore based on the provided username
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(mobile)
          .get();

      if (userDoc.exists) {
        // Compare the provided password with the stored password
        final storedPassword = userDoc.data()!['password'];

        if (password == storedPassword) {
          storeLoginData(true, mobileController.text);
          // Login successful
          SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text('Login successful')),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // print('Login successful');
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const customSide()),
              (route) => false);

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
