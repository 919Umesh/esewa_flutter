import 'package:flutter/material.dart';
import 'package:flutter_esewa/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eSewa Payment Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3B5998),
          foregroundColor: Colors.white,
        ),
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}