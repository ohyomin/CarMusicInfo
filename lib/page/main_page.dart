
import 'dart:typed_data';

import 'package:car_music_info/component/remote_controller_widget.dart';
import 'package:car_music_info/component/title_info_widget.dart';
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
        title = event.title;
        artist = event.artist;
        if (event.albumArt != null && event.albumArt!.isNotEmpty) {
          buffer = event.albumArt;
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
  String title = '';
  String artist = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: _getBackGround(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassBox(
                    width: 300,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      child: Column(
                        key: ValueKey(hash),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            height: 120,
                            child: TitleInfoWidget(
                              title: title,
                              artist: artist,
                            ),
                          ),
                          Flexible(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 230,
                                maxHeight: 230
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x54000000),
                                      spreadRadius:4,
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: _getAlbumArt(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: const RemoteControllerWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const placeHolder = BlurHash(hash: "L5H2EC=PM+yV0g-mq.wG9c010J}I");

  Widget _getBackGround() {
    if (hash == null) {
      return placeHolder;
    }

    return BlurHash(hash: hash!, key: ValueKey(hash));
  }

  Widget _getAlbumArt() {
    if (buffer == null)  {
      return placeHolder;
    }

    return Image.memory(
      buffer!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox();
      },
    );
  }
}
