import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/prompt_service.dart';

class BrainAnalysisScreen extends StatefulWidget {
  @override
  _BrainAnalysisScreenState createState() => _BrainAnalysisScreenState();
}

class _BrainAnalysisScreenState extends State<BrainAnalysisScreen> {
  double _tWeight = 0.5;
  String _personaPrompt = '';
  Map<String, dynamic> _aiProfile = {};
  String _enhancedPrompt = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _personaPrompt = args['persona_prompt'] ?? '';
        _aiProfile = args['ai_profile'] ?? {};
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Required data not provided')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _enhancePersona() async {
    setState(() => _isLoading = true);
    try {
      final promptService = Provider.of<PromptService>(context, listen: false);
      final result = await promptService.enhancePersona(
        _personaPrompt,
        _aiProfile,
        _tWeight,
        1 - _tWeight,
      );
      setState(() {
        _enhancedPrompt = result['enhance_persona'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to enhance persona: $e')),
      );
    }
  }

  void _startChat() {
    Navigator.pushNamed(context, '/chat', arguments: {
      'enhance_persona': _enhancedPrompt,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T/F Selection & Final Persona'),
        backgroundColor: Colors.pink[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink[50]!, Colors.pink[100]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Adjust T/F Balance:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Slider(
                          value: _tWeight,
                          onChanged: (value) {
                            setState(() {
                              _tWeight = value;
                            });
                          },
                          activeColor: Colors.pink[300],
                          inactiveColor: Colors.pink[100],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('T: ${(_tWeight * 100).toStringAsFixed(0)}%'),
                            Text(
                                'F: ${((1 - _tWeight) * 100).toStringAsFixed(0)}%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Enhance Persona'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink[300],
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: _isLoading ? null : _enhancePersona,
                ),
                SizedBox(height: 20),
                if (_enhancedPrompt.isNotEmpty)
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enhanced Persona:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(_enhancedPrompt),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Start Chat'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink[300],
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: _enhancedPrompt.isNotEmpty ? _startChat : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
