import 'package:flutter/material.dart';
import 'package:chats_app/navbar.dart';
import 'package:chats_app/screens/calls_history.dart';
import 'package:chats_app/screens/friends_list.dart';
import 'package:chats_app/screens/search_friends.dart';
import 'package:provider/provider.dart';
import 'theme_changer.dart';
void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Initialize ThemeProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, // Set theme based on state
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  final List<Widget> screen=[FriendsList(),Calls()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MYK_Chats"),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Navbar(),
      ),
      body: screen[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchFriends()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

