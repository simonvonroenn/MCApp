import 'package:flutter/material.dart';

import 'cookie_homepage.dart';

void main() => runApp(const CookieClickerApp());

/// The Rockstar Cookie Clicker App.
class CookieClickerApp extends StatelessWidget {
  const CookieClickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Rockstar Cookie Clicker',
      home: CookieHomePage(),
    );
  }
}