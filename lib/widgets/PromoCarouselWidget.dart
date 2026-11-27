import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../class/Announcement.dart';
import 'ClubCachedImage.dart';

class PromoCarouselWidget extends StatefulWidget {
  const PromoCarouselWidget({Key? key}) : super(key: key);

  @override
  State<PromoCarouselWidget> createState() => _PromoCarouselWidgetState();
}

class _PromoCarouselWidgetState extends State<PromoCarouselWidget> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _announcements =
      FirebaseFirestore.instance
          .collection('announcements')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots();
  final PageController _pageController = PageController(
    initialPage: 25200,
    viewportFraction: 0.6,
  );
  Timer? _carouselTimer;
  int _currentPage = 25200;

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _setupCarouselTimer(int itemCount, {bool visible = true}) {
    if (!mounted || kIsWeb || !visible || itemCount <= 1) {
      _carouselTimer?.cancel();
      _carouselTimer = null;
      return;
    }
    _carouselTimer ??= Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageController.hasClients &&
          !_pageController.position.isScrollingNotifier.value) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  // Click URL
  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Can not launch URL: $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = TickerMode.of(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _announcements,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 250, //keep same as below
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          _carouselTimer?.cancel();
          _carouselTimer = null;
          return const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;
        final announcements = docs.map((doc) {
          return Announcement.fromJson(doc.data(), doc.id);
        }).toList();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _setupCarouselTimer(announcements.length, visible: visible);
        });

        return SizedBox(
          height: 250, //
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPage = index;
                },
                itemBuilder: (context, index) {
                  final actualIndex = index % announcements.length;
                  final ad = announcements[actualIndex];

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      final page =
                          _pageController.hasClients &&
                              _pageController.position.haveDimensions
                          ? _pageController.page
                          : null;
                      final pageOffset =
                          (page ?? _currentPage.toDouble()) - index;

                      // Calculate opacity and scale based on how far the page is from the center
                      double opacity = (1 - (pageOffset.abs() * 0.5)).clamp(
                        0.4,
                        1.0,
                      );
                      double scale = (1 - (pageOffset.abs() * 0.1)).clamp(
                        0.9,
                        1.0,
                      );

                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(scale: scale, child: child),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => _launchUrl(ad.clickUrl),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87, // background color
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ad.imageUrl.isNotEmpty
                                  ? ClubCachedImage(
                                      url: ad.imageUrl,
                                      fit: BoxFit.contain,
                                      placeholder: const ColoredBox(
                                        color: Color(0xff201d30),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: Image.asset(
                                        'assets/images/login_icon_cover.jpg',
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/login_icon_cover.jpg',
                                      fit: BoxFit.contain,
                                    ),
                              if (ad.description.isNotEmpty)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    color: Colors.black.withOpacity(0.6),
                                    child: Text(
                                      ad.description,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // left arrow
              if (announcements.length > 1)
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () {
                          if (_pageController.hasClients) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                            _carouselTimer?.cancel();
                            _carouselTimer = null;
                            _setupCarouselTimer(announcements.length);
                          }
                        },
                      ),
                    ),
                  ),
                ),

              // right arrow
              if (announcements.length > 1)
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () {
                          if (_pageController.hasClients) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                            _carouselTimer?.cancel();
                            _carouselTimer = null;
                            _setupCarouselTimer(announcements.length);
                          }
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
