import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/bank_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BankProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0047B3),
          surface: Color(0xFF1E1E1E),
        ),
        fontFamily: 'Arimo',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
