import 'package:flutter/material.dart';
import 'package:chats_app/pages/login.dart';
import 'package:chats_app/services/login_service.dart'; // Make sure you import your main page or home page

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // Function to handle signup
  Future<void> handleSignup() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;
    String image = _imageController.text; // Assuming you want to use this later

    bool isSignedUp = await UserService.signup(email, password, name,image);

    if (isSignedUp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Navigate to your home or dashboard screen
      );
    } else {
      // Show an error message if signup fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed, please try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Image.asset(
                  'assets/logos/MYK_chats_Logo.png',
                  height: 100,
                  width: 160,
                ),
                const SizedBox(height: 65),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true, // To obscure the text in the password field
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                TextField(
                  controller: _imageController,
                  obscureText: true, // To obscure the text in the password field
                  decoration: InputDecoration(
                    labelText: 'Image',
                    hintText: 'Enter your Image',
                    border: UnderlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: handleSignup, // Call the handleSignup function
                  child: Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
