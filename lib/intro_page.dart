import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool night = true;
  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context).shortestSide;
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: night
                ? [const Color(0xFF080A12), const Color(0xFF141B2E)]
                : [const Color(0xFF2A2250), const Color(0xFF43316E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'pumpkin',
                  child: Icon(
                    Icons.emoji_nature,
                    color: Colors.orange,
                    size: s * 0.34,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'A Spooky Night',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap to begin the hunt',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 26),
                FilledButton.tonal(
                  onPressed: () => Navigator.pushNamed(context, '/game'),
                  child: const Text('Begin'),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Night'),
                    Switch(
                      value: night,
                      onChanged: (v) => setState(() => night = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
