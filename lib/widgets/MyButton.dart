import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../materials/colors.dart';

// For Login Page
class MyButton extends StatelessWidget {
  Function()? onTap;
  String text;

  MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onTap,
            child: Text(text),
          ),
        ),
      );
    }
    return TextButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: theme_dark_purple,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
