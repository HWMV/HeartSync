import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalAffinityScreen extends StatefulWidget {
  @override
  _FinalAffinityScreenState createState() => _FinalAffinityScreenState();
}

class _FinalAffinityScreenState extends State<FinalAffinityScreen> {
  late ChatService _chatService;
  bool _isLoading = true;
  Map<String, dynamic> _emotionSummary = {};
  double _finalAffinity = 0.0;

  @override
  void initState() {
    super.initState();
    _chatService = Provider.of<ChatService>(context, listen: false);
    _loadFinalAffinity();
  }

  Future<void> _loadFinalAffinity() async {
    try {
      final result = await _chatService.endConversation();
      setState(() {
        _emotionSummary = result['emotion_summary'];
        _finalAffinity = _calculateFinalAffinity(_emotionSummary['average']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading final affinity: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error', 'Failed to load final affinity: $e');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double _calculateFinalAffinity(Map<String, dynamic> averageEmotions) {
    double positiveScore =
        ((averageEmotions['affection'] as num? ?? 0).toDouble() +
                (averageEmotions['joy'] as num? ?? 0).toDouble()) /
            2 *
            100;
    double negativeScore =
        ((averageEmotions['sadness'] as num? ?? 0).toDouble() +
                (averageEmotions['anger'] as num? ?? 0).toDouble() +
                (averageEmotions['anxiety'] as num? ?? 0).toDouble()) /
            3 *
            100;
    return (positiveScore - negativeScore).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Affinity'),
        backgroundColor: Colors.pink[100],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.pink[100]!, Colors.purple[100]!],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Final Affinity',
                        style: GoogleFonts.pacifico(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${_finalAffinity.toStringAsFixed(2)}',
                          style: GoogleFonts.rubikMonoOne(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // 여기에 감정 요약이나 다른 정보를 표시할 예정
                  ],
                ),
              ),
            ),
    );
  }
}
