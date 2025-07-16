import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'canvas_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const openAiKey = String.fromEnvironment('OPENAI_API_KEY');
  const canvasApiKey = String.fromEnvironment('CANVAS_API_KEY');

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
          create: (_) => CanvasRepository(), child: const Placeholder()),
    );
  }
}
