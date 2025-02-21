import 'package:flutter/material.dart';
import 'package:society_admin/authScreen/common.dart';

class TableHeading extends StatelessWidget {
  const TableHeading({super.key, required this.title, this.width});
  final String title;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * width!,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: const TextStyle(
                    color: white, fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
