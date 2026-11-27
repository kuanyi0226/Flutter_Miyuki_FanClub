import 'package:flutter/material.dart';

import 'yuki_sekai_list_page.dart' deferred as yuki_world;

class YukiWorldEntry extends StatefulWidget {
  const YukiWorldEntry({super.key});

  @override
  State<YukiWorldEntry> createState() => _YukiWorldEntryState();
}

class _YukiWorldEntryState extends State<YukiWorldEntry> {
  late Future<void> _loadGame = yuki_world.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadGame,
      builder: (context, snapshot) {
        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          return yuki_world.YukiSekaiListPage();
        }
        return Scaffold(
          appBar: AppBar(title: const Text('雪の世界 Yuki World')),
          body: Center(
            child: snapshot.hasError
                ? IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .refreshIndicatorSemanticLabel,
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        _loadGame = yuki_world.loadLibrary();
                      });
                    },
                  )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
