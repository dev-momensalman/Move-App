import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF080b14),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CineVaultApp());
}

class CineVaultApp extends StatelessWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080b14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366f1),
          secondary: Color(0xFFec4899),
          surface: Color(0xFF111827),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF080b14),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Color(0xFFf0f4ff),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
