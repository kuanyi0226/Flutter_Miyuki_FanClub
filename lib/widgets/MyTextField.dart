import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../materials/colors.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText; //hide the input to *****(for password)
  final int? maxLength;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false,
      this.maxLength = null});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(color: kIsWeb ? Colors.white : theme_dark_grey),
        controller: controller,
        obscureText: obscureText,
        maxLength: maxLength,
        decoration: kIsWeb
            ? InputDecoration(counterText: "", hintText: hintText)
            : InputDecoration(
                counterText: "",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme_dark_grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme_dark_purple),
                ),
                fillColor: theme_light_gray,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white),
                focusColor: theme_dark_purple,
              ),
        cursorColor: kIsWeb ? Theme.of(context).colorScheme.primary : theme_dark_purple,
      ),
    );
  }
}
