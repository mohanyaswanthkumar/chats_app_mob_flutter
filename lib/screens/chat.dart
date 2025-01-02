import 'package:flutter/material.dart';
import 'package:chats_app/screens/video_call.dart';
import 'package:chats_app/services/message_service.dart';
import 'package:intl/intl.dart';

import 'audio_call.dart';

class ChatPage extends StatefulWidget {
  final int friendUserId;
  final String friendName;
  final int currentUserId;

  const ChatPage({
    super.key,
    required this.friendUserId,
    required this.friendName,
    required this.currentUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> chatHistory = [];
  TextEditingController messageController = TextEditingController();
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
  }

  Future<void> fetchChatHistory() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      var history = await MessageService.getChatHistory(widget.friendUserId);
      if (history != null) {
        setState(() {
          chatHistory = history;
        });
      } else {
        setState(() {
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendMessage() async {
    String content = messageController.text.trim();
    if (content.isNotEmpty) {
      bool success = await MessageService.sendMessage(widget.friendUserId, content);
      if (success) {
        await fetchChatHistory();
        messageController.clear();
      }
    }
  }

  String formatTimestamp(String? timestamp) {
    if (timestamp == null) {
      return '';
    }
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Text(widget.friendName[0]),
            ),
            const SizedBox(width: 10),
            Text(widget.friendName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AudioCallPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VideoCallPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text("Failed to load chat history."))
          : Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: chatHistory.isEmpty
                ? const Center(child: Text("No messages yet."))
                : ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final message = chatHistory[index];
                final isSentByMe =
                    message['sender']['id'] == widget.currentUserId;
                final timestamp = message['timestamp'] ?? '';
                return Align(
                  alignment: isSentByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ), // External margin
                    padding: const EdgeInsets.all(12), // Internal padding
                    decoration: BoxDecoration(
                      color: isSentByMe
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isSentByMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['content'] ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            color: isSentByMe
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatTimestamp(timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSentByMe
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), // Margin around the input field
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0), // Padding between TextField and button
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0), // Internal padding of TextField
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
