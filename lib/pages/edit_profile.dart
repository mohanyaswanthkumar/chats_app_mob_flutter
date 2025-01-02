import 'package:flutter/material.dart';
import 'package:chats_app/services/login_service.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Map<String, dynamic>? _profileData; // Holds user profile data
  bool _isLoading = true; // Tracks loading state
  bool _hasError = false; // Tracks error state

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

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
          _nameController.text = profile['name'];
          _emailController.text = profile['email'];
          _mobileController.text = profile['mobile'];
          _imageUrlController.text = profile['image'] ?? '';
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

  // Save edited profile data
  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        var updatedProfile = {
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'imageUrl': _imageUrlController.text,
        };

        bool isUpdated = await UserService.updateProfile(
            updatedProfile['name']!,
            updatedProfile['email']!,
            updatedProfile['mobile']!
        );
        if (isUpdated) {
          // Successfully updated the profile
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
          Navigator.pop(context); // Go back to the Profile Page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile.')));
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _hasError
          ? Center(child: Text('Failed to load profile.')) // Show error message
          : _profileData == null
          ? Center(child: Text('No profile data found.')) // Show no data message
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    icon: Icon(Icons.account_circle),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    icon: Icon(Icons.contact_phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Profile Image URL',
                    icon: Icon(Icons.image),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid image URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
