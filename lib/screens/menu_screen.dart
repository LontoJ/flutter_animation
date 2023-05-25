import 'package:flutter/material.dart';
import 'package:flutter_animation/screens/apple_watch_screen.dart';
import 'package:flutter_animation/screens/explicit_animations_screen.dart';
import 'package:flutter_animation/screens/implicit_animations_screen.dart';
import 'package:flutter_animation/screens/music_player_screen.dart';
import 'package:flutter_animation/screens/rive_screen.dart';
import 'package:flutter_animation/screens/swiping_cards_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ImplicitAnimationsScreen(),
                );
              },
              child: const Text("Implicit Animations"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ExplicitAnimationsScreen(),
                );
              },
              child: const Text("Explicit Animations"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const AppleWatchScreen(),
                );
              },
              child: const Text("Apple Watch"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const SwipingCardsScreen(),
                );
              },
              child: const Text("Swiping Cards"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const MusicPlayerScreen(),
                );
              },
              child: const Text("Music Player"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const RiveScreen(),
                );
              },
              child: const Text("Rive"),
            ),
          ],
        ),
      ),
    );
  }
}
