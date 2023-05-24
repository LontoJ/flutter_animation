import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({Key? key}) : super(key: key);

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: -(size.width + 100),
    upperBound: (size.width + 100),
    value: 0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final ColorTween _checkColor = ColorTween(
    begin: Colors.white,
    end: Colors.green,
  );
  late final ColorTween _cancelColor = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  );
  late final Tween<double> _buttonScale = Tween(
    begin: 1,
    end: 1.2,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  void _dropCard({required int dropDirection}) {
    _position
        .animateTo(
          (size.width + 100) * dropDirection,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .whenComplete(_whenComplete);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_position.value.abs() >= size.width * 0.6) {
      _dropCard(dropDirection: _position.value.isNegative ? -1 : 1);
    } else {
      _position.animateTo(
        0,
        curve: Curves.elasticOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final deviceWidth = size.width;
          final positionValueNormalized = _position.value / deviceWidth;
          final positionValueAbsNormalized =
              _position.value.abs() / deviceWidth;
          final angle = _rotation.transform(
                  (_position.value + deviceWidth / 2) / deviceWidth) *
              pi /
              180;
          final scale = _scale.transform(positionValueAbsNormalized);
          final cancelButtonScale =
              _buttonScale.transform(-(positionValueNormalized));
          final checkButtonScale =
              _buttonScale.transform(positionValueNormalized);
          final checkColor = _checkColor.transform(positionValueNormalized);
          final checkColorBackground =
              _checkColor.transform(1 - (positionValueNormalized));
          final cancelColor =
              _cancelColor.transform(-1 * (positionValueNormalized));
          final cancelColorBackground =
              _cancelColor.transform(1 + (positionValueNormalized));
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: Card(index: _index == 5 ? 1 : _index + 1),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Card(index: _index),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.65,
                child: Row(
                  children: [
                    Transform.scale(
                      scale: max(cancelButtonScale, 1.0),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: FloatingActionButton(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 5.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(70),
                            ),
                          ),
                          foregroundColor: cancelColorBackground,
                          backgroundColor: cancelColor,
                          onPressed: () {
                            _dropCard(dropDirection: -1);
                          },
                          child: const Icon(Icons.close, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 100),
                    Transform.scale(
                      scale: max(checkButtonScale, 1.0),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: FloatingActionButton(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 5.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(70),
                            ),
                          ),
                          foregroundColor: checkColorBackground,
                          backgroundColor: checkColor,
                          onPressed: () {
                            _dropCard(dropDirection: 1);
                          },
                          child: const Icon(
                            Icons.check,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Image.asset(
          "assets/covers/$index.jpeg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
