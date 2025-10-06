import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final rnd = Random();
  final player = AudioPlayer();
  final trapPlayer = AudioPlayer();
  final winPlayer = AudioPlayer();
  Offset pumpkinPos = const Offset(100, 200);
  Offset ghostPos = const Offset(200, 300);
  Offset batPos = const Offset(150, 100);
  String message = '';
  bool won = false;

  String _asset(String base) =>
      kIsWeb ? 'assets/$base.wav' : 'assets/$base.mp3';

  @override
  void initState() {
    super.initState();
    player.setReleaseMode(ReleaseMode.loop);
    player.play(AssetSource(_asset('bg_music')));
    Timer.periodic(const Duration(seconds: 2), (_) {
      if (!won) {
        setState(() {
          pumpkinPos = Offset(rnd.nextDouble() * 250, rnd.nextDouble() * 500);
          ghostPos = Offset(rnd.nextDouble() * 250, rnd.nextDouble() * 500);
          batPos = Offset(rnd.nextDouble() * 250, rnd.nextDouble() * 500);
        });
      }
    });
  }

  void _onTrap() {
    trapPlayer.play(AssetSource(_asset('boo')));
    setState(() => message = 'Boo! Wrong one...');
  }

  void _onWin() {
    winPlayer.play(AssetSource(_asset('success')));
    setState(() {
      message = 'You Found It!';
      won = true;
    });
  }

  @override
  void dispose() {
    player.dispose();
    trapPlayer.dispose();
    winPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Haunted Game')),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            left: pumpkinPos.dx,
            top: pumpkinPos.dy,
            child: GestureDetector(
              onTap: _onWin,
              child: Icon(Icons.emoji_nature, size: 60, color: Colors.orange),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            left: ghostPos.dx,
            top: ghostPos.dy,
            child: GestureDetector(
              onTap: _onTrap,
              child: Icon(Icons.cloud, size: 60, color: Colors.white),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            left: batPos.dx,
            top: batPos.dy,
            child: GestureDetector(
              onTap: _onTrap,
              child: Icon(Icons.air, size: 60, color: Colors.purpleAccent),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: won ? 32 : 20,
                  color: won ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
                duration: const Duration(milliseconds: 500),
                child: Text(message),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
