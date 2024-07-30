import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DarkEffect extends PositionComponent {
  late Paint _darkPaint;
  bool enable = true;

  DarkEffect() {
    _darkPaint = Paint()
      ..color = Color.fromARGB(255, 25, 26, 31)
          .withOpacity(0.6) // Adjust opacity as needed
      ..style = PaintingStyle.fill;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (enable) {
      // Draw a semi-transparent black rectangle over the entire screen
      final rect = Rect.fromLTWH(0, 0, 1000, 1000);
      canvas.drawRect(rect, _darkPaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
