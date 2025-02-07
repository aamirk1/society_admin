import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  Customappbar({super.key, required this.title, this.action});

  final String title;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
