// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextInputType textInputType;

  final bool isPassword;

  final String hintText;

  const MyTextField(
      {super.key,
      required this.textInputType,
      required this.isPassword,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      // for password obscure
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        //to delete borders ( bottom border )
        enabledBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(
          context,
        )),
        // on click border color
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
        )),
        // fill with grey default color
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
