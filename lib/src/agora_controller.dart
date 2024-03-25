import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'models/agora_controller_state_model.dart';
import 'utils/duration_to_time_format.dart';
import 'utils/logger.dart';

class AgoraController extends ValueNotifier<AgoraControllerState> {
  AgoraController({
    required this.appId,
    required this.agoraToken,
    required this.channelName,
    required this.onRequestToken,
    required this.onError,
    required this.onLeavedByRemote,
    required this.onLeavedByLocal,
    required this.onPermissionError,
    this.onUserJoined,
    this.onUserOfflineDropped,
    this.onUserOfflineQuit,
    this.onUserOfflineBecomeAudience,
    this.intervalActiveSpeakerDetect = 1000,
    this.logLevel = LogLevel.logLevelWarn,
    this.videoDimensions = const VideoDimensions(height: 960, width: 720),
    this.frameRate = 30,
    this.onSetEnableSpeakerphoneError,
    this.onSetDefaultAudioRouteToSpeakerphoneError,
  }) : super(AgoraControllerState(
          engine: createAgoraRtcEngine(),
          isLocalMuted: false,
          isLocalVideoDisabled: false,
          localUid: 0,
          isLocalJoined: false,
          isRemoteMuteMic: false,
          isRemoteVideoDisabled: false,
          isLocalAudioActive: false,
          isRemoteAudioActive: false,
          remoteUuid: null,
          callDuration: '00:00',
          switchingVideoPosition: false,
          userCount: 0,
          isLocalLeaveChannel: false,
          isRemoteLeaveChannel: false,
          isConnectionLost: false,
          networkQuality: 0,
          isInitialized: false,
          unStableLeaveByLocal: false,
        )); //TODO: implement

  final String agoraToken;
  final String appId;
  final String channelName;
  final LogLevel logLevel;
  final Future<String> Function() onRequestToken;
  final void Function(AgoraController controller, ErrorCodeType err, String message) onError;
  final Future<void> Function(AgoraController controller) onLeavedByRemote;
  final Future<void> Function(AgoraController controller) onLeavedByLocal;
  final void Function(AgoraController controller, PermissionType permissionType) onPermissionError;
  final VideoDimensions videoDimensions;
  final int frameRate;
  final void Function(RtcConnection connection, int remoteUid, int elapsed)? onUserJoined;
  final Future<void> Function(AgoraController controller, RtcConnection connection, int remoteUid)? onUserOfflineDropped;
  final Future<void> Function(AgoraController controller, RtcConnection connection, int remoteUid)? onUserOfflineQuit;
  final Future<void> Function(AgoraController controller, RtcConnection connection, int remoteUid)? onUserOfflineBecomeAudience;
  final void Function(String errMessage)? onSetDefaultAudioRouteToSpeakerphoneError;
  final void Function(String errMessage)? onSetEnableSpeakerphoneError;

  final List<int> _networkQualityList = [];

  /// *NOTE: need to set with integer multiple with 200
  /// ref [https://api-ref.agora.io/en/video-sdk/flutter/6.x/API/class_irtcengine.html#api_irtcengine_enableaudiovolumeindication]
  final int intervalActiveSpeakerDetect;

  ///
  /// Setup SDK and then join channel.
  ///
  Future<void> setupVideoSDKEngine() async {
    await _initializeRtcEngine();
    await _setVideoEncoder();
    await _setAudioProfile();
    await _setChannelProfile();
    await _enableVideoAndAudio();
    await _enableAudioVolumeIndication();
    await _enableDualStreamMode();
    await _setDefaultAudioRoute();

    _registerEventHandlers();

    await join();
  }

  ///
  /// Initializes RtcEngine with `appId` and set log with `logLevel`
  ///
  Future<void> _initializeRtcEngine() async {
    await value.engine.initialize(
      RtcEngineContext(
        appId: appId,
        logConfig: LogConfig(
          level: logLevel,
        ),
      ),
    );
  }

  ///
  ///
  ///
  Future<void> _setVideoEncoder() async {
    final videoConfig = VideoEncoderConfiguration(
      mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
      frameRate: frameRate,
      bitrate: standardBitrate,
      dimensions: videoDimensions,
      orientationMode: OrientationMode.orientationModeAdaptive,
      degradationPreference: DegradationPreference.maintainBalanced,
    );

    await value.engine.setVideoEncoderConfiguration(videoConfig);
  }

  ///
  ///
  ///
  Future<void> _setAudioProfile() async {
    await value.engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioChatroom,
    );
  }

  ///
  ///
  ///
  Future<void> _setChannelProfile() async {
    await value.engine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
  }

  ///
  ///
  ///
  Future<void> _enableVideoAndAudio() async {
    await value.engine.enableVideo();
    await value.engine.enableAudio();
    await value.engine.muteLocalVideoStream(false);
    await value.engine.muteLocalAudioStream(false);

    value = value.copyWith(
      isLocalVideoDisabled: false,
      isLocalMuted: false,
    );
  }

  ///
  ///
  ///
  Future<void> _enableAudioVolumeIndication() async {
    await value.engine.enableAudioVolumeIndication(
      interval: intervalActiveSpeakerDetect,
      smooth: 3,
      reportVad: true,
    );
  }

  ///
  ///
  ///
  Future<void> _enableDualStreamMode() async {
    await value.engine.enableDualStreamMode(enabled: true);
    await value.engine.setDualStreamMode(mode: SimulcastStreamMode.autoSimulcastStream);
  }

  ///
  /// Sets the default audio playback route.
  ///
  Future<void> _setDefaultAudioRoute() async {
    try {
      /// set default audio route to speakerphone.
      await value.engine.setDefaultAudioRouteToSpeakerphone(true);
      // https://api-ref.agora.io/en/voice-sdk/flutter/6.x/API/class_irtcengine.html#api_irtcengine_setdefaultaudioroutetospeakerphone
    } catch (e) {
      onSetDefaultAudioRouteToSpeakerphoneError?.call('setDefaultAudioRouteToSpeakerphone err::$e');
      llog('setDefaultAudioRouteToSpeakerphone err::$e');
    }
  }

  ///
  /// Register the event handler
  ///
  void _registerEventHandlers() {
    value.engine.registerEventHandler(
      RtcEngineEventHandler(
        ///
        ///
        ///
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
          llog("Local user joined the channel");
          value = value.copyWith(
            isLocalJoined: true,
            localUid: 0,
          );

          try {
            if (!await value.engine.isSpeakerphoneEnabled()) {
              await value.engine.setEnableSpeakerphone(true);
              // https://api-ref.agora.io/en/voice-sdk/flutter/6.x/API/class_irtcengine.html#api_irtcengine_setenablespeakerphone
            }
          } catch (e) {
            onSetEnableSpeakerphoneError?.call('setEnableSpeakerphone err::$e');
            llog('setEnableSpeakerphone err::$e');
          }
        },

        ///
        ///
        ///
        onPermissionError: (permissionType) {
          onPermissionError(this, permissionType);
        },

        ///
        ///
        ///
        onRtcStats: (connection, stats) async {
          value = value.copyWith(
            callDuration: durationToTimeFormat(Duration(seconds: stats.duration ?? 0)),
            userCount: stats.userCount ?? 0,
          );
          // *NOTE: solution for agora trigger time update every 2 seconds
          await Future.delayed(const Duration(seconds: 1));
          value = value.copyWith(
            callDuration: durationToTimeFormat(Duration(seconds: (stats.duration ?? 0) + 1)),
            userCount: stats.userCount ?? 0,
          );
        },

        ///
        ///
        ///
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          value = value.copyWith(remoteUuid: remoteUid);
          onUserJoined?.call(connection, remoteUid, elapsed);
          llog("Remote user uid:$remoteUid joined the channel");
        },

        ///
        ///
        ///
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) async {
          if (value.unStableLeaveByLocal) return;

          if (reason == UserOfflineReasonType.userOfflineDropped && onUserOfflineDropped != null) {
            await onUserOfflineDropped?.call(this, connection, remoteUid);
            return;
          }

          if (reason == UserOfflineReasonType.userOfflineQuit && onUserOfflineQuit != null) {
            await onUserOfflineQuit?.call(this, connection, remoteUid);
            return;
          }

          if (reason == UserOfflineReasonType.userOfflineBecomeAudience && onUserOfflineBecomeAudience != null) {
            await onUserOfflineBecomeAudience?.call(this, connection, remoteUid);
            return;
          }

          value = value.copyWith(isRemoteLeaveChannel: true, remoteUuid: null);
          await leaveChannel(isLeaveByLocal: false, isLeaveByRemote: true);
          await onLeavedByRemote(this);
        },

        ///
        ///
        ///
        onLeaveChannel: (connection, stats) async {
          if (value.isRemoteLeaveChannel || value.unStableLeaveByLocal) return;

          value = value.copyWith(isLocalLeaveChannel: true);
          if (value.isLocalLeaveChannel) {
            await onLeavedByLocal(this);
          }
        },

        ///
        ///
        ///
        onRemoteAudioStateChanged: (connection, remoteUid, state, RemoteAudioStateReason reason, elapsed) {
          if (remoteUid == value.remoteUuid) {
            value = value.copyWith(isRemoteMuteMic: state == RemoteAudioState.remoteAudioStateStopped);
          }
        },

        ///
        ///
        ///
        onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
          if (remoteUid == value.remoteUuid) {
            value = value.copyWith(isRemoteVideoDisabled: state == RemoteVideoState.remoteVideoStateStopped);
          }
        },

        ///
        ///
        ///
        onError: (err, msg) {
          llog('ERR: $err, $msg');
          onError(this, err, msg);
        },

        ///
        ///
        ///
        onConnectionLost: (connection) {
          // *NOTE: 🏔 this function will trigger when 10 seconds after service try to rejoin channel and still cannot connect to server
          //TODO: implement on connect lost
          llog('💡 onConnectionLost:::${connection.localUid}');
        },

        ///
        ///
        ///
        onRejoinChannelSuccess: (connection, elapsed) {
          //TODO: implement onRejoinChannelSuccess
          llog('🔃 --- onRejoinChannelSuccess ($elapsed ms) ---');
        },

        ///
        ///
        ///
        onConnectionStateChanged: (connection, state, ConnectionChangedReasonType reason) async {
          if (state == ConnectionStateType.connectionStateReconnecting) {
            //it will reconnect 10 sec (2 time) after that onConnectionStateChanged will not callback again until onRejoinChannelSuccess.
            llog('--- reconnecting ---');
            value = value.copyWith(networkQuality: 6);
          }

          if (state == ConnectionStateType.connectionStateFailed) {
            llog('--- Connection Failed ---');
            if (value.isInitialized) {
              await leaveChannel();
            }
          }

          if (state == ConnectionStateType.connectionStateDisconnected) {
            llog('--- Connection Disconnected ---');
            if (value.isInitialized) {
              await leaveChannel();
            }
          }
        },

        ///
        ///
        ///
        onNetworkQuality: (RtcConnection connection, int remoteUid, QualityType txQuality, QualityType rxQuality) async {
          // Use uplink network quality to update the network status

          if (_networkQualityList.length > 3) {
            _networkQualityList.removeAt(0);
          }

          _networkQualityList.add(txQuality.index);

          final tempNetworkQualityList = [..._networkQualityList];
          tempNetworkQualityList.sort();

          value = value.copyWith(networkQuality: tempNetworkQualityList.last);

          // llog(
          //   '''
          //       txQuality::::${txQuality.name}(${txQuality.index}),
          //       networkQuality:::${_networkQualityList.toList()}
          //   ''',
          // );
        },

        ///
        ///
        ///
        onAudioVolumeIndication: (connection, speakers, speakerNumber, totalVolume) {
          final localSpeaker = speakers.where((e) => e.uid == value.localUid);
          final otherSpeaker = speakers.where((e) => e.uid != value.localUid && e.uid != connection.localUid);

          if (otherSpeaker.isNotEmpty) {
            if (value.isRemoteMuteMic) {
              value = value.copyWith(isRemoteAudioActive: false);
              return;
            }
            value = value.copyWith(isRemoteAudioActive: (otherSpeaker.first.volume ?? 0) > 0);
          }

          if (localSpeaker.isNotEmpty) {
            if (value.isLocalMuted) {
              value = value.copyWith(isLocalAudioActive: false);
              return;
            }
            value = value.copyWith(isLocalAudioActive: (localSpeaker.first.volume ?? 0) > 0);
          }
        },

        ///
        ///
        ///
        onRequestToken: (connection) async {
          final newToken = await onRequestToken();
          await join(token: newToken);
        },

        ///
        ///
        ///
        onAudioRoutingChanged: (routing) async {
          //ref: https://api-ref.agora.io/en/video-sdk/flutter/6.x/API/enum_audioroute.html
          llog('onAudioRoutingChanged:::$routing ${AudioRoute.values[routing]}');

          if (routing == -1 || routing == 1 || routing == 3) {
            try {
              if (!await value.engine.isSpeakerphoneEnabled()) {
                await value.engine.setEnableSpeakerphone(true);
              }
            } catch (e) {
              onSetEnableSpeakerphoneError?.call("onAudioRoutingChanged routing is (-1,1,3) can't setEnableSpeakerphone true err::$e");
              llog("onAudioRoutingChanged routing is (-1,1,3) can't setEnableSpeakerphone true err::$e");
            }
          } else {
            try {
              await value.engine.setEnableSpeakerphone(false);
            } catch (e) {
              onSetEnableSpeakerphoneError?.call("onAudioRoutingChanged routing is other can't setEnableSpeakerphone false err::$e");
              llog("onAudioRoutingChanged routing is other can't setEnableSpeakerphone false err::$e");
            }
          }
        },

        ///=====[Network Quality]=====///

        // * NOTE: wait for implement probe test
        // onLastmileQuality: (QualityType quality) {
        //   value = value.copyWith(networkQuality: quality.index);
        //   llog('💡 --- onLastmileQuality (${quality.name}) ---');
        // },
        // onLastmileProbeResult: (LastmileProbeResult result) {
        //   value.engine.stopLastmileProbeTest();
        // The result object contains the detailed test results that help you
        // manage call quality, for example, the down link jitter.
        //   llog("Downlink jitter: ${result.downlinkReport?.jitter}");
        // },

        ///=====[Network Quality]=====///
      ),
    );
  }

  ///
  /// Join the channel
  ///
  Future<void> join({String? token}) async {
    // TODO: 🏔 wait recheck when api can generate token
    // if (token == null) {
    //   await value.engine.startPreview();
    // }

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    try {
      await value.engine.joinChannel(
        token: agoraToken,
        channelId: channelName,
        options: options,
        uid: value.localUid,
      );
    } catch (e) {
      llog('joinChannel err::$e');
    }

    value = value.copyWith(isInitialized: true);
    //* NOTE: use after setup and joined channel success, use in call screen page initState or afterFirstLayout for start preview.
    // await value.engine.startPreview();
  }

  ///
  /// Function to dispose the RTC engine.
  ///
  Future<void> leaveChannel({
    bool isLeaveByLocal = true,
    bool isLeaveByRemote = false,
    bool unStableLeaveByLocal = false,
  }) async {
    llog('--- leaveChannel ---');

    value = value.copyWith(
      isLocalMuted: false,
      isLocalVideoDisabled: false,
      isLocalAudioActive: false,
      localUid: 0,
      isLocalJoined: false,
      isRemoteMuteMic: false,
      isRemoteVideoDisabled: false,
      isRemoteAudioActive: false,
      remoteUuid: null,
      callDuration: '00:00',
      switchingVideoPosition: false,
      userCount: 0,
      isLocalLeaveChannel: isLeaveByLocal,
      isRemoteLeaveChannel: isLeaveByRemote,
      isConnectionLost: false,
      networkQuality: 0,
      isInitialized: false,
      unStableLeaveByLocal: unStableLeaveByLocal,
    );

    await value.engine.stopPreview();
    await value.engine.leaveChannel();
    await value.engine.release();
  }

  ///
  ///
  ///
  Future<void> onSetUpMicFirstBuild() async {
    await value.engine.muteLocalAudioStream(false);
    value = value.copyWith(isLocalMuted: false);
  }

  ///
  ///
  ///
  Future<void> onLocalMuteToggle({bool? isMuted}) async {
    if (isMuted != null) {
      await value.engine.muteLocalAudioStream(isMuted);
      value = value.copyWith(isLocalMuted: isMuted);
      return;
    }

    if (value.isLocalMuted) {
      await value.engine.muteLocalAudioStream(false);
      value = value.copyWith(isLocalMuted: false);
    } else {
      await value.engine.muteLocalAudioStream(true);
      value = value.copyWith(isLocalMuted: true);
    }
  }

  ///
  /// Function to switch between front and rear camera
  ///
  Future<void> onLocalSwitchCamera() async {
    await value.engine.switchCamera();
  }

  ///
  /// Function to toggle enable/disable the camera
  ///
  Future<void> onLocalCameraToggle() async {
    if (value.isLocalVideoDisabled) {
      await value.engine.muteLocalVideoStream(false);
      value = value.copyWith(isLocalVideoDisabled: false);
    } else {
      await value.engine.muteLocalVideoStream(true);
      value = value.copyWith(isLocalVideoDisabled: true);
    }
  }

  ///
  ///
  ///
  void switchingVideoPosition() {
    value = value.copyWith(switchingVideoPosition: !value.switchingVideoPosition);
  }

  ///
  ///
  ///
  void startProbeTest() {
    // Configure the probe test
    LastmileProbeConfig config = const LastmileProbeConfig(
      probeUplink: true,
      probeDownlink: true,
      expectedUplinkBitrate: 100000, // Range 100000-5000000 bps
      expectedDownlinkBitrate: 100000, // Range 100000-5000000 bps
    );
    value.engine.startLastmileProbeTest(config);
    // showMessage("Running the last mile probe test ...");
    llog("Running the last mile probe test ...");
  }
}
