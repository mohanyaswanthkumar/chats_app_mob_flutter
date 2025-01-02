import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraManager {
  static const String appId = 'YOUR-ID'; // Replace with your Agora App ID
  static const String token = ''; // Replace with your Token (or keep empty for testing)
  static const String channelName = 'test_channel'; // Replace with your desired channel name

  static Future<RtcEngine> initializeAgora() async {
    // Create RtcEngine instance
    final engine = createAgoraRtcEngine();

    // Initialize the engine with Agora app ID
    await engine.initialize(
      const RtcEngineContext(appId: appId),
    );

    return engine;
  }
}
