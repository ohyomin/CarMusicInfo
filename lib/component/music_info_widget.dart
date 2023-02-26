import 'dart:typed_data';
import 'dart:ui';

import 'package:car_music_info/bloc/music_info_bloc.dart';
import 'package:car_music_info/core/method_channel.dart';
import 'package:car_music_info/util/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:marquee/marquee.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../core/constants.dart';


class MetaInfoWidget extends StatelessWidget {
  const MetaInfoWidget({
    required this.title,
    required this.artist,
    required this.albumArt,
    Key? key,
  }) : super(key: key);

  final String title;
  final String artist;
  final List<int> albumArt;

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final density = MediaQuery.of(context).devicePixelRatio;
    // Normalization [0 - 1.0]
    double validDensity = density.clamp(1.7, 2.5);
    double factor = (validDensity - 1.7) / (2.5 - 1.7);


    final titleSize = lerpDouble(28.0, 18.0, factor)!.roundToDouble();
    final artistSize = lerpDouble(25.0, 15.0, factor)!.roundToDouble();
    final maxAlbumArtSize = lerpDouble(250.0, 150.0, factor)!.roundToDouble();

    Log.d('hmhm', 'density $density, factor $factor, size $maxAlbumArtSize');

    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      color: Colors.white,
      fontSize: titleSize,
      fontWeight: FontWeight.bold,
    );

    final artistStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: artistSize,
      color: const Color(0xFFEAE5E5),
    );


    final musicInfoBloc = context.read<MusicInfoBloc>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MarqueeText(
          fontSize: titleSize,
          style: titleStyle,
          text: title,
        ),
        _MarqueeText(
          fontSize: artistSize,
          style: artistStyle,
          text: artist,
        ),
        SizedBox(height: height * 0.04),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxAlbumArtSize,
              maxHeight: maxAlbumArtSize,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x54000000),
                    spreadRadius: 4,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _getAlbumArt(albumArt),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    left: -10,
                    right: -10,
                    bottom: -10,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          MethodChannelInterface.get().startApp();
                        },
                        focusNode: musicInfoBloc.albumArtFocusNode,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getAlbumArt(List<int> albumArt) {
    if (albumArt.isEmpty) {
      return const BlurHash(hash: Constants.defaultBlurHash);
    }

    return Image.memory(
      Uint8List.fromList(albumArt),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return const BlurHash(hash: Constants.defaultBlurHash);
      },
    );
  }
}

class _MarqueeText extends StatelessWidget {
  const _MarqueeText({
    required this.fontSize,
    required this.text,
    this.style,
    Key? key,
  }) : super(key: key);

  final double fontSize;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (fontSize + 15.0) * MediaQuery.of(context).textScaleFactor,
      child: AutoSizeText(
        text,
        textAlign: TextAlign.center,
        minFontSize: fontSize,
        maxFontSize: fontSize,
        style: style,
        overflowReplacement: Marquee(
          text: text,
          style: style,
          scrollAxis: Axis.horizontal,
          startAfter: const Duration(seconds: 2),
          velocity: 30.0,
          blankSpace: 70,
          showFadingOnlyWhenScrolling: true,
          pauseAfterRound: const Duration(seconds: 3),
        ),
      ),
    );
  }
}

