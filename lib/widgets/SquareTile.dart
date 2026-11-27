import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
        padding: EdgeInsets.all(
          (squareSize == null) ? (kIsWeb ? 14 : 20) : squareSize!,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: kIsWeb
                ? Theme.of(context).colorScheme.outline
                : Colors.white,
          ),
          borderRadius: BorderRadius.circular(kIsWeb ? 14 : 16),
          color: kIsWeb
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : Colors.grey[200],
        ),
        child: Image.asset(
          imagePath,
          height: (imageSize == null) ? 40.0 : imageSize,
        ),
      ),
    );
  }
}
