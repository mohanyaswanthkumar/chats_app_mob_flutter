import 'package:chats_app/pages/login.dart';
import 'package:chats_app/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_changer.dart';
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  void _toggleTheme(bool value) {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value); // Update theme via provider
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                    UserService.deleteAccount();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Account deleted successfully.')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()), // Replace with your Login screen widget
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Settings"),
      ) ,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 25,),
          ListTile(
            title: Text("WallPaper",style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
            leading: Icon(Icons.wallpaper),
            onTap: (){},
          ),
          SizedBox(height: 20,),
          ListTile(
            title: Text("Color-mode",style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
            leading: Icon(Icons.toggle_off),
            trailing: Switch(
              value: Provider.of<ThemeProvider>(context).isDarkMode, // Get the current theme from provider
              onChanged: _toggleTheme, // Toggle theme
            ),
            onTap: (){},
          ),
          SizedBox(height: 20,),
          ListTile(
            title: Text("Block-list",style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
            leading: Icon(Icons.block),
            onTap: (){},
          ),
          SizedBox(height: 20,),
          ListTile(
            title: Text("Delete-account",style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
            leading: Icon(Icons.delete),
            onTap: _showDeleteAccountDialog,
          ),
          SizedBox(height: 20,),

        ],
      ),
    );
  }
}
