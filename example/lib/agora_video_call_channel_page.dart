import 'package:flutter/material.dart';
import 'package:innovasive_flutter_agora/innovasive_flutter_agora.dart';

class AgoraVideoCallChannelPage extends StatefulWidget {
  const AgoraVideoCallChannelPage({
    Key? key,
    required this.appId,
    required this.agoraToken,
    required this.channelName,
  }) : super(key: key);

  final String appId;
  final String agoraToken;
  final String channelName;

  static void close(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  State<AgoraVideoCallChannelPage> createState() => _AgoraVideoCallChannelPageState();
}

class _AgoraVideoCallChannelPageState extends State<AgoraVideoCallChannelPage> {
  late final AgoraController controller;
  @override
  void initState() {
    controller = AgoraController(
      onError: (controller, err, message) {},
      onRequestToken: () async {
        return '';
      },
      appId: widget.appId,
      agoraToken: widget.agoraToken,
      channelName: widget.channelName,
      onLeavedByLocal: (controller) async {
        await Future.delayed(const Duration(seconds: 3)).then((_) {
          AgoraVideoCallChannelPage.close(context);
        });
      },
      onLeavedByRemote: (controller) async {
        await Future.delayed(const Duration(seconds: 3)).then((_) {
          AgoraVideoCallChannelPage.close(context);
        });
      },
      onPermissionError: (controller, permissionType) {
        AgoraVideoCallChannelPage.close(context);
      },
    );

    controller.setupVideoSDKEngine();

    super.initState();
  }

  @override
  void dispose() {
    controller.leaveChannel();
    controller.dispose();
    super.dispose();
  }

  Future<void> onLeaveChannel() async {
    await controller
        .leaveChannel(
      isLeaveByLocal: false,
      isLeaveByRemote: false,
      unStableLeaveByLocal: true,
    )
        .then((value) {
      AgoraVideoCallChannelPage.close(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: AgoraState(
          controller: controller,
          callEndedByLocal: const Center(
            child: Text('Call Ended By Local'),
          ),
          callEndedByRemote: const Center(
            child: Text('Call Ended By Remote'),
          ),
          unStable: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Unstable Connection'),
                ElevatedButton(
                  onPressed: () async {
                    await onLeaveChannel();
                  },
                  child: const Text('Call End'),
                ),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AgoraVideoViewer(
                  controller: controller,
                ),
              ),
              // remote mute mic
              Positioned(
                bottom: 124 + mediaQuery.padding.bottom,
                child: AgoraRemoteMicMuteStatus(
                  controller: controller,
                  remoteMuteMicText: 'ไมค์ของคู่สนทนาปิดอยู่',
                ),
              ),

              // Bottom Action Bar
              Positioned(
                bottom: 20,
                child: AgoraActionButtonBar(
                    controller: controller,
                    onCallEnd: () async {
                      //TODO: recheck this, why doesn't call onLeavedByLocal(Callback).
                      await Future.delayed(const Duration(seconds: 3)).then((_) {
                        AgoraVideoCallChannelPage.close(context);
                      });
                    }),
              ),

              // uuid and Time Duration
              Positioned(
                top: 0 + mediaQuery.padding.top,
                child: AgoraNameAndDurationBar(
                  controller: controller,
                  name: 'Remote Name',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
