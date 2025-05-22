import 'dart:ui';

import 'package:flutter/material.dart';

class AgoraFloatingDisabledRemoteVideo extends StatelessWidget {
  const AgoraFloatingDisabledRemoteVideo({
    super.key,
    this.bgWidget,
    this.icon,
    this.gradient,
    this.bgColor,
    this.useBlurEffect = true,
    this.sigmaX = 10,
    this.sigmaY = 10,
    this.colorOpacity = 0.4,
  }) : assert(
          gradient != null && bgColor == null || gradient == null && bgColor != null || gradient == null && bgColor == null,
          'color assertion',
        );

  final Widget? bgWidget;
  final Widget? icon;
  final Gradient? gradient;
  final Color? bgColor;
  final bool useBlurEffect;
  final double sigmaX;
  final double sigmaY;
  final double colorOpacity;

  @override
  Widget build(BuildContext context) {
    Color? color() {
      if (gradient != null) return null;
      if (bgColor != null) return bgColor!.withValues(alpha: colorOpacity);

      return Colors.black.withValues(alpha: colorOpacity);
    }

    return Stack(
      children: [
        Positioned.fill(child: bgWidget ?? const SizedBox.shrink()),
        Builder(builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: useBlurEffect ? sigmaX : 0, sigmaY: useBlurEffect ? sigmaY : 0),
            child: Container(
              decoration: BoxDecoration(
                color: color(),
                gradient: gradient,
              ),
            ),
          );
        }),
        Center(
          child: icon ??
              const Icon(
                Icons.videocam_off,
                color: Colors.white,
                size: 24,
              ),
        ),
      ],
    );
  }
}
