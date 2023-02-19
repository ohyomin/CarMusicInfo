import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:auto_size_text/auto_size_text.dart';

const _titleSize = 23.0;
const _artistSize = 20.0;

final _titleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: _titleSize,
  color: Colors.black.withOpacity(0.8),
);

final _artistStyle = TextStyle(
  fontSize: _artistSize,
  color: Colors.black.withOpacity(0.6),
);

class TitleInfoWidget extends StatelessWidget {
  const TitleInfoWidget({
    required this.title,
    required this.artist,
    Key? key,
  }) : super(key: key);

  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MarqueeText(
          fontSize: _titleSize,
          style: _titleStyle,
          text: title,
        ),
        const SizedBox(height: 5),
        _MarqueeText(
          fontSize: _artistSize,
          style: _artistStyle,
          text: artist,
        ),
      ],
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
      height: (fontSize + 13.0) * MediaQuery.of(context).textScaleFactor,
      child: AutoSizeText(
        text,
        minFontSize: fontSize,
        maxFontSize: fontSize,
        style: style,
        overflowReplacement: Marquee(
          text: text,
          style: style,
          scrollAxis: Axis.horizontal,
          velocity: 30.0,
          blankSpace: 70,
          showFadingOnlyWhenScrolling: true,
          pauseAfterRound: const Duration(seconds: 3),
        ),
      ),
    );
  }
}

