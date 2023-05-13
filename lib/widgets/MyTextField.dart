import 'package:flutter/material.dart';

import '../materials/colors.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText; //hide the input to *****(for password)

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(color: theme_dark_grey),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme_dark_grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme_dark_purple),
          ),
          fillColor: theme_light_gray,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
