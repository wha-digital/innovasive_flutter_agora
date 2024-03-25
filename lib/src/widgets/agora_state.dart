import 'package:flutter/material.dart';
import 'package:innovasive_flutter_agora/src/agora_controller.dart';

import '../models/agora_controller_state_model.dart';

class AgoraState extends StatelessWidget {
  const AgoraState({
    Key? key,
    required this.controller,
    required this.unStable,
    required this.child,
    required this.callEndedByRemote,
    required this.callEndedByLocal,
  }) : super(key: key);

  final AgoraController controller;
  final Widget unStable;
  final Widget child;
  final Widget callEndedByRemote;
  final Widget callEndedByLocal;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (BuildContext context, AgoraControllerState state, _) {
        if (state.networkQuality == 6) {
          return unStable;
        }

        if (state.isRemoteLeaveChannel) {
          return callEndedByRemote;
        }

        if (state.isLocalLeaveChannel) {
          return callEndedByLocal;
        }

        if (state.networkQuality < 5) {
          return child;
        }
        return child;
      },
    );
  }
}
