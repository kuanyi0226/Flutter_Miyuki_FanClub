import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../class/Message.dart';
import '../widgets/ClubCachedImage.dart';
import '../widgets/PromoCarouselWidget.dart';

class WebHomeDashboard extends StatelessWidget {
  const WebHomeDashboard({
    super.key,
    required this.scaffoldKey,
    required this.drawer,
    required this.todaySong,
    required this.openSong,
    required this.openSearch,
    required this.openChat,
    required this.openConcert,
    required this.openYakai,
    required this.openWorld,
    required this.messages,
    required this.messageController,
    required this.messageChannel,
    required this.changeChannel,
    required this.sendMessage,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget drawer;
  final String todaySong;
  final VoidCallback openSong;
  final VoidCallback openSearch;
  final VoidCallback openChat;
  final VoidCallback openConcert;
  final VoidCallback openYakai;
  final VoidCallback openWorld;
  final Stream<List<Message>> messages;
  final TextEditingController messageController;
  final String messageChannel;
  final VoidCallback changeChannel;
  final VoidCallback sendMessage;

  static const _background = Color(0xff11131c);
  static const _surface = Color(0xff1c202c);
  static const _border = Color(0xff353949);
  static const _accent = Color(0xffe5bde3);
  static const _muted = Color(0xffb0b5c5);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
    final featureLinks = [
      (icon: Icons.forum_outlined, name: strings.chat_room, open: openChat),
      (
        icon: Icons.music_note_outlined,
        name: strings.concert,
        open: openConcert,
      ),
      (
        icon: Icons.theater_comedy_outlined,
        name: strings.yakai,
        open: openYakai,
      ),
      (icon: Icons.ac_unit, name: strings.yuki_world, open: openWorld),
    ];

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: drawer,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 68,
        elevation: 0,
        backgroundColor: _background,
        foregroundColor: _accent,
        title: const Text(
          'YUKI CLUB',
          style: TextStyle(
            fontSize: 21,
            letterSpacing: 3.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: material.searchFieldLabel,
            onPressed: openSearch,
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 12),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _border),
        ),
      ),
      body: SizedBox.expand(
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 880;
              final primary = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _panel(
                    child: InkWell(
                      onTap: todaySong == 'No Song' ? null : openSong,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.album_outlined,
                              size: 32,
                              color: _accent,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '今日の曲',
                                    style: TextStyle(color: _accent),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    todaySong.replaceAll('_', ' '),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.chevron_right, color: _muted),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, linksConstraints) {
                      final columns = linksConstraints.maxWidth >= 500 ? 4 : 2;
                      final buttonWidth =
                          (linksConstraints.maxWidth - 10 * (columns - 1)) /
                          columns;
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final link in featureLinks)
                            SizedBox(
                              width: buttonWidth,
                              child: _panel(
                                child: InkWell(
                                  onTap: link.open,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(link.icon, color: _accent),
                                        const SizedBox(height: 7),
                                        Text(
                                          link.name.replaceAll('\n', ' '),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const PromoCarouselWidget(),
                ],
              );
              final board = _buildBoard(context, strings);
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 32 : 16,
                  vertical: wide ? 28 : 18,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: primary),
                              const SizedBox(width: 24),
                              Expanded(flex: 2, child: board),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              primary,
                              const SizedBox(height: 24),
                              board,
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBoard(BuildContext context, AppLocalizations strings) {
    return _panel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.home_message_board,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: _background,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: changeChannel,
                    style: TextButton.styleFrom(
                      foregroundColor: _accent,
                      minimumSize: const Size(48, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text('#$messageChannel'),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: strings.message_board,
                        hintStyle: const TextStyle(color: _muted, fontSize: 13),
                        counterText: '',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: strings.send,
                    onPressed: sendMessage,
                    color: _accent,
                    icon: const Icon(Icons.send_rounded, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<Message>>(
              stream: messages,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Something went wrong!'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final entries = snapshot.data!;
                return Column(
                  children: [
                    for (final message in entries) ...[
                      const Divider(color: _border, height: 1),
                      _messageRow(message),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageRow(Message message) {
    final name = message.userName?.trim() ?? '';
    final photo = message.senderImgUrl?.trim() ?? '';
    final time = message.sentTime;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final initials = name.isEmpty ? '?' : name.characters.first;
    final fallback = ColoredBox(
      color: const Color(0xff453454),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(color: _accent, fontWeight: FontWeight.w700),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(
              width: 38,
              height: 38,
              child: photo.isEmpty
                  ? fallback
                  : ClubCachedImage(
                      url: photo,
                      fit: BoxFit.cover,
                      placeholder: fallback,
                      errorWidget: fallback,
                    ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '#${message.id}',
                      style: const TextStyle(color: _accent, fontSize: 12),
                    ),
                    Text(
                      name.isEmpty ? '匿名' : name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: name.startsWith('❆')
                            ? const Color(0xffaac9fa)
                            : Colors.white,
                      ),
                    ),
                    Text(
                      '${time.year}/${time.month}/${time.day} $hour:$minute',
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
                if (message.text.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(message.text, style: const TextStyle(height: 1.4)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel({required Widget child}) {
    return Material(
      color: _surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: _border),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
