import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../materials/web_theme.dart';

class WebPageShell extends StatelessWidget {
  const WebPageShell({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return ColoredBox(
      color: yukiWebBackground,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;
          return Padding(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  horizontal: compact ? 14 : 28,
                  vertical: compact ? 14 : 24,
                ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WebSurfaceCard extends StatelessWidget {
  const WebSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;
    return Card(
      child: Padding(padding: padding, child: child),
    );
  }
}

class WebAuthShell extends StatelessWidget {
  const WebAuthShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Center(child: SingleChildScrollView(child: child));
    }

    return WebPageShell(
      maxWidth: 520,
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
