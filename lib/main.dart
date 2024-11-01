import 'package:flutter/material.dart';
import 'screens/temperature_converter_screen.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        cardTheme: const CardTheme(
          elevation: 4,
          margin: EdgeInsets.all(8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      home: const TemperatureConverterScreen(),
    );
  }
}