import 'package:flutter/material.dart';

void main() => runApp(const AppReginHome());

class AppReginHome extends StatelessWidget {
  const AppReginHome({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // 🔲 Background: Brick Wall with Rain Overlay
            Positioned.fill(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/brick_wall.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withAlpha(42),
                  ),
                  Image.asset(
                    'assets/images/rain_overlay.png',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.5),
                  ),
                ],
              ),
            ),

            // 🧭 Left Panel: Buttons
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MenuButton(label: 'Login'),
                    _MenuButton(label: 'Signup'),
                    _MenuButton(label: 'Anonymous'),
                    _MenuButton(label: 'Settings'),
                  ],
                ),
              ),
            ),

            // 🎵 Right Panel: Featured Album
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🎧 Featured Release',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black26,
                      ),
                      child: const Center(child: Text('Animated Album Art')),
                    )
                  ],
                ),
              ),
            ),

            // 🎮 Bottom Left: Arcade Zone
            Positioned(
              bottom: 20,
              left: 20,
              child: Row(
                children: [
                  Column(
                    children: [
                      const Text('🎹 Piano',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: Image.asset('assets/images/piano_keys.png'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Text('🕹️ Arcade',
                          style: TextStyle(color: Colors.white)),
                      Container(
                        width: 120,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                            child: Text('StreetRacerz',
                                style: TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Text('🎛️ DJ Wheel',
                          style: TextStyle(color: Colors.white)),
                      Image.asset('assets/images/dj_disc.png', width: 60),
                      const Text('⛽ Pedal',
                          style: TextStyle(color: Colors.white)),
                      Image.asset('assets/images/gas_pedal.png', width: 40),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  const _MenuButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withAlpha(100),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onPressed: () {},
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
