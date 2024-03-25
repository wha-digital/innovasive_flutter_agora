import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraControllerState {
  final RtcEngine engine;
  final bool isLocalMuted;
  final bool isLocalVideoDisabled;
  final bool isLocalAudioActive;
  final int localUid;
  final bool isLocalJoined; //Indicates if the local user has joined the channel
  final bool isRemoteMuteMic;
  final bool isRemoteVideoDisabled;
  final bool isRemoteAudioActive;
  final int? remoteUuid;
  final String callDuration;
  final bool switchingVideoPosition;
  final int userCount;
  final bool isLocalLeaveChannel;
  final bool isRemoteLeaveChannel;
  final bool isConnectionLost;
  final int networkQuality;
  final bool isInitialized;
  final bool unStableLeaveByLocal;

  AgoraControllerState({
    required this.engine,
    this.isLocalMuted = false,
    this.isLocalVideoDisabled = false,
    this.isLocalAudioActive = false,
    this.localUid = 0,
    this.isLocalJoined = false,
    this.isRemoteMuteMic = false,
    this.isRemoteVideoDisabled = false,
    this.isRemoteAudioActive = false,
    this.remoteUuid,
    this.callDuration = '',
    this.switchingVideoPosition = false,
    this.userCount = 0,
    this.isLocalLeaveChannel = false,
    this.isRemoteLeaveChannel = false,
    this.isConnectionLost = false,
    this.networkQuality = 0,
    this.isInitialized = false,
    this.unStableLeaveByLocal = false,
  });

  AgoraControllerState copyWith({
    RtcEngine? engine,
    bool? isLocalMuted,
    bool? isLocalVideoDisabled,
    bool? isLocalAudioActive,
    int? localUid,
    bool? isLocalJoined,
    bool? isRemoteMuteMic,
    bool? isRemoteVideoDisabled,
    bool? isRemoteAudioActive,
    int? remoteUuid,
    String? callDuration,
    bool? switchingVideoPosition,
    int? userCount,
    bool? isLocalLeaveChannel,
    bool? isRemoteLeaveChannel,
    bool? isConnectionLost,
    int? networkQuality,
    bool? isInitialized,
    bool? unStableLeaveByLocal,
  }) {
    return AgoraControllerState(
      engine: engine ?? this.engine,
      isLocalMuted: isLocalMuted ?? this.isLocalMuted,
      isLocalVideoDisabled: isLocalVideoDisabled ?? this.isLocalVideoDisabled,
      isLocalAudioActive: isLocalAudioActive ?? this.isLocalAudioActive,
      localUid: localUid ?? this.localUid,
      isLocalJoined: isLocalJoined ?? this.isLocalJoined,
      isRemoteMuteMic: isRemoteMuteMic ?? this.isRemoteMuteMic,
      isRemoteVideoDisabled: isRemoteVideoDisabled ?? this.isRemoteVideoDisabled,
      isRemoteAudioActive: isRemoteAudioActive ?? this.isRemoteAudioActive,
      remoteUuid: remoteUuid ?? this.remoteUuid,
      callDuration: callDuration ?? this.callDuration,
      switchingVideoPosition: switchingVideoPosition ?? this.switchingVideoPosition,
      userCount: userCount ?? this.userCount,
      isLocalLeaveChannel: isLocalLeaveChannel ?? this.isLocalLeaveChannel,
      isRemoteLeaveChannel: isRemoteLeaveChannel ?? this.isRemoteLeaveChannel,
      isConnectionLost: isConnectionLost ?? this.isConnectionLost,
      networkQuality: networkQuality ?? this.networkQuality,
      isInitialized: isInitialized ?? this.isInitialized,
      unStableLeaveByLocal: unStableLeaveByLocal ?? this.unStableLeaveByLocal,
    );
  }
}
