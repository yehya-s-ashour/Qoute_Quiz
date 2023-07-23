import 'package:flutter/material.dart';
import 'package:quiz/data/network.dart';
import 'package:quiz/views/loading_page/loading_page.dart';

import 'views/qoute_page/qoute_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const QoutePage(),
    );
  }
}
