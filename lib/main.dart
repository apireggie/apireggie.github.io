import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html';

import 'canvas_repository.dart';

final canvasToken = dotenv.env['CANVAS_TOKEN'];
final openAiKey = dotenv.env['OPENAI_API_KEY'];

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const APIReggieCanvasApp());

  Future.delayed(const Duration(milliseconds: 300), () {
    final loader = document.getElementById('loading-screen');
    loader?.remove();
  });
}

class APIReggieCanvasApp extends StatelessWidget {
  const APIReggieCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: RepositoryProvider(
        create: (_) => CanvasRepository(),
        child: const Placeholder(), // Replace with actual UI widget
      ),
    );
  }
}
