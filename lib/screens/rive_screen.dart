import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveScreen extends StatefulWidget {
  const RiveScreen({Key? key}) : super(key: key);

  @override
  State<RiveScreen> createState() => _RiveScreenState();
}

class _RiveScreenState extends State<RiveScreen> {

  void _onInit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 400,
              child: RiveAnimation.asset(
                "assets/animations/old-man-animation.riv",
                artboard: "Dwarf Panel",
                stateMachines: ["State Machine 1"],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Go!"),
            ),
          ],
        ),
      ),
    );
  }
}
