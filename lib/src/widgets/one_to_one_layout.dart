import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:innovasive_flutter_agora/src/widgets/agora_disabled_local_video_view.dart';
import 'package:innovasive_flutter_agora/src/widgets/agora_floating_disable_local_video.dart';

import '../agora_controller.dart';
import '../models/agora_controller_state_model.dart';
import '../utils/condition_render.dart';
import 'agora_disabled_remote_video_view.dart';
import 'agora_floating_disable_remote_video.dart';

class OneToOneLayout extends StatefulWidget {
  const OneToOneLayout({
    Key? key,
    required this.controller,
    this.disabledLocalVideoWidget,
    this.disabledRemoteVideoWidget,
    this.floatWidth,
    this.floatHeight,
    this.floatPositionTop,
    this.floatPositionLeft,
    this.floatPositionRight,
    this.floatPositionBottom,
    this.canSwitchVideoPosition = true,
    this.disabledLocalVideoViewBg,
    this.disabledRemoteVideoViewBg,
    this.floatingDisabledLocalVideo,
    this.floatingDisabledRemoteVideo,
    this.channelBackgroundWidget,
  }) : super(key: key);

  final AgoraController controller;
  final Widget? Function(bool isLocalAudioActive)? disabledLocalVideoWidget;
  final Widget? Function(bool isRemoteAudioActive)? disabledRemoteVideoWidget;
  final double? floatWidth;
  final double? floatHeight;
  final double? floatPositionTop;
  final double? floatPositionLeft;
  final double? floatPositionRight;
  final double? floatPositionBottom;
  final bool canSwitchVideoPosition;
  final Widget? disabledLocalVideoViewBg;
  final Widget? disabledRemoteVideoViewBg;
  final Widget? floatingDisabledLocalVideo;
  final Widget? floatingDisabledRemoteVideo;
  final Widget? channelBackgroundWidget;

  @override
  State<OneToOneLayout> createState() => _OneToOneLayoutState();
}

class _OneToOneLayoutState extends State<OneToOneLayout> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (BuildContext context, AgoraControllerState state, Widget? child) {
          return Scaffold(
            body: SizedBox(
              width: mediaQuery.size.width,
              height: mediaQuery.size.height,
              child: Stack(
                children: [
                  // MainView
                  Positioned.fill(
                    child: Center(
                      child: ConditionalRender.single(
                        condition: state.switchingVideoPosition,
                        widget: () => _localPreview(state: state, isFloating: false),
                        fallback: () => _remoteVideo(state: state, isFloating: false),
                      ),
                    ),
                  ),

                  // FloatView
                  Positioned(
                    top: widget.floatPositionTop ?? 64 + mediaQuery.padding.top,
                    left: widget.floatPositionLeft ?? 16,
                    right: widget.floatPositionRight,
                    bottom: widget.floatPositionBottom,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: !widget.canSwitchVideoPosition || state.userCount < 2 ? null : () => widget.controller.switchingVideoPosition(),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: widget.floatWidth ?? mediaQuery.size.height * 0.15,
                        height: widget.floatHeight ?? mediaQuery.size.height * 0.19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: ConditionalRender.single(
                            condition: state.switchingVideoPosition,
                            widget: () => _remoteVideo(state: state, isFloating: true),
                            fallback: () => _localPreview(state: state, isFloating: true),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Display local video preview
  Widget _localPreview({
    required AgoraControllerState state,
    required bool isFloating,
  }) {
    if (state.isLocalVideoDisabled) {
      if (isFloating) {
        return widget.floatingDisabledLocalVideo ?? AgoraFloatingDisabledLocalVideo(bgWidget: widget.disabledLocalVideoViewBg);
      }
      return widget.disabledLocalVideoWidget?.call(state.isLocalAudioActive) ??
          AgoraDisabledLocalVideoView(bgWidget: widget.disabledLocalVideoViewBg);
    }

    if (state.isLocalJoined) {
      return Stack(
        children: [
          ConditionalRender.single(
            condition: !isFloating,
            widget: () => Positioned.fill(
              child: widget.channelBackgroundWidget ?? SizedBox.fromSize(),
            ),
            fallback: () => const SizedBox.shrink(),
          ),
          AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: state.engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  // Display remote user's video
  Widget _remoteVideo({
    required AgoraControllerState state,
    required bool isFloating,
  }) {
    if (state.remoteUuid != null) {
      if (state.isRemoteVideoDisabled) {
        if (isFloating) {
          return widget.floatingDisabledRemoteVideo ??
              AgoraFloatingDisabledRemoteVideo(
                bgWidget: widget.disabledRemoteVideoViewBg,
              );
        }

        return widget.disabledRemoteVideoWidget?.call(state.isRemoteAudioActive) ??
            AgoraDisabledRemoteVideoView(
              controller: widget.controller,
              bgWidget: widget.disabledRemoteVideoViewBg,
            );
      }

      return Stack(
        children: [
          ConditionalRender.single(
            condition: !isFloating,
            widget: () => Positioned.fill(
              child: widget.channelBackgroundWidget ?? SizedBox.fromSize(),
            ),
            fallback: () => const SizedBox.shrink(),
          ),
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: state.engine,
              canvas: VideoCanvas(uid: state.remoteUuid),
              connection: RtcConnection(channelId: widget.controller.channelName),
            ),
          ),
        ],
      );
    }

    return widget.channelBackgroundWidget ??
        Container(
          width: double.infinity,
          color: Colors.white,
        );
  }
}
