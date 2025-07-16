import 'package:flutter/material.dart';

class AppReginApp extends StatelessWidget {
  const AppReginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AppRegin Suite',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const CheckedModeBanner(child: AppReginApp()));
  }
}
