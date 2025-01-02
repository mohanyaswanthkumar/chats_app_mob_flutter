import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:chats_app/services/login_service.dart';

const String baseUrl = 'http://192.168.1.27:8080/messages';

class MessageService {
  static final Dio dio = Dio();

  // Fetch chat history between the logged-in user and a friend
  static Future<List<Map<String, dynamic>>?> getChatHistory(int friendUserId) async {
    try {
      final response = await dio.get(
        '$baseUrl/$friendUserId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': UserService.getCookies(),  // Use cookies from UserService
          },
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to fetch chat history.');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Fetch all chats sent or received by the logged-in user
  static Future<List<Map<String, dynamic>>?> getAllChats() async {
    try {
      final response = await dio.get(
        '$baseUrl/all-chats',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': UserService.getCookies(),  // Use cookies from UserService
          },
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to fetch all chats.');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Send a new message from the logged-in user to another user
  static Future<bool> sendMessage(int receiverId, String content) async {
    try {
      final response = await dio.post(
        '$baseUrl/send/$receiverId',
        data: json.encode(content),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': UserService.getCookies(),  // Use cookies from UserService
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to send message.');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
