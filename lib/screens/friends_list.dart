import 'package:flutter/material.dart';
import 'package:chats_app/services/message_service.dart';
import 'package:provider/provider.dart';

import '../theme_changer.dart';
import 'chat.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> filteredFriends = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChats();
    searchController.addListener(() {
      filterFriends();
    });
  }

  @override
  Future<void> fetchChats() async {
    try {
      var chats = await MessageService.getAllChats();
      if (chats != null) {
        setState(() {
          friends = chats;
          filteredFriends = chats;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching chats: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterFriends() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredFriends = friends
          .where((friend) =>
          (friend['friendName'] ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats",
          style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search friends...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredFriends.isEmpty
          ? Center(
        child: Text(
          "No chats available",
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      )
          : ListView.builder(
        itemCount: filteredFriends.length,
        itemBuilder: (context, index) {
          final friend = filteredFriends[index];
          return Container(
            color: friend['backgroundColor'] == "white"
                ? (isDarkMode ? Colors.grey[900] : Colors.white)
                : (isDarkMode ? Colors.black54 : Colors.grey[300]),
            child: ListTile(
              title: Text(
                friend['friendName'] ?? 'Unknown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: CircleAvatar(
                child: Text(friend['friendName']?[0] ?? '?'),
              ),
              subtitle: Text(friend['lastMessage'] ?? 'No messages yet'),
              trailing: Text(friend['timestamp']?.toString() ?? ''),
              onTap: () async {
               await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      friendUserId: friend['friendId'] ?? 0,
                      friendName: friend['friendName'] ?? 'Unknown',
                      currentUserId: friend['currentUserId'] ?? 'Unknown',
                    ),
                  ),
                );
                fetchChats();
              },
            ),
          );

        },
      ),
    );
  }
}
