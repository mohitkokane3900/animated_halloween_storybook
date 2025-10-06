import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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

class _SpookyHomeState extends State<SpookyHome>
    with SingleTickerProviderStateMixin {
  final rnd = Random();
  final AudioPlayer bgm = AudioPlayer();
  final AudioPlayer sfx = AudioPlayer();
  String message = 'Find the magic pumpkin';
  bool won = false;
  late AnimationController winCtl;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    bgm.setReleaseMode(ReleaseMode.loop);
    bgm.play(AssetSource('../bg_music.mp3'));
    winCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    scale = Tween<double>(
      begin: 1,
      end: 1.6,
    ).chain(CurveTween(curve: Curves.easeOutBack)).animate(winCtl);
  }

  @override
  void dispose() {
    bgm.stop();
    bgm.dispose();
    sfx.dispose();
    winCtl.dispose();
    super.dispose();
  }

  void onTrap() {
    if (won) return;
    setState(() {
      message = 'Boo! Wrong item';
    });
    sfx.play(AssetSource('../boo.mp3'));
  }

  void onTarget() {
    if (won) return;
    setState(() {
      won = true;
      message = 'You found it!';
    });
    sfx.play(AssetSource('../success.mp3'));
    winCtl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Halloween Hunt')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF0B1020)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const Starfield(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          RoamingSprite(
            icon: Icons.bedtime,
            color: Colors.blueGrey,
            size: 68,
            minDur: 1400,
            maxDur: 2600,
            onTap: onTrap,
          ),
          RoamingSprite(
            icon: Icons.cruelty_free,
            color: Colors.purpleAccent,
            size: 72,
            minDur: 1200,
            maxDur: 2200,
            onTap: onTrap,
          ),
          RoamingSprite(
            icon: Icons.emoji_emotions,
            color: Colors.white,
            size: 70,
            minDur: 1500,
            maxDur: 2400,
            onTap: onTrap,
          ),
          RoamingSprite(
            icon: Icons.emoji_nature,
            color: Colors.orange,
            size: 76,
            minDur: 1600,
            maxDur: 2600,
            onTap: onTarget,
          ),
          if (won)
            Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withOpacity(0.25),
            ),
          if (won)
            Center(
              child: ScaleTransition(
                scale: scale,
                child: const Icon(
                  Icons.emoji_nature,
                  size: 160,
                  color: Colors.orange,
                ),
              ),
            ),
          if (won) const ConfettiOverlay(),
        ],
      ),
    );
  }
}

class RoamingSprite extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final int minDur;
  final int maxDur;
  final VoidCallback onTap;
  const RoamingSprite({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    required this.minDur,
    required this.maxDur,
    required this.onTap,
  });
  @override
  State<RoamingSprite> createState() => _RoamingSpriteState();
}

class _RoamingSpriteState extends State<RoamingSprite> {
  final rnd = Random();
  late Timer timer;
  Alignment align = const Alignment(0, 0);
  int durationMs = 1800;

  @override
  void initState() {
    super.initState();
    align = Alignment(rnd.nextDouble() * 2 - 1, rnd.nextDouble() * 1.8 - 0.9);
    durationMs = rnd.nextInt(widget.maxDur - widget.minDur + 1) + widget.minDur;
    timer = Timer.periodic(Duration(milliseconds: durationMs), (_) {
      setState(() {
        align = Alignment(
          rnd.nextDouble() * 2 - 1,
          rnd.nextDouble() * 1.8 - 0.9,
        );
        durationMs =
            rnd.nextInt(widget.maxDur - widget.minDur + 1) + widget.minDur;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeInOut,
      alignment: align,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Icon(widget.icon, color: widget.color, size: widget.size),
      ),
    );
  }
}

class Starfield extends StatefulWidget {
  const Starfield({super.key});
  @override
  State<Starfield> createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield> {
  final rnd = Random();
  late List<Offset> stars;

  @override
  void initState() {
    super.initState();
    stars = List.generate(
      140,
      (_) => Offset(rnd.nextDouble(), rnd.nextDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return IgnorePointer(
      child: CustomPaint(
        painter: _StarsPainter(stars: stars),
        size: Size(w, h),
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  final List<Offset> stars;
  _StarsPainter({required this.stars});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.8);
    for (final s in stars) {
      final o = Offset(s.dx * size.width, s.dy * size.height);
      canvas.drawCircle(o, 0.8, p);
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) => false;
}

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});
  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController ctl;
  late List<_Confetti> confetti;
  final rnd = Random();

  @override
  void initState() {
    super.initState();
    ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    confetti = List.generate(
      24,
      (_) => _Confetti(
        rnd.nextDouble(),
        rnd.nextDouble(),
        rnd.nextDouble() * 0.02 + 0.008,
      ),
    );
  }

  @override
  void dispose() {
    ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: ctl,
      builder: (_, __) {
        return IgnorePointer(
          child: Stack(
            children: confetti.map((c) {
              final dy = (c.y + ctl.value * c.speed) % 1.0;
              final pos = Offset(c.x * w, dy * h);
              final emoji = ['🎃', '👻', '🦇', '🕷️'][c.index % 4];
              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _Confetti {
  final double x;
  final double y;
  final double speed;
  final int index;
  _Confetti(this.x, this.y, this.speed) : index = (x * 10000).floor();
}
