import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:auto_size_text/auto_size_text.dart';

const _titleSize = 25.0;
const _artistSize = 22.0;

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
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: _titleSize,
      fontWeight: FontWeight.bold,
    );

    final artistStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: _artistSize,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MarqueeText(
          fontSize: _titleSize,
          style: titleStyle,
          text: title,
        ),
        _MarqueeText(
          fontSize: _artistSize,
          style: artistStyle,
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
      height: (fontSize + 10.0) * MediaQuery.of(context).textScaleFactor,
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

