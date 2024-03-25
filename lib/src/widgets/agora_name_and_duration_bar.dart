import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:innovasive_flutter_agora/src/agora_controller.dart';
import 'package:innovasive_flutter_agora/src/utils/condition_render.dart';

import '../models/agora_controller_state_model.dart';

class AgoraNameAndDurationBar extends StatelessWidget {
  const AgoraNameAndDurationBar({
    Key? key,
    required this.controller,
    required this.name,
    this.nameTextStyle,
    this.nameMaxLines,
    this.nameTextOverflow,
    this.nameGap,
    this.callDurationTextStyle,
    this.bgColor,
    this.opacity = 0.4,
    this.useBlurEffect = false,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.showRecordingDot = true,
    this.recordingDotColor,
    this.recordingDotGap = 6.0,
    this.recordingDotSize = 8.0,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 0),
    this.margin = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    this.height = 36,
    this.borderRadius = 12.0,
  }) : super(key: key);

  final AgoraController controller;
  final String name;
  final TextStyle? nameTextStyle;
  final int? nameMaxLines;
  final TextOverflow? nameTextOverflow;
  final double? nameGap;
  final TextStyle? callDurationTextStyle;
  final Color? bgColor;
  final double opacity;
  final bool useBlurEffect;
  final double sigmaX;
  final double sigmaY;
  final bool showRecordingDot;
  final Color? recordingDotColor;
  final double recordingDotGap;
  final double recordingDotSize;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context, AgoraControllerState state, Widget? child) {
          if (!state.isLocalJoined) return const SizedBox.shrink();
          return Container(
            clipBehavior: Clip.antiAlias,
            width: mediaQuery.size.width - margin.left - margin.right,
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: useBlurEffect ? sigmaX : 0, sigmaY: useBlurEffect ? sigmaY : 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (bgColor ?? Colors.black).withOpacity(opacity),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: padding,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: nameTextStyle ?? const TextStyle(color: Colors.white),
                            maxLines: nameMaxLines,
                            overflow: nameTextOverflow,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: nameGap ?? 8),
                            ConditionalRender.single(
                              condition: showRecordingDot,
                              widget: () => Row(
                                children: [
                                  Container(
                                    width: recordingDotSize,
                                    height: recordingDotSize,
                                    decoration: BoxDecoration(
                                      color: recordingDotColor ?? Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: recordingDotGap),
                                ],
                              ),
                              fallback: () => const SizedBox.shrink(),
                            ),
                            Text(
                              state.callDuration,
                              style: callDurationTextStyle ?? const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
