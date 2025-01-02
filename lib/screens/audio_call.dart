import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'aghora_manager.dart';

class AudioCallPage extends StatefulWidget {
  const AudioCallPage({super.key});

  @override
  State<AudioCallPage> createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  late final RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    _engine = await AgoraManager.initializeAgora();
    await _engine.enableAudio(); // Enable audio mode
    await _engine.joinChannel(
      token: AgoraManager.token,
      channelId: AgoraManager.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Call')),
      body: const Center(child: Text('Audio Call in Progress')),
    );
  }
}
