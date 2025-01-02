import 'package:flutter/material.dart';
import 'package:chats_app/pages/login.dart';
import 'package:chats_app/pages/signup.dart';
import 'package:chats_app/pages/profile.dart';
import 'package:chats_app/services/login_service.dart';

import 'pages/settings.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool islogged = false;
  Color tileColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Future<void> checkLoginStatus() async {
    try {
      bool log = await UserService.isLoggedIn();
      setState(() {
        islogged = log;
      });
      print("Check Login Status: $islogged");
    } catch (e) {
      print("Error checking login status: $e");
    }
  }


  Future<void> logout() async {
    await UserService.logout();  // Call the logout service
    setState(() {
      islogged = false;  // Update the login status after logout
    });
    Navigator.pushReplacement(  // Navigate to the login screen after logout
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300),
        child: AppBar(
          flexibleSpace: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Image.asset(
                  'assets/logos/MYK_chats_Logo.png',
                  height: 200,
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!islogged) // Show Login and Signup if not logged in
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                  if (result != null && result) {
                    checkLoginStatus(); // Recheck the login status after login
                  }
                },
                child: Container(
                  color: tileColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.login, // Choose an appropriate icon
                      size: 30,
                      color: Colors.black, // Customize icon color if needed
                    ),
                    title: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (!islogged) // Show Signup if not logged in
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                  if (result != null && result) {
                    checkLoginStatus(); // Recheck the login status after signup
                  }
                },
                child: Container(
                  color: tileColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.app_registration, // Choose an appropriate icon
                      size: 30,
                      color: Colors.black, // Customize icon color if needed
                    ),
                    title: const Text(
                      "SignUp",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (islogged) // Show Profile and Settings if logged in
              GestureDetector(
                onTap: () {
                  // Navigate to Profile
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Container(
                  color: tileColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.verified_user, // Choose an appropriate icon
                      size: 30,
                      color: Colors.black, // Customize icon color if needed
                    ),
                    title: const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (islogged) // Show Settings if logged in
              GestureDetector(
                onTap: () {
                  // Navigate to Settings
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
                child: Container(
                  color: tileColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.settings, // Choose an appropriate icon
                      size: 30,
                      color: Colors.black, // Customize icon color if needed
                    ),
                    title: const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            if (islogged) // Show Settings if logged in
              GestureDetector(
                onTap: logout,
                child: Container(
                  color: tileColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.logout, // Choose an appropriate icon
                      size: 30,
                      color: Colors.black, // Customize icon color if needed
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
