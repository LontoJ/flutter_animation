import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({Key? key}) : super(key: key);

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  late final Animation<double> _defaultProgress = Tween(
    begin: 0.005,
    end: _getRandomDouble(),
  ).animate(_curve);

  late Animation<double> _redProgress = Tween(
    begin: 0.005,
    end: _getRandomDouble(),
  ).animate(_defaultProgress);
  late Animation<double> _greenProgress = Tween(
    begin: 0.005,
    end: _getRandomDouble(),
  ).animate(_defaultProgress);
  late Animation<double> _blueProgress = Tween(
    begin: 0.005,
    end: _getRandomDouble(),
  ).animate(_defaultProgress);

  void _animateValues() {
    setState(() {
      _redProgress =
          _getAnimatedProgress(_redProgress.value, _getRandomDouble());
      _greenProgress =
          _getAnimatedProgress(_greenProgress.value, _getRandomDouble());
      _blueProgress =
          _getAnimatedProgress(_blueProgress.value, _getRandomDouble());
    });
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getRandomDouble() {
    return _random.nextDouble() * 2.0;
  }

  Animation<double> _getAnimatedProgress(double begin, double end) {
    return Tween(
      begin: begin,
      end: end,
    ).animate(_curve);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text('Apple Watch'),
        ),
        body: Center(
          child: AnimatedBuilder(
            animation: _defaultProgress,
            builder: (context, child) {
              return CustomPaint(
                painter: AppleWatchPainter(
                  redProgress: _redProgress.value,
                  greenProgress: _greenProgress.value,
                  blueProgress: _blueProgress.value,
                ),
                size: const Size(400, 400),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _animateValues,
          child: const Icon(Icons.refresh),
        ));
  }
}

class AppleWatchPainter extends CustomPainter {
  final double redProgress;
  final double blueProgress;
  final double greenProgress;

  AppleWatchPainter({
    required this.redProgress,
    required this.blueProgress,
    required this.greenProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startingAngle = -0.5 * pi;

    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final redCircleRadius = (size.width / 2) * 0.9;

    canvas.drawCircle(
      center,
      redCircleRadius,
      redCirclePaint,
    );
    final greenCirclePaint = Paint()
      ..color = Colors.green.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final greenCircleRadius = (size.width / 2) * 0.76;

    canvas.drawCircle(
      center,
      greenCircleRadius,
      greenCirclePaint,
    );
    final blueCirclePaint = Paint()
      ..color = Colors.cyan.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final blueCircleRadius = (size.width / 2) * 0.62;

    canvas.drawCircle(
      center,
      blueCircleRadius,
      blueCirclePaint,
    );

    //section red arc
    final redArcRect = Rect.fromCircle(
      center: center,
      radius: redCircleRadius,
    );

    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      redProgress * pi,
      false,
      redArcPaint,
    );

    //section green arc
    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: greenCircleRadius,
    );

    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      greenProgress * pi,
      false,
      greenArcPaint,
    );

    //section blue arc
    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: blueCircleRadius,
    );

    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      blueProgress * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.redProgress != redProgress ||
        oldDelegate.greenProgress != greenProgress ||
        oldDelegate.blueProgress != blueProgress;
  }
}
