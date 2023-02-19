import 'dart:ui';

import 'package:flutter/material.dart';

final _borderRadius = BorderRadius.circular(30);

class GlassBox extends StatelessWidget {
  const GlassBox({
    required this.width,
    required this.height,
    required this.child,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: _borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ]
            )
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
