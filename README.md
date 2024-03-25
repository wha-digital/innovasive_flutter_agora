# Innovasive Flutter Agora (VideoUIKit for Flutter).
Instantly integrate Agora Video Calling into your Flutter application.  

## Getting started

//TODO: Add Image Preview or Video Preview.

### Roadmap
 *Now Only Support One to One Video Call (2 users).
- [x] More Event Callbacks  *
- [x] Layout for One to One Video Call *
- [x] Muting/Unmuting Mic Local and Remote * (remote now only support get state of muteMic)
- [x] Disable Video View Local and Remote * (remote now only support get state of disable view)
- [x] Audio Active Indicator. *
- [x] Time Duration.
- [x] Switch Camera (rear/front).
- [x] User Offline Handle.
- [x] Connection State Changed Handle.
- [x] Audio Routing Changed Handle
- [x] Auto Set Audio to speaker.
- [ ] Resign Token.
- [ ] Support Draggable Float View.
- [ ] Support In App Pip View.
- [ ] Add More Configuration.
- [ ] Face Detection.
- [ ] Grid Layout of more than Two Video Call.
- [ ] Auto Update Layout Mode by User Count.
- [ ] Re-orderable Grid Layout.
- [ ] Layout for Voice Calls.
- [ ] Screen Sharing. 
- [ ] Cloud recording.
- [ ] Promoting an audience member to a broadcaster role.
- [ ] Other

### Requirements

- [An Agora developer account](https://www.agora.io/en/blog/how-to-get-started-with-agora)
- An Android or iOS Device
- A Flutter Project
  
### Installation

In your Flutter application, add the `innovasive_flutter_agora` as a dependency inside your `pubspec.yaml` file.

```yaml
dependencies:
  innovasive_flutter_agora:
    git:
      url: https://gitlab+deploy-token-24:UyXDtmFkrj6p4V9CLTKU@git.innovasive.co.th/mobile/innovasive_flutter_agora.git
      ref: 0.5.0
```


### Device Permission

Agora Video SDK requires `camera` and `microphone` permission to start video call.

#### Android

Open the `AndroidManifest.xml` file and add the required device permissions to the file.

```xml
<manifest>
  ...
  <uses-permission android:name="android.permission.READ_PHONE_STATE" />
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <uses-permission android:name="android.permission.BLUETOOTH" />
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.WAKE_LOCK" />
  <uses-permission android:name="android.permission.READ_PRIVILEGED_PHONE_STATE"
    tools:ignore="ProtectedPermissions" />
  ...
</manifest>
```

#### iOS

Open `info.plist` and add:

-  `Privacy - Microphone Usage Description`, and add a note in the Value column.
-  `Privacy - Camera Usage Description`, and add a note in the Value column.

Your application can still run the voice call when it is switched to the background if the background mode is enabled. Select the app target in Xcode, click the Capabilities tab, enable Background Modes, and check Audio, AirPlay, and Picture in Picture.

## Usage

```dart
//TODO: add simple example code.
```

