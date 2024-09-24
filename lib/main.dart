import 'package:flutter/material.dart';
import 'package:LostObject/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objets Trouvés',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF13293D),
          secondary:
              const Color(0xFF18435A),
          onPrimary: Colors.white,
          surface: const Color(
              0xFF1B4D6E),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF16324F),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF1B4D6E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color:
                    Color(0xFF18435A),
                width: 2.0,
              ),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(
              0xFF1B4D6E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF18435A),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color:
                  Color(0xFF18435A),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF18435A),
              width: 2.0,
            ),
          ),
          labelStyle: const TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          titleLarge:
              TextStyle(color: Colors.white, fontSize: 20),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1B4D6E),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xFF18435A),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF13293D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
