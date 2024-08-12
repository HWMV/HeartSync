import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/prompt_service.dart';

class AIInputScreen extends StatefulWidget {
  @override
  _AIInputScreenState createState() => _AIInputScreenState();
}

class _AIInputScreenState extends State<AIInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String _aiDescription = '';
  Map<String, dynamic> _aiProfile = {
    'age': '',
    'gender': 'man',
    'occupation': '',
    'mbti': 'INTJ',
  };
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        final promptService =
            Provider.of<PromptService>(context, listen: false);
        final result =
            await promptService.generatePersona(_aiDescription, _aiProfile);
        Navigator.pushNamed(
          context,
          '/brain_analysis',
          arguments: {
            'persona_prompt': result['persona_prompt'],
            'ai_profile': _aiProfile,
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Persona Input'),
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
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'AI Description',
                        hintText: 'Enter AI description in English',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter AI description' : null,
                      onSaved: (value) => _aiDescription = value!,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]')),
                      ],
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Age',
                        hintText: 'Enter age (numbers only)',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter age';
                        if (int.tryParse(value) == null)
                          return 'NO!!! Only number';
                        return null;
                      },
                      onSaved: (value) => _aiProfile['age'] = value!,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _aiProfile['gender'],
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: ['man', 'woman', 'other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: _isLoading
                          ? null
                          : (value) =>
                              setState(() => _aiProfile['gender'] = value!),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Occupation',
                        hintText: 'Enter occupation',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter occupation' : null,
                      onSaved: (value) => _aiProfile['occupation'] = value!,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _aiProfile['mbti'],
                      decoration: InputDecoration(
                        labelText: 'MBTI',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'INTJ',
                        'INTP',
                        'ENTJ',
                        'ENTP',
                        'INFJ',
                        'INFP',
                        'ENFJ',
                        'ENFP',
                        'ISTJ',
                        'ISFJ',
                        'ESTJ',
                        'ESFJ',
                        'ISTP',
                        'ISFP',
                        'ESTP',
                        'ESFP'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: _isLoading
                          ? null
                          : (value) =>
                              setState(() => _aiProfile['mbti'] = value!),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Generate AI Persona'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink[300],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      onPressed: _isLoading ? null : _submitForm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
