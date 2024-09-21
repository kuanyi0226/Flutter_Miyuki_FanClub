import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  double? imageSize;
  double? squareSize;
  Function()? onTap;
  final String imagePath;

  SquareTile(
      {super.key,
      this.imageSize,
      this.squareSize,
      required this.imagePath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((squareSize == null) ? 20 : squareSize!),
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
