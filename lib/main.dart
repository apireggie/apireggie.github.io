import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'canvas_repository.dart';

const openAiKey = String.fromEnvironment('OPENAI_API_KEY');
const canvasApiKey = String.fromEnvironment('CANVAS_API_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const APIReggieCanvasApp());
}

class APIReggieCanvasApp extends StatelessWidget {
  const APIReggieCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: RepositoryProvider(
          create: (_) => CanvasRepository(), child: Container()),
    );
  }
}
