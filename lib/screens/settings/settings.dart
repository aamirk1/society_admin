import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';
import 'package:society_admin/screens/settings/profile/profile.dart';
import 'package:society_admin/screens/settings/reset_password/reset_password.dart';

import '../../authScreen/loginScreen.dart';

class Settings extends StatefulWidget {
  String society;
  List<dynamic> allRoles;
  String userId;
  Settings(
      {super.key,
      required this.allRoles,
      required this.society,
      required this.userId});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> tabs = ['Profile', 'Reset Password'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20.0),
            icon: const Icon(Icons.power_settings_new),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Container(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, childAspectRatio: 3.0),
              itemCount: 2,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => index == 0
                            ? const ProfileScreen()
                            : ResetPassword(
                                society: widget.society,
                                allRoles: widget.allRoles,
                                userId: widget.userId,
                              ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 18, 71, 243),
                            Color.fromARGB(255, 190, 195, 228)
                          ],
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
