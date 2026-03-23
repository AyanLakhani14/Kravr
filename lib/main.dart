import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'screens/main_nav_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ✅ CHECK IF USER IS LOGGED IN
  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🎨 GLOBAL THEME
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),

        // 🔥 GLOBAL FONT
        textTheme: GoogleFonts.poppinsTextTheme(),

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      // 🔐 LOGIN CHECK
      home: FutureBuilder<bool>(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data!
              ? const MainNavScreen() // 🔥 NEW NAV SYSTEM
              : const LoginScreen();
        },
      ),
    );
  }
}