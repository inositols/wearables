import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/dashboard_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const BiometricsApp());
}

class BiometricsApp extends StatelessWidget {
  const BiometricsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
      child: MaterialApp(
        title: 'Biometrics Dashboard',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          cardColor: Colors.white,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(color: Color(0xFF1A1A1A)),
            headlineMedium: TextStyle(color: Color(0xFF1A1A1A)),
            headlineSmall: TextStyle(color: Color(0xFF1A1A1A)),
            bodyLarge: TextStyle(color: Color(0xFF1A1A1A)),
            bodyMedium: TextStyle(color: Color(0xFF1A1A1A)),
            bodySmall: TextStyle(color: Color(0xFF1A1A1A)),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(color: Colors.white),
            headlineMedium: TextStyle(color: Colors.white),
            headlineSmall: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white70),
          ),
        ),
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
