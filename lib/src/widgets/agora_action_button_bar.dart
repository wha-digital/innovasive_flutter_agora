import 'package:flutter/material.dart';
import 'package:innovasive_flutter_agora/src/agora_controller.dart';
import 'package:innovasive_flutter_agora/src/constants/bottom_action_bar_key.dart';
import 'package:innovasive_flutter_agora/src/widgets/circular_action_button.dart';

import '../models/agora_controller_state_model.dart';

class AgoraActionButtonBar extends StatelessWidget {
  const AgoraActionButtonBar({
    Key? key,
    required this.controller,
    this.onCallEnd,
    this.onBeforeCallEnd,
    this.bgActionButtonOpacity,
    this.bgActionButtonColor,
    this.endCallBgColor,
    this.cameraSwitchIcon = const Icon(Icons.flip_camera_android, color: Colors.white, size: 24),
    this.cameraSwitchIconDisabled = const Icon(Icons.flip_camera_android, color: Colors.grey, size: 24),
    this.videoIcon = const Icon(Icons.videocam, color: Colors.white, size: 24),
    this.videoOffIcon = const Icon(Icons.videocam_off, color: Colors.white, size: 24),
    this.micIcon = const Icon(Icons.mic, color: Colors.white, size: 24),
    this.micOffIcon = const Icon(Icons.mic_off, color: Colors.white, size: 24),
    this.callEndIcon = const Icon(Icons.call_end, color: Colors.white, size: 24),
    this.callEndBgOpacity = 1.0,
    this.onMicMuteToggle,
    this.bottomActionBarSort,
    this.customAction,
    this.useBlurEffect = true,
  }) : super(key: key);

  final AgoraController controller;
  final VoidCallback? onCallEnd;
  final VoidCallback? onBeforeCallEnd;
  final double? bgActionButtonOpacity;
  final Color? bgActionButtonColor;
  final Color? endCallBgColor;
  final Widget cameraSwitchIcon;
  final Widget cameraSwitchIconDisabled;
  final Widget videoIcon;
  final Widget videoOffIcon;
  final Widget micIcon;
  final Widget micOffIcon;
  final Widget callEndIcon;
  final double callEndBgOpacity;
  final Function(bool isMicMute)? onMicMuteToggle;
  final List<BottomActionBarKey>? bottomActionBarSort;
  final Widget? customAction;
  final bool useBlurEffect;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget cameraSwitchWidget(AgoraControllerState state) {
      return Expanded(
        child: CircularActionButton(
          icon: state.isLocalVideoDisabled ? cameraSwitchIconDisabled : cameraSwitchIcon,
          useBlurEffect: useBlurEffect,
          onPressed: !state.isLocalJoined || state.isLocalVideoDisabled ? null : () async => await controller.onLocalSwitchCamera(),
          bgColor: bgActionButtonColor,
          opacity: bgActionButtonOpacity,
        ),
      );
    }

    Widget cameraMuteToggleWidget(AgoraControllerState state) {
      return Expanded(
        child: CircularActionButton(
          useBlurEffect: useBlurEffect,
          icon: state.isLocalVideoDisabled ? videoOffIcon : videoIcon,
          onPressed: !state.isLocalJoined ? null : () async => await controller.onLocalCameraToggle(),
          bgColor: bgActionButtonColor,
          opacity: bgActionButtonOpacity,
        ),
      );
    }

    Widget micMuteToggleWidget(AgoraControllerState state) {
      return Expanded(
        child: CircularActionButton(
          useBlurEffect: useBlurEffect,
          icon: state.isLocalMuted ? micOffIcon : micIcon,
          onPressed: !state.isLocalJoined
              ? null
              : () async {
                  await controller.onLocalMuteToggle();
                  onMicMuteToggle?.call(state.isLocalMuted);
                },
          bgColor: bgActionButtonColor,
          opacity: bgActionButtonOpacity,
        ),
      );
    }

    Widget endCallWidget(AgoraControllerState state) {
      return Expanded(
        child: CircularActionButton(
          icon: callEndIcon,
          useBlurEffect: useBlurEffect,
          onPressed: !state.isLocalJoined
              ? null
              : () async {
                  onBeforeCallEnd?.call();
                  await controller.leaveChannel();
                  onCallEnd?.call();
                },
          bgColor: endCallBgColor ?? Colors.red,
          opacity: callEndBgOpacity,
        ),
      );
    }

    Widget customActionWidget(AgoraControllerState state) {
      return Expanded(
        child: customAction ?? const SizedBox.shrink(),
      );
    }

    List<Widget> actionBarListWidget(AgoraControllerState state) {
      List<Widget> actionBarButtonList = [];

      if (bottomActionBarSort == null && customAction == null) {
        return [
          cameraSwitchWidget(state),
          cameraMuteToggleWidget(state),
          micMuteToggleWidget(state),
          endCallWidget(state),
        ];
      }

      if (bottomActionBarSort == null && customAction != null) {
        return [
          cameraSwitchWidget(state),
          cameraMuteToggleWidget(state),
          endCallWidget(state),
          micMuteToggleWidget(state),
          customActionWidget(state),
        ];
      }

      bottomActionBarSort?.forEach((bottomActionBarKey) {
        if (bottomActionBarKey == BottomActionBarKey.cameraSwitcher) actionBarButtonList.add(cameraSwitchWidget(state));
        if (bottomActionBarKey == BottomActionBarKey.cameraMuteToggle) actionBarButtonList.add(cameraMuteToggleWidget(state));
        if (bottomActionBarKey == BottomActionBarKey.micMuteToggle) actionBarButtonList.add(micMuteToggleWidget(state));
        if (bottomActionBarKey == BottomActionBarKey.endCall) actionBarButtonList.add(endCallWidget(state));
        if (bottomActionBarKey == BottomActionBarKey.custom) actionBarButtonList.add(customActionWidget(state));
      });

      return actionBarButtonList;
    }

    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context, AgoraControllerState state, Widget? child) {
          if (!state.isLocalJoined) {
            return const SizedBox.shrink();
          }
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            width: mediaQuery.size.width - 32,
            child: Row(
              children: <Widget>[
                ...actionBarListWidget(state),
              ],
            ),
          );
        });
  }
}
