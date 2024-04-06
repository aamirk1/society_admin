// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names, use_build_context_synchronously, unnecessary_string_interpolations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/authScreen/loginScreen.dart';

class RegisrationScreen extends StatefulWidget {
  const RegisrationScreen({super.key});

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
  TextEditingController emailController = TextEditingController();

  String? userFlatNumber;

  @override
  void initState() {
    super.initState();
  }

  String firstInitial = '';
  String lastInitial = '';
  String mobileLastFour = '';
  String fullName = '';
  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
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
                          style: const TextStyle(color: textColor),
                          textInputAction: TextInputAction.next,
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: primaryColor,
                            )),
                            labelText: 'First Name',
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
                              return 'Please enter First Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: const TextStyle(color: textColor),
                          textInputAction: TextInputAction.next,
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: primaryColor,
                            )),
                            labelText: 'Last Name',
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
                              return 'Please enter Last Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: textColor),
                          textInputAction: TextInputAction.next,
                          controller: mobileController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: primaryColor,
                            )),
                            labelText: 'Mobile No.',
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
                              return 'Please enter Mobile No.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          style: const TextStyle(color: textColor),
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: primaryColor,
                            )),
                            labelText: 'Email Id',
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
                              return 'Please enter your Email Id';
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
                                      register(
                                          firstNameController.text,
                                          lastNameController.text,
                                          mobileController.text,
                                          passwordController.text,
                                          context,
                                          emailController.text);
                                    }
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 14),
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
                                        return const LoginScreen();
                                      }));
                                    },
                                    child: const Text(
                                      'Already have an account? Login',
                                      style: TextStyle(color: white),
                                    ))
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
        ),
      ),
    );
  }

  Future<void> register(String firstName, String lastName, String mobile,
      String password, BuildContext context, String emailId) async {
    firstInitial = firstName[0][0].trim().toUpperCase();
    lastInitial = lastName[0][0].trim().toUpperCase();
    mobileLastFour = mobile.substring(mobile.length - 4);
    fullName = '$firstName $lastName';

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
      'emailId': emailId
      // Add more fields as needed
    });
    FirebaseFirestore.instance.collection('unAssignedRole').doc(fullName).set({
      'alphabet': firstInitial,
      'position': 'unAssigned',
    });
    alertbox(userID, context);
  }

  alertbox(String userID, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: textColor),
                    )),
              ],
              title: Text(
                'Your User ID is: $userID',
                style: const TextStyle(color: textColor),
              ));
        });
  }
}
