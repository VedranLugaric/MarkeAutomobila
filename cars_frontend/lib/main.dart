import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cars_frontend/pages/home_page.dart';
import 'package:cars_frontend/pages/start_page.dart';

void main() async => runApp(const ProviderScope(child: MainApp()));

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', 
      routes: { 
        '/': (context) => const StartPage(), 
        '/dataset': (context) => const HomePage(), 
        },
    );
  }
}
