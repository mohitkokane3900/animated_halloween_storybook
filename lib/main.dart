import 'package:flutter/material.dart';
import 'intro_page.dart';
import 'game_page.dart';

void main() => runApp(const SpookyBook());

class SpookyBook extends StatelessWidget {
  const SpookyBook({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooktacular Storybook',
      theme: ThemeData.dark(useMaterial3: true),
      routes: {'/': (_) => const IntroPage(), '/game': (_) => const GamePage()},
      debugShowCheckedModeBanner: false,
    );
  }
}
