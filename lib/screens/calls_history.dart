import 'package:flutter/material.dart';
import 'audio_call.dart';
import 'video_call.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  final List<Map<String, String>> recentCalls = [
    {'name': 'John Doe', 'callType': 'Incoming', 'time': '2 minutes ago'},
    {'name': 'Jane Smith', 'callType': 'Outgoing', 'time': '10 minutes ago'},
    {'name': 'Alice Brown', 'callType': 'Missed', 'time': '1 hour ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calls"),
        backgroundColor: Colors.black26,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: recentCalls.length,
              itemBuilder: (context, index) {
                final call = recentCalls[index];
                return ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: Text(call['name']!),
                  subtitle: Text('${call['callType']} • ${call['time']}'),
                  trailing: Icon(
                    call['callType'] == 'Missed' ? Icons.call_missed : Icons.call,
                    color: call['callType'] == 'Missed' ? Colors.red : Colors.green,
                  ),
                  onTap: () {
                    // Navigate to appropriate call page (Audio or Video)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => call['callType'] == 'Incoming'
                            ? const AudioCallPage()
                            : const VideoCallPage(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to New Call Options
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.call),
                          title: const Text('Start Audio Call'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AudioCallPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.video_call),
                          title: const Text('Start Video Call'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const VideoCallPage()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add_call),
              label: const Text('Start New Call'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
