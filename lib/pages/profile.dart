import 'package:flutter/material.dart';
import 'package:chats_app/services/login_service.dart';

import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profileData; // Holds user profile data
  bool _isLoading = true; // Tracks loading state
  bool _hasError = false; // Tracks error state

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Fetch user profile data
  void _loadProfile() async {
    try {
      var profile = await UserService.getProfile(); // Fetch the profile from the service
      if (profile != null) {
        setState(() {
          _profileData = profile;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              UserService.logout(); // Handle logout functionality
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _hasError
          ? Center(child: Text('Failed to load profile.')) // Show error message
          : _profileData == null
          ? Center(child: Text('No profile data found.')) // Show no data message
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              if (_profileData!['image'] != null)
                Image.network(_profileData!['image'])
              // Display user image Image.memory(Uint8List.fromList(_profileData!['image']));
              else
                CircleAvatar(
                  child: Icon(Icons.person_off_rounded),
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.account_circle, // Icon for full name
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Full Name: ${_profileData!['name']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Adds ellipsis for overflow
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.email, // Icon for email
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Email: ${_profileData!['email']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Adds ellipsis for overflow
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.contact_emergency, // Icon for full name
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mobile: ${_profileData!['mobile']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Adds ellipsis for overflow
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Navigate to EditProfilePage and await it to pop back
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                  // After returning from EditProfilePage, re-fetch the profile data
                  _loadProfile();
                },
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
