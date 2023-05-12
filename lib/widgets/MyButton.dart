import 'package:flutter/material.dart';

import '../materials/colors.dart';

// For Login Page
class MyButton extends StatelessWidget {
  Function()? onTap;

  MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        padding: const EdgeInsets.all(25.0),
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        decoration: BoxDecoration(
          color: theme_dark_purple,
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
