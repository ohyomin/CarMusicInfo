
import 'dart:typed_data';

import 'package:car_music_info/core/method_channel.dart';
import 'package:flutter/material.dart';
import 'package:blurhash_dart/blurhash_dart.dart' as encoder;
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image/image.dart' as img;

import '../component/glass_box.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    MethodChannelInterface.get().musicInfoStream.listen((event) {
      setState(() {
        buffer = event.albumArt;
        if (buffer != null) {
          final blurHash = encoder.BlurHash.encode(
              img.decodeImage(buffer!)!, numCompX: 5, numCompY: 5);
          hash = blurHash.hash;
        }
      });
    });

    super.initState();
  }

  Uint8List? buffer;
  String? hash = "L5H2EC=PM+yV0g-mq.wG9c010J}I";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.all(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _getBackGround(),
              ),
            ),
            Center(
              child: GlassBox(
                width: 400,
                height: 600,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _getAlbumArt(),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _getBackGround() {
    if (hash == null) {
      return const BlurHash(hash: "L5H2EC=PM+yV0g-mq.wG9c010J}I");
    }

    return BlurHash(hash: hash!, key: UniqueKey());
  }

  Widget _getAlbumArt() {
    if (buffer == null) return const SizedBox();

    return Image.memory(buffer!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox();
      },
      key: UniqueKey(),
    );
  }
}
