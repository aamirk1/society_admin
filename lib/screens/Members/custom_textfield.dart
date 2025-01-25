import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  bool readonly = false;
  final TextEditingController controller;
  CustomTextField(
      {super.key, required this.readonly, required this.controller});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextField(
        readOnly: widget.readonly,
        controller: widget.controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue, width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        maxLines: 1,
        textInputAction: TextInputAction.done,
        minLines: 1,
        autofocus: false,
        // textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
