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
  });

  final String url;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

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
    final poster = FastCachedImage(
      url: url,
      fit: fit,
      loadingBuilder: (_, __) => loading,
      errorBuilder: (_, __, ___) => failed,
    );
    if (!kIsWeb) return poster;

    return FutureBuilder<void>(
      future: initializeCache(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Image.network(
            url,
            fit: fit,
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : loading,
            errorBuilder: (_, __, ___) => failed,
          );
        }
        return snapshot.connectionState == ConnectionState.done
            ? poster
            : loading;
      },
    );
  }
}
