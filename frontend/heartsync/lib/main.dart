import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/ai_input_screen.dart';
import 'screens/brain_analysis_screen.dart';
import 'screens/chat_screen.dart';
import 'services/prompt_service.dart';
import 'services/chat_service.dart';
import 'screens/final_affinity_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PromptService()),
        ChangeNotifierProvider(create: (context) => ChatService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Persona Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/ai_input': (context) => AIInputScreen(),
        '/brain_analysis': (context) => BrainAnalysisScreen(),
        '/chat': (context) => ChatScreen(),
        '/final_affinity': (context) => FinalAffinityScreen(),
      },
      scrollBehavior: CustomScrollBehavior(),
      navigatorObservers: [NavigatorObserver()],
      debugShowCheckedModeBanner: false,
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
