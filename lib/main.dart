import 'package:flutter/material.dart';

import 'CookieHomePage.dart';

void main() => runApp(CookieClickerApp());

class CookieClickerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rockstar Cookie Clicker',
      home: CookieHomePage(),
    );
  }
}