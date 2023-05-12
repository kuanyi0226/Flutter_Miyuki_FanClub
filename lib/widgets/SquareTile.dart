import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  double? imageSize;
  Function()? onTap;
  final String imagePath;

  SquareTile(
      {super.key,
      this.imageSize,
      required this.imagePath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePath,
          height: (imageSize == null) ? 40.0 : imageSize,
        ),
      ),
    );
  }
}
