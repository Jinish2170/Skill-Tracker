import 'package:flutter/material.dart';

import 'package:new_app/provider/module_provider.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SkillTrackerModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillTrack',
      home: const splashScreen(),
    );
  }
}

