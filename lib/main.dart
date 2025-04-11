import 'package:flutter/material.dart';
import 'Login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      title: 'carros_electricos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
    return materialApp;
  }
}
