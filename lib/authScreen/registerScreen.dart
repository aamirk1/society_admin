// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/loginScreen.dart';

class RegisrationScreen extends StatefulWidget {
  RegisrationScreen({super.key});

  @override
  State<RegisrationScreen> createState() => _RegisrationScreenState();
}

class _RegisrationScreenState extends State<RegisrationScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
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
      backgroundColor: Colors.purple[400],
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Society Manager",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
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
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        labelText: 'First Name',
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
                          return 'Please enter First Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.next,
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        labelText: 'Last Name',
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
                          return 'Please enter Last Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
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
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 0, 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 40)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  register(
                                      firstNameController.text,
                                      lastNameController.text,
                                      mobileController.text,
                                      passwordController.text,
                                      context);
                                }
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
                                },
                                child: const Text(
                                  'Already have an account? Login',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
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

  Future<void> register(String firstName, String lastName, String mobile,
      String password, BuildContext context) async {
    String firstInitial = firstName[0][0].trim().toUpperCase();
    String lastInitial = lastName[0][0].trim().toUpperCase();
    String mobileLastFour = mobile.substring(mobile.length - 4);
    String fullName = '$firstName $lastName';

    String userID = '$firstInitial$lastInitial$mobileLastFour';
    await FirebaseFirestore.instance
        .collection('societyAdmin')
        .doc(userID)
        .set({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'mobile': mobile,
      'password': password,
      'fullName': '$fullName',
      // Add more fields as needed
    });
    FirebaseFirestore.instance.collection('unAssignedRole').doc(fullName).set({
      'alphabet': firstInitial,
      'position': 'unAssigned',
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
