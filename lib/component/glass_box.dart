import 'package:car_music_info/util/extensions.dart';
import 'package:flutter/material.dart';

final _borderRadius = BorderRadius.circular(30);

class GlassBox extends StatelessWidget {
  const GlassBox({
    required this.child,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).isWide;
    final radius =  isWide ? _borderRadius :BorderRadius.zero;
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        child: Container(
          // decoration: BoxDecoration(
          //   borderRadius: radius,
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Colors.black.withOpacity(0.3),
          //       Colors.black.withOpacity(0.1),
          //     ],
          //   ),
          // ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
