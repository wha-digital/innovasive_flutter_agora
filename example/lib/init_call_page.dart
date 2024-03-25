import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'agora_video_call_channel_page.dart';

class InitCallPage extends StatefulWidget {
  const InitCallPage({super.key});

  @override
  State<InitCallPage> createState() => _InitCallPageState();
}

class _InitCallPageState extends State<InitCallPage> {
  late final TextEditingController appIdFieldController;
  late final TextEditingController tokenFieldController;
  late final TextEditingController channelNameFieldController;

  @override
  void initState() {
    appIdFieldController = TextEditingController(text: '');
    tokenFieldController = TextEditingController(text: '');
    channelNameFieldController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    appIdFieldController.dispose();
    tokenFieldController.dispose();
    channelNameFieldController.dispose();

    super.dispose();
  }

  bool get isActiveCallButton {
    return appIdFieldController.text.isNotEmpty && tokenFieldController.text.isNotEmpty && channelNameFieldController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Innovasice Agora Example'),
            titleTextStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            actions: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    appIdFieldController.clear();
                    tokenFieldController.clear();
                    channelNameFieldController.clear();
                    setState(() {});
                  },
                  child: const Text('Clear All'),
                ),
              ),
            ]),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Agora App Id'),
                const SizedBox(height: 8),
                TextField(
                  controller: appIdFieldController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                const Text('Agora Token'),
                const SizedBox(height: 8),
                TextField(
                  controller: tokenFieldController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                const Text('Channel Name'),
                const SizedBox(height: 8),
                TextField(
                  controller: channelNameFieldController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isActiveCallButton ? Colors.grey : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: !isActiveCallButton
                        ? null
                        : () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await [Permission.microphone, Permission.camera].request();

                            if (!(await Permission.microphone.isGranted) || !(await Permission.camera.isGranted)) {
                              return;
                            }

                            if (!mounted) return;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AgoraVideoCallChannelPage(
                                  appId: appIdFieldController.text,
                                  agoraToken: tokenFieldController.text,
                                  channelName: channelNameFieldController.text,
                                ),
                              ),
                            );
                          },
                    child: const Text('Call'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
