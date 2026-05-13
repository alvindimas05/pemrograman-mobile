import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipeProvider(),
      child: MaterialApp(
        title: 'Recipe App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF59E0B),
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFFF59E0B),
            onPrimary: Colors.white,
            surface: const Color(0xFFFFFBF5),
          ),
          textTheme: GoogleFonts.outfitTextTheme(),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
