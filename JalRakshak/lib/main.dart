import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jal_rakshak/supabase_config.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const JalRakshakApp());
}

class JalRakshakApp extends StatelessWidget {
  const JalRakshakApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jal Rakshak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1DB89D),
        scaffoldBackgroundColor: const Color(0xFF0F1419),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF1DB89D),
          secondary: const Color(0xFF64FCD9),
          surface: const Color(0xFF1A2530),
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1419),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
