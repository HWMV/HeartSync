import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService extends ChangeNotifier {
  final String _baseUrl = 'https://heartsync-app-5kwhzplp3a-du.a.run.app';
  String _sessionId = '';
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  String get sessionId => _sessionId; // 새로 추가된 getter

  Future<void> initializeChat(String enhancedPersona) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/start_chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'enhance_persona': enhancedPersona}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        _sessionId = result['session_id'];
        _isInitialized = true;
        notifyListeners();
      } else {
        throw Exception('Failed to initialize chat: ${response.body}');
      }
    } catch (e) {
      print('Error initializing chat: $e');
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    if (!_isInitialized) {
      throw Exception('Chat not initialized. Please start a chat first.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send_message?session_id=$_sessionId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getEmotionState() async {
    if (!_isInitialized) {
      throw Exception('Chat not initialized. Please start a chat first.');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_emotion_state?session_id=$_sessionId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get emotion state: ${response.body}');
      }
    } catch (e) {
      print('Error getting emotion state: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getEmotionSummary() async {
    if (!_isInitialized) {
      throw Exception('Chat not initialized. Please start a chat first.');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_emotion_summary?session_id=$_sessionId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get emotion summary: ${response.body}');
      }
    } catch (e) {
      print('Error getting emotion summary: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> endConversation() async {
    if (!_isInitialized) {
      throw Exception('Chat not initialized. Please start a chat first.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/end_conversation?session_id=$_sessionId'),
      );
      if (response.statusCode == 200) {
        reset();
        return json.decode(response.body);
      } else {
        throw Exception('Failed to end conversation: ${response.body}');
      }
    } catch (e) {
      print('Error ending conversation: $e');
      rethrow;
    }
  }

  void reset() {
    _sessionId = '';
    _isInitialized = false;
    notifyListeners();
  }
}
