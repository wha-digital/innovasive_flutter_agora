import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularActionButton extends StatelessWidget {
  const CircularActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.bgColor,
    this.opacity,
    this.useBlurEffect = true,
    this.sigmaX = 10,
    this.sigmaY = 10,
  });

  final Widget icon;
  final void Function()? onPressed;
  final Color? bgColor;
  final double? opacity;
  final bool useBlurEffect;
  final double sigmaX;
  final double sigmaY;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      minSize: 0,
      onPressed: onPressed,
      child: Material(
        color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: useBlurEffect ? sigmaX : 0, sigmaY: useBlurEffect ? sigmaY : 0),
                  child: Container(
                    color: (bgColor ?? Colors.black).withOpacity(opacity ?? 0.4),
                  ),
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
