import 'package:flutter/material.dart';
import 'package:chats_app/services/login_service.dart';
import 'package:chats_app/services/message_service.dart';

import 'chat.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({super.key});

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  bool isLoading = true;  // Tracks loading state
  bool hasError = false;  // Tracks error state
  List<Map<String, dynamic>> friends = [];

  int currentUserId=0;

  @override
  void initState() {
    super.initState();
    _getUserId();
    _searchFriends();
  }

  Future<void> _getUserId() async {
    int userId = (await UserService.getLoggedInUserId());
    setState(() {
      currentUserId = userId;
    });
  }

  @override
  void _searchFriends() async {
    try {
      var chats = await UserService.getAllUsersExceptLoggedIn();
      if (chats != null) {
        setState(() {
          friends = chats;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Friends"),
        backgroundColor: Colors.black26,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : hasError
          ? const Center(child: Text("Failed to load friends."))
          : friends.isEmpty
          ? const Center(child: Text("No friends found"))
          : Expanded( // Ensure ListView has constraints
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  '${friend['name']?[0]}' ?? '?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                '${friend['name']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      friendUserId: friend['id'], // Pass the friend's ID
                      friendName: friend['name'],
                      currentUserId:currentUserId ,// Pass the friend's name
                    ),
                  ),
                );
              },

            );
          },
        ),
      ),
    );
  }
}
