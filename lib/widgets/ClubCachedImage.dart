import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClubCachedImage extends StatelessWidget {
  const ClubCachedImage({
    super.key,
    required this.url,
    required this.fit,
    this.placeholder,
    this.errorWidget,
    this.cacheWidth,
  });

  final String url;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? cacheWidth;

  static Future<void>? _cacheInitialization;

  static Future<void> initializeCache() {
    return _cacheInitialization ??= FastCachedImageConfig.init(
      clearCacheAfter: const Duration(days: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = placeholder ?? const SizedBox.shrink();
    final failed = errorWidget ?? loading;

    if (kIsWeb) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final logicalWidth = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : 480.0;
          final targetWidth = cacheWidth ??
              (logicalWidth * MediaQuery.devicePixelRatioOf(context))
                  .ceil()
                  .clamp(64, 720)
                  .toInt();
          return Image.network(
            url,
            key: ValueKey(url),
            fit: fit,
            cacheWidth: targetWidth,
            filterQuality: FilterQuality.low,
            gaplessPlayback: false,
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : loading,
            errorBuilder: (_, __, ___) => failed,
          );
        },
      );
    }

    final poster = FastCachedImage(
      url: url,
      fit: fit,
      loadingBuilder: (_, __) => loading,
      errorBuilder: (_, __, ___) => failed,
    );
    return poster;
  }
}

class ClubCachedAvatar extends StatelessWidget {
  const ClubCachedAvatar({
    super.key,
    required this.url,
    required this.radius,
    this.fallback = const AssetImage('assets/images/logo.png'),
  });

  final String? url;
  final double radius;
  final ImageProvider fallback;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(radius: radius, backgroundImage: fallback);
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: ClipOval(
        child: SizedBox.square(
          dimension: radius * 2,
          child: ClubCachedImage(
            url: imageUrl,
            fit: BoxFit.cover,
            errorWidget: Image(image: fallback, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
