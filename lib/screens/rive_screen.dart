import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveScreen extends StatefulWidget {
  const RiveScreen({Key? key}) : super(key: key);

  @override
  State<RiveScreen> createState() => _RiveScreenState();
}

class _RiveScreenState extends State<RiveScreen> {
  late final StateMachineController _stateMachineController;

  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      "state",
      onStateChange: (stateMachineName, stateName) {
        print("State Machine: $stateMachineName, State: $stateName");
      },
    )!;
    artboard.addController(_stateMachineController);
  }

  void _togglePanel() {
    final input = _stateMachineController.findInput<bool>("panelActive")!;
    input.change(!input.value);
  }

  @override
  void dispose() {
    _stateMachineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive'),
      ),
      // body: Center(
      //   child: Container(
      //     color: Colors.black,
      //     width: double.infinity,
      //     child: RiveAnimation.asset(
      //       "assets/animations/balls-animation.riv",
      //       artboard: "main",
      //       stateMachines: ["state"],
      //       onInit: _onInit,
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          RiveAnimation.asset(
            "assets/animations/custom-button-animation.riv",
            stateMachines: ["state"],
          ),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
