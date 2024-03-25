import 'package:flutter/material.dart';

import '../agora_controller.dart';
import '../models/agora_controller_state_model.dart';
import 'one_to_one_layout.dart';

class AgoraVideoViewer extends StatelessWidget {
  const AgoraVideoViewer({
    Key? key,
    required this.controller,
    this.notInitializedWidget,
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
  final Widget? notInitializedWidget;
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context, AgoraControllerState state, Widget? child) {
          if (!state.isInitialized) {
            return notInitializedWidget ?? const Center(child: CircularProgressIndicator());
          }

          //* Note: If you want to use other layout,You can change it to switch case for handle you're layout type.
          return OneToOneLayout(
            controller: controller,
            disabledLocalVideoWidget: disabledLocalVideoWidget,
            disabledRemoteVideoWidget: disabledRemoteVideoWidget,
            floatWidth: floatWidth,
            floatHeight: floatHeight,
            floatPositionTop: floatPositionTop,
            floatPositionLeft: floatPositionLeft,
            floatPositionRight: floatPositionRight,
            floatPositionBottom: floatPositionBottom,
            canSwitchVideoPosition: canSwitchVideoPosition,
            disabledLocalVideoViewBg: disabledLocalVideoViewBg,
            disabledRemoteVideoViewBg: disabledRemoteVideoViewBg,
            floatingDisabledLocalVideo: floatingDisabledLocalVideo,
            floatingDisabledRemoteVideo: floatingDisabledRemoteVideo,
            channelBackgroundWidget: channelBackgroundWidget,
          );
        });
  }
}
