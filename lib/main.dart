import 'package:flutter/material.dart';

void main() => runApp(const HalloweenApp());

class HalloweenApp extends StatelessWidget {
  const HalloweenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Hunt',
      theme: ThemeData.dark(useMaterial3: true),
      home: const SpookyHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpookyHome extends StatefulWidget {
  const SpookyHome({super.key});
  @override
  State<SpookyHome> createState() => _SpookyHomeState();
}

class _SpookyHomeState extends State<SpookyHome> {
  String message = 'Find the magic pumpkin';
  bool won = false;

  void onTrap() {
    if (won) return;
    setState(() {
      message = 'Boo! Wrong item';
    });
  }

  void onTarget() {
    if (won) return;
    setState(() {
      won = true;
      message = 'You found it!';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Halloween Hunt')),
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black, Color(0xFF0B1020)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(message, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
          ),
          Align(
            alignment: const Alignment(-0.7, -0.2),
            child: GestureDetector(
              onTap: onTrap,
              child: const Icon(Icons.emoji_emotions, size: 72, color: Colors.white),
            ),
          ),
          Align(
            alignment: const Alignment(0.8, -0.1),
            child: GestureDetector(
              onTap: onTrap,
              child: const Icon(Icons.bedtime, size: 68, color: Colors.blueGrey),
            ),
          ),
          Align(
            alignment: const Alignment(0.1, 0.2),
            child: GestureDetector(
              onTap: onTarget,
              child: const Icon(Icons.emoji_nature, size: 76, color: Colors.orange),
            ),
          ),
          if (won)
            Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withOpacity(0.3),
            ),
        ],
      ),
    );
  }
}