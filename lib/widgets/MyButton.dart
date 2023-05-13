import 'package:flutter/material.dart';

import '../materials/colors.dart';

// For Login Page
class MyButton extends StatelessWidget {
  Function()? onTap;
  String text;

  MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(25.0),
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        decoration: BoxDecoration(
          color: theme_dark_purple,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
