import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/message.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(MessageTypeAdapter());

  // Open Hive boxes
  await Hive.openBox<Message>('messages');
  await Hive.openBox('settings');

  runApp(const MessagingApp());
}

/// Main application widget
class MessagingApp extends StatelessWidget {
  const MessagingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Material Design 3
        useMaterial3: true,

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo-600
          primary: const Color(0xFF4F46E5),
          secondary: const Color(0xFF818CF8), // Indigo-400
          surface: Colors.white,
        ),

        // Text theme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1F2937)), // Gray-900
          bodyMedium: TextStyle(color: Color(0xFF1F2937)),
          bodySmall: TextStyle(color: Color(0xFF6B7280)), // Gray-500
        ),

        // AppBar theme
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),

        // Icon theme
        iconTheme: const IconThemeData(color: Color(0xFF6B7280)),
      ),
      home: const SplashScreen(),
    );
  }
}
