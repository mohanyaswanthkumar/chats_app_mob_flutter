import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

const String baseUrl = 'http://192.168.1.27:8080/users';

class  UserService {
  // Dio client to persist cookies and manage requests
  static final Dio dio = Dio();

  // To store cookies for session management
  static final Map<String, String> _cookies = {};

  // Signup Service
  static Future<bool> signup(String email, String password, String fullName, String image) async {
    try {
      final response = await dio.post(
        '$baseUrl/signup',
        data: json.encode({
          'email': email,
          'password': password,
          'name': fullName,
          'image': image,  // Optional: this can be null or empty if not provided
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': _getCookies(),
          },
        ),
      );

      if (response.statusCode == 201) {
        _updateCookies(response);
        return true;
      } else {
        throw Exception('Failed to register user. Error: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Login Service
  static Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/login?email=$email&password=$password',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': _getCookies(),
          },
        ),
      );
      if (response.statusCode == 200) {
        _updateCookies(response);
        return true; // Login successful
      } else {
        return false; // Login failed
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

 static String _getCookies() {
    return _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
  }

  static String getCookies() {  // Made the method public
    return _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
  }

  // Profile Service (Get User Profile)
  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await dio.get(
        '$baseUrl/profile',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': _getCookies(),
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Return user profile data
      } else {
        return null; // Profile fetch failed
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final response = await dio.get(
        '$baseUrl/isLoggedIn',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': _getCookies(),
          },
        ),
      );

      if (response.statusCode == 200 && response.data['isLoggedIn'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error in isLoggedIn: $e');
      return false;
    }
  }


  // Logout Service
  static Future<void> logout() async {
    try {
      final response = await dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': _getCookies(),
          },
        ),
      );

      if (response.statusCode == 200) {
        _clearCookies(); // Clear session or cookies if necessary
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static void _updateCookies(Response response) {
    final cookieHeader = response.headers['set-cookie'];
    if (cookieHeader != null) {
      final cookies = cookieHeader.join('; ');
      final cookieList = cookies.split(';');
      for (var cookie in cookieList) {
        final parts = cookie.split('=');
        if (parts.length == 2) {
          _cookies[parts[0].trim()] = parts[1].trim();
        }
      }
    }
  }

  static void _clearCookies() {
    _cookies.clear();
  }

  static Future<List<Map<String, dynamic>>?> getAllUsersExceptLoggedIn() async {
    try {
      final response = await dio.get(
        '$baseUrl/all-users',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': _getCookies(), // Include session cookies
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse and return the list of users
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.statusCode == 401) {
        print('Unauthorized: Please log in first.');
        return null; // User not logged in
      } else {
        print('Failed to fetch users. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching users: $e');
      return null;
    }
  }

  // Add a function to get the logged-in user's ID
  static Future<int> getLoggedInUserId() async {
    try {
      // Fetch the profile of the logged-in user
      final profile = await getProfile();
      if (profile != null) {
        return profile['id']; // Assuming the 'id' field contains the user ID
      }
      return 0; // Return null if profile is not found
    } catch (e) {
      print('Error fetching user ID: $e');
      return 0;
    }
  }

  static Future<bool> updateProfile(String name, String email, String mobile) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name, // Include the name field
        'email': email, // Include the email field
        'mobile': mobile, // Include the mobile field
      });

      final response = await dio.put(
        '$baseUrl/update-profile',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Cookie': _getCookies(), // Attach cookies for session management
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        return true; // Update was successful
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return false; // Update failed
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false; // Return false on error
    }
  }

  static Future<bool> deleteAccount() async {
    try {
      final response = await dio.delete(
        '$baseUrl/delete', // Replace with your actual endpoint
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': _getCookies(),
          },
        ),
      );

      if (response.statusCode == 200) {
        _clearCookies(); // Optionally, clear the cookies after deletion
        return true; // Account deletion successful
      } else {
        return false; // Account deletion failed
      }
    } catch (e) {
      print('Error: $e');
      return false; // Handle error case
    }
  }
}
