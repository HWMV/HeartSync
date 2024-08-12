import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PromptService extends ChangeNotifier {
  final String _baseUrl = 'https://heartsync-app-5kwhzplp3a-du.a.run.app';

  Future<Map<String, dynamic>> generatePersona(
      String aiDescription, Map<String, dynamic> aiProfile) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/generate_persona'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ai_description': aiDescription,
        'ai_profile': aiProfile,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to generate persona');
    }
  }

  Future<Map<String, dynamic>> enhancePersona(
    String personaPrompt,
    Map<String, dynamic> aiProfile,
    double tWeight,
    double fWeight,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/enhance_persona'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'persona_prompt': personaPrompt,
          'ai_profile': aiProfile,
          't_weight': tWeight,
          'f_weight': fWeight,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to enhance persona: ${response.body}');
      }
    } catch (e) {
      print('Error enhancing persona: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> startChat(String personaPrompt) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/start_chat'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'prompt': personaPrompt,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to start chat');
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send_message'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<Map<String, dynamic>> getEmotionState() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_emotion_state'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get emotion state');
    }
  }

  Future<Map<String, dynamic>> getEmotionSummary() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_emotion_summary'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get emotion summary');
    }
  }

  Future<Map<String, dynamic>> endConversation() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/end_conversation'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to end conversation');
    }
  }
}
