import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

// ignore: must_be_immutable
class ResetPassword extends StatefulWidget {
  String society;
  List<dynamic> allRoles = [];
  String userId;

  ResetPassword(
      {super.key,
      required this.society,
      required this.allRoles,
      required this.userId});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText1 = true;

  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 300,
          width: 500,
          child: Card(
            elevation: 5.0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0),
                  child: const Text(
                    'Reset password',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  width: 450,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _newPassword,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'New Password',
                              // prefixIcon: Icon(Icons.lock_reset),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _newPassword.text = _newPassword.text;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _confirmPassword,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Confirm Password',
                            // prefixIcon: const Icon(Icons.lock_reset),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText1
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                            ),

                            //  Icon(_obscureText
                            //     ? Icons.visibility
                            //     : Icons.visibility_off),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (_confirmPassword.text != _newPassword.text) {
                              return 'The passwords do not match';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _confirmPassword.text = _confirmPassword.text;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Change Password'),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_newPassword.text == _confirmPassword.text) {
        FirebaseFirestore.instance
            .collection('societyAdmin')
            .doc(widget.userId)
            .update({'password': _newPassword.text});
        // Show a success message

        _newPassword.clear();
        _confirmPassword.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text('Password changed successfully')),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The new password and confirm password do not match'),
          ),
        );
      }
    }
  }
}
