import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:innovasive_flutter_agora/src/agora_controller.dart';
import 'package:innovasive_flutter_agora/src/utils/condition_render.dart';

import '../models/agora_controller_state_model.dart';

class AgoraNetworkQualityState extends StatelessWidget {
  const AgoraNetworkQualityState({
    super.key,
    required this.controller,
    required this.networkNotStableText,
    this.networkNotStableTextStyle,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 0),
    this.padding = const EdgeInsets.fromLTRB(8, 0, 8, 0),
    this.bgColor,
    this.useBlurEffect = false,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.opacity = 0.4,
    this.borderRadius = 12.0,
    this.height = 28.0,
    this.icon = const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16.0),
    this.iconAndTextGap = 4.0,
    this.iconSize = 16.0,
  });

  final AgoraController controller;
  final String networkNotStableText;
  final TextStyle? networkNotStableTextStyle;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? bgColor;
  final bool useBlurEffect;
  final double sigmaX;
  final double sigmaY;
  final double opacity;
  final double borderRadius;
  final double height;
  final Widget icon;
  final double iconAndTextGap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context, AgoraControllerState state, Widget? child) {
          final TextPainter textPainter = TextPainter(
            text: TextSpan(text: networkNotStableText, style: networkNotStableTextStyle),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            maxLines: 1,
          )..layout(minWidth: 0, maxWidth: mediaQuery.size.width - margin.left - margin.right);

          final contentWidth = padding.left + padding.right + iconAndTextGap + iconSize + textPainter.width;

          return ConditionalRender.single(
            condition: state.networkQuality >= 3 && state.networkQuality <= 5,
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
                            color: (bgColor ?? Colors.black).withOpacity(opacity),
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
                            icon,
                            SizedBox(width: iconAndTextGap),
                            Text(
                              networkNotStableText,
                              style: networkNotStableTextStyle ?? const TextStyle(color: Colors.white),
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
