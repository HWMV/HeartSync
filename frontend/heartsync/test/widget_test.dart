// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/chat_service.dart';

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   final ScrollController _scrollController = ScrollController();
//   late ChatService _chatService;
//   bool _isLoading = true;
//   String _error = '';
//   Map<String, dynamic> _emotionState = {};
//   String _dominantEmotion = '';
//   String _gender = 'man'; // 기본값 설정, 실제로는 AI 프로필에서 가져와야 합니다.

//   @override
//   void initState() {
//     super.initState();
//     _chatService = Provider.of<ChatService>(context, listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeChat();
//     });
//   }

//   Future<void> _initializeChat() async {
//     try {
//       final args =
//           ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//       final enhancedPersona = args['enhance_persona'] as String;
//       await _chatService.initializeChat(enhancedPersona);
//       setState(() => _isLoading = false);
//     } catch (e) {
//       print('Error initializing chat: $e');
//       setState(() {
//         _isLoading = false;
//         _error = 'Failed to initialize chat: $e';
//       });
//       _showErrorDialog('Chat Initialization Error', _error);
//     }
//   }

//   void _showErrorDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isEmpty) return;

//     setState(() {
//       _messages.add({'user': _messageController.text});
//       _isLoading = true;
//     });

//     try {
//       final response = await _chatService.sendMessage(_messageController.text);
//       setState(() {
//         _messages.add({'ai': response['ai_response']});
//         _emotionState = response['ai_emotions'];
//         _dominantEmotion = response['dominant_emotion'];
//         _isLoading = false;
//       });
//       _messageController.clear();
//       _scrollToBottom();
//     } catch (e) {
//       print('Error sending message: $e');
//       setState(() {
//         _isLoading = false;
//         _error = 'Error sending message: $e';
//       });
//       _showErrorDialog('Message Error', _error);
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Widget _buildAIImage() {
//     String imagePath = 'assets/${_gender}_neutral.png';
//     if (_emotionState['affection'] > 0.4) {
//       imagePath = 'assets/${_gender}_happy.png';
//     } else if (_emotionState['anger'] > 0.3 || _emotionState['anxiety'] > 0.3) {
//       imagePath = 'assets/${_gender}_angry.png';
//     } else if (_emotionState['joy'] > 0.5) {
//       imagePath = 'assets/${_gender}_joyful.png';
//     } else {
//       imagePath = 'assets/${_gender}_neutral.png';
//     }

//     return Image.asset(
//       imagePath,
//       width: 100,
//       height: 100,
//     );
//   }

//   Widget _buildEmotionDisplay() {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Text(
//               'Dominant: $_dominantEmotion',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             SizedBox(height: 4),
//             ..._emotionState.entries.map((entry) => Column(
//                   children: [
//                     Text(
//                       '${entry.key}: ${(entry.value * 100).toStringAsFixed(0)}%',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     LinearProgressIndicator(
//                       value: entry.value,
//                       backgroundColor: Colors.grey[300],
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                           _getColorForEmotion(entry.key)),
//                     ),
//                     SizedBox(height: 2),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getColorForEmotion(String emotion) {
//     switch (emotion) {
//       case 'joy':
//         return Colors.yellow;
//       case 'sadness':
//         return Colors.blue;
//       case 'anger':
//         return Colors.red;
//       case 'anxiety':
//         return Colors.purple;
//       case 'affection':
//         return Colors.pink;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with AI'),
//         backgroundColor: Colors.pink[100],
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: 1000), // 최대 너비 설정
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.pink[50]!, Colors.pink[100]!],
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: _buildAIImage(),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: _buildEmotionDisplay(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     children: [
//                       if (_error.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child:
//                               Text(_error, style: TextStyle(color: Colors.red)),
//                         ),
//                       Expanded(
//                         child: ListView.builder(
//                           controller: _scrollController,
//                           itemCount: _messages.length,
//                           itemBuilder: (context, index) {
//                             final message = _messages[index];
//                             final isUser = message.keys.first == 'user';
//                             return Align(
//                               alignment: isUser
//                                   ? Alignment.centerRight
//                                   : Alignment.centerLeft,
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: 4, horizontal: 8),
//                                 padding: EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: isUser
//                                       ? Colors.blue[100]
//                                       : Colors.pink[100],
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   message.values.first,
//                                   style: TextStyle(color: Colors.black87),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       if (_isLoading) LinearProgressIndicator(),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: _messageController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Type a message...',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             IconButton(
//                               icon: Icon(Icons.send),
//                               color: Colors.pink[300],
//                               onPressed: _chatService.isInitialized
//                                   ? _sendMessage
//                                   : null,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
