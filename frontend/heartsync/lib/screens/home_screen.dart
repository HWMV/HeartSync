import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink[50]!, Colors.pink[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'HeartSync',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'App User Guide',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Colors.pink[800],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInstructionText(
                                  '1. Enter the description and profile of the person you want',
                                  Icons.person_add),
                              _buildInstructionText(
                                  '2. Set the ratio of MBTI T & F',
                                  Icons.balance),
                              _buildInstructionText(
                                  '3. Start chatting with your own AI',
                                  Icons.chat),
                              _buildInstructionText(
                                  '4. Check the final favorability after "End conversation"',
                                  Icons.favorite),
                              _buildInstructionText(
                                  '5. Keep challenging yourself to increase favorability!',
                                  Icons.favorite_border_rounded),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          child: Text('Start'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.pink[300],
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/ai_input');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionText(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink[800], size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.pink[800]),
            ),
          ),
        ],
      ),
    );
  }
}
