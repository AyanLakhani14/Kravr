import 'package:flutter/material.dart';

void main() {
  runApp(const KravrApp());
}

class KravrApp extends StatelessWidget {
  const KravrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kravr',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Kravr App Starting...'),
        ),
      ),
    );
  }
}