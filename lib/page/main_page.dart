
import 'dart:typed_data';

import 'package:car_music_info/core/method_channel.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    MethodChannelInterface.get().musicInfoStream.listen((event) {
      print('hmhm info $event');
      setState(() {
        buffer = event.albumArt;
      });
    });

    super.initState();
  }

  Uint8List? buffer;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: _getAlbumArt(),
        ),
      ),
    );
  }

  Widget _getAlbumArt() {
    if (buffer == null) return const SizedBox();

    return Image.memory(buffer!,
      fit: BoxFit.cover,
    );
  }
}
