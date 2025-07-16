import 'package:flutter/material.dart';

class DAW extends StatelessWidget {
  const DAW({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Reggie DAW'),
      ),
      body: Center(
        child: Text(
          'Welcome to the API Reggie Digital Audio Workstation!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
