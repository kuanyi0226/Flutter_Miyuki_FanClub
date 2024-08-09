import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';
import 'dart:math';

class FollowingSpotlight extends PositionComponent {
  late Paint _shadowPaint;
  late Paint _lightPaint;
  late Vector2 _characterPosition;
  late Vector2 _playerSize;
  late Vector2 _source;
  bool _playerFaceRight = true;
  bool enable = true;

  FollowingSpotlight(
      {required Vector2 playerSize,
      required Vector2 source,
      required Color lightColor}) {
    _shadowPaint = Paint()
      ..color = Color.fromARGB(255, 251, 251, 251).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    _lightPaint = Paint()
      ..color = lightColor
      ..style = PaintingStyle.fill;
    _characterPosition = Vector2.zero();
    this._playerSize = playerSize;
    this._source = source;
  }

  void updateCharacterPosition(Vector2 characterPosition, bool faceRight) {
    _characterPosition = characterPosition;
    _playerFaceRight = faceRight;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (enable) {
      // Draw the cone-shaped spotlight first
      final path = Path();
      path.moveTo(_source.x, _source.y);
      final double ovalHeight = 12.5;
      final double ovalWidth = 100;

      if (_playerFaceRight) {
        // Left side of the cone to the left side of the shadow
        path.lineTo(_characterPosition.x - ovalWidth / 2 + _playerSize.x / 2,
            _characterPosition.y + _playerSize.y);

        // Right side of the cone to the right side of the shadow
        path.lineTo(_characterPosition.x + ovalWidth / 2 + _playerSize.x / 2,
            _characterPosition.y + _playerSize.y);
      } else {
        path.lineTo(_characterPosition.x - ovalWidth / 2 - _playerSize.x / 2,
            _characterPosition.y + _playerSize.y);
        path.lineTo(_characterPosition.x + ovalWidth / 2 - _playerSize.x / 2,
            _characterPosition.y + _playerSize.y);
      }
      path.close();

      canvas.drawPath(path, _lightPaint);

      // Draw the shadow (an ellipse) at the bottom of the character on top of the light
      final shadowRect;
      if (_playerFaceRight) {
        shadowRect = Rect.fromCenter(
          center: Offset(_characterPosition.x + _playerSize.x / 2,
              _characterPosition.y + _playerSize.y),
          width: ovalWidth,
          height: ovalHeight,
        );
      } else {
        shadowRect = Rect.fromCenter(
          center: Offset(_characterPosition.x - _playerSize.x / 2,
              _characterPosition.y + _playerSize.y),
          width: 100,
          height: 12.5,
        );
      }

      canvas.drawOval(shadowRect, _shadowPaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class FixedSpotlight extends PositionComponent {
  late Paint _shadowPaint;
  late Paint _lightPaint;
  late Vector2 _source;
  late Vector2 _target;
  bool enable = true;
  late double _ovalWidth;
  late double _ovalHeight;

  FixedSpotlight({
    required Vector2 source,
    required Vector2 target,
    required Color lightColor,
    double ovalHeight = 12.5,
    double ovalWidth = 100,
  }) {
    _shadowPaint = Paint()
      ..color = Color.fromARGB(255, 251, 251, 251).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    _lightPaint = Paint()
      ..color = lightColor
      ..style = PaintingStyle.fill;
    this._source = source;
    this._target = target;
    this._ovalHeight = ovalHeight;
    this._ovalWidth = ovalWidth;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (enable) {
      // Draw the cone-shaped spotlight first
      final path = Path();
      path.moveTo(_source.x, _source.y);

      path.lineTo(_target.x - _ovalWidth / 2, _target.y);
      path.lineTo(_target.x + _ovalWidth / 2, _target.y);
      path.close();

      canvas.drawPath(path, _lightPaint);

      // Draw the shadow (an ellipse) at the bottom of the character on top of the light
      final shadowRect;
      shadowRect = Rect.fromCenter(
        center: Offset(_target.x, _target.y),
        width: _ovalWidth,
        height: _ovalHeight,
      );

      canvas.drawOval(shadowRect, _shadowPaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}


// import 'package:flutter/material.dart';
// import 'dart:math';

// class SpotLight extends StatefulWidget {
//   @override
//   _SpotLightState createState() => _SpotLightState();
// }

// class _SpotLightState extends State<SpotLight>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 10),
//       vsync: this,
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Transform(
//             alignment: Alignment.topCenter,
//             transform: Matrix4.identity()
//               ..translate(0.0, 50.0)
//               ..rotateY((_controller.value * 2 * pi / 3) - pi / 3)
//               //..rotateZ((_controller.value * 2 * pi / 3) - pi / 3)
//               ..translate(0.0, -100.0),
//             child: child,
//           );
//         },
//         child: CustomPaint(
//           size: Size(400, 600),
//           painter: CornShapePainter(),
//         ),
//       ),
//     );
//   }
// }

// class CornShapePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..shader = RadialGradient(
//         center: Alignment(0.0, -0.4),
//         radius: 1.0,
//         colors: [
//           Color.fromARGB(245, 35, 127, 240).withOpacity(0.7),
//           Colors.transparent
//         ],
//         stops: [0.0, 1.0],
//       ).createShader(Rect.fromCircle(
//           center: Offset(size.width / 2, size.height * 0.1),
//           radius: size.height * 0.6));

//     Path path = Path();
//     double width = size.width;
//     double height = size.height;

//     // Define the corn shape
//     path.moveTo(width * 0.5, height * 0.0); // Top center
//     path.lineTo(width * 0.7, height * 0.8); // Bottom right

//     path.arcToPoint(Offset(width * 0.3, height * 0.8),
//         radius: Radius.circular(height * 0.6), clockwise: true); // Bottom arc
//     path.addOval(Rect.largest);
//     path.lineTo(width * 0.5, height * 0.1); // Top center again

//     // Draw the path with gradient
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
