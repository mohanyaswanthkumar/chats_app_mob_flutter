import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Default to light theme
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners(); // Notify all listeners (widgets) when theme changes
  }
}
