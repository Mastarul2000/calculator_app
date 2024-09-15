import 'package:calculator/calculator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyCalculatorApp());
}

class MyCalculatorApp extends StatelessWidget {
  const MyCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My Calculator",
        theme: ThemeData.dark(),
        home: const CalculatorHomePage());
  }
}
