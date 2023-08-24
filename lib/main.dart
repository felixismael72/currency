import 'package:currency/views/home_view.dart';
import 'package:currency/views/style.dart' as style;
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeView(),
      theme: style.appTheme,
    );
  }
}

