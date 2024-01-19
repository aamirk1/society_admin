// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoadingForMenuUser extends StatelessWidget {
  const LoadingForMenuUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 150),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // children: [
          //   Image.asset('animations/loading_animation.gif'),
          //   const SizedBox(height: 10),
          //   const Text(
          //     'Loading...',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   )
          // ],
        ));
  }
}
