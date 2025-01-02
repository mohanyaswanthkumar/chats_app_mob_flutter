import 'package:flutter/material.dart';
import 'package:chats_app/main.dart';
import 'package:chats_app/services/login_service.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle login
  Future<void> handleLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    bool isLoginSuccessful = await UserService.login(email, password);

    if (isLoginSuccessful) {
      // Navigate to MainPage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()), // Navigate directly to MainPage
      );
    } else {
      // Show an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid login credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Image.asset(
                'assets/logos/MYK_chats_Logo.png',
                height: 100,
                width: 160,
              ),
              SizedBox(height: 65),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true, // To obscure the text in the password field
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: handleLogin, // Call the handleLogin function
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
