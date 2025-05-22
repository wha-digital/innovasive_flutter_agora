import 'dart:ui';

import 'package:flutter/material.dart';

import '../agora_controller.dart';
import '../models/agora_controller_state_model.dart';
import '../utils/condition_render.dart';

class AgoraRemoteMicMuteStatus extends StatelessWidget {
  const AgoraRemoteMicMuteStatus({
    super.key,
    required this.controller,
    required this.remoteMuteMicText,
    this.remoteMuteMicTextStyle,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 0),
    this.padding = const EdgeInsets.fromLTRB(8, 0, 8, 0),
    this.bgColor,
    this.useBlurEffect = false,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.opacity = 0.4,
    this.borderRadius = 12.0,
    this.height = 28.0,
    this.micMuteIcon,
    this.iconColor = Colors.white,
    this.iconSize = 16.0,
    this.iconAndTextGap = 4.0,
  });

  final AgoraController controller;
  final String remoteMuteMicText;
  final TextStyle? remoteMuteMicTextStyle;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? bgColor;
  final bool useBlurEffect;
  final double sigmaX;
  final double sigmaY;
  final double opacity;
  final double borderRadius;
  final double height;
  final IconData? micMuteIcon;
  final Color? iconColor;
  final double iconSize;
  final double iconAndTextGap;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context, AgoraControllerState state, Widget? child) {
          final TextPainter textPainter = TextPainter(
            text: TextSpan(text: remoteMuteMicText, style: remoteMuteMicTextStyle),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            maxLines: 1,
          )..layout(minWidth: 0, maxWidth: mediaQuery.size.width - margin.left - margin.right);

          final contentWidth = padding.left + padding.right + iconAndTextGap + iconSize + textPainter.width;

          return ConditionalRender.single(
            condition: state.isRemoteMuteMic,
            widget: () => Container(
              margin: margin,
              width: mediaQuery.size.width - margin.left - margin.right,
              height: height,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width: contentWidth + padding.left + padding.right,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: useBlurEffect ? sigmaX : 0, sigmaY: useBlurEffect ? sigmaY : 0),
                          child: Container(
                            width: contentWidth,
                            color: (bgColor ?? Colors.black).withValues(alpha: opacity),
                            height: height,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: padding,
                        width: contentWidth + padding.left + padding.right,
                        height: height,
                        child: Row(
                          children: [
                            Icon(
                              micMuteIcon ?? Icons.mic_off,
                              color: iconColor,
                              size: iconSize,
                            ),
                            SizedBox(width: iconAndTextGap),
                            Text(
                              remoteMuteMicText,
                              style: remoteMuteMicTextStyle ?? const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            fallback: () => const SizedBox.shrink(),
          );
        });
  }
}
