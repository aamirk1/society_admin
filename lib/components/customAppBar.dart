// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
 const Customappbar({super.key, this.arrows = false, required this.title, this.action});
  
  final bool arrows; // Non-nullable bool with a default value
  final String title;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: arrows,
        title: Text(
          title,
          style: const TextStyle(color: white),
        ),
        actions: action!,
        backgroundColor: primaryColor,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
