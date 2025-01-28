import 'dart:ui';

import 'package:cred/utils/media_query.dart';
import 'package:flutter/material.dart';

class FrostedGlassPanel extends StatelessWidget {
  final double height;
  final Widget child;

  const FrostedGlassPanel({
    super.key,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQueryUtil.safeWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
