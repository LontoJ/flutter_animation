import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({Key? key, required this.index})
      : super(key: key);

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  )
    ..repeat(reverse: true);

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )
    ..repeat(reverse: true);

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  late final Tween<double> _timeTween = Tween(
    begin: 0,
    end: 60,
  );

  String _intToString(int value) {
    return value.toString().padLeft(2, '0');
  }

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  final ValueNotifier<double> _volume = ValueNotifier<double>(0.0);

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.index}번 곡 이름'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: "${widget.index}",
              child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage('assets/covers/${widget.index}.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              final currentTime =
              _timeTween.transform(_progressController.value).floor();

              final remainingTime =
              _timeTween.transform(1 - _progressController.value).ceil();

              return Column(
                children: [
                  CustomPaint(
                    size: Size(size.width - 80, 5),
                    painter: ProgressBar(
                      progressValue: _progressController.value,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        Text(
                          "${_intToString((currentTime / 60)
                              .floor())}:${_intToString(currentTime % 60)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${_intToString((remainingTime / 60)
                              .floor())}:${_intToString(remainingTime % 60)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: _onPlayPauseTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          progress: _playPauseController,
                          size: 60,
                          color: Colors.black,
                        ),
                        // LottieBuilder.asset(
                        //   "assets/animations/play-lottie.json",
                        //   controller: _playPauseController,
                        //   width: 200,
                        //   height: 200,
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onHorizontalDragStart: (_) => _toggleDragging(),
                    onHorizontalDragEnd: (_) => _toggleDragging(),
                    onHorizontalDragUpdate: _onVolumeDragUpdate,
                    child: AnimatedScale(
                      scale: _dragging ? 1.1 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.bounceOut,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomPaint(
                          size: Size(size.width - 80, 50),
                          painter: VolumePainter(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${widget.index}번 곡 이름',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          SlideTransition(
            position: _marqueeTween,
            child: const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec eget felis ut nisl ultricies aliquet.',
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    required this.progressValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    //section track
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    //section progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );
    canvas.drawRRect(progressRRect, progressPaint);

    //thumb
    canvas.drawCircle(
      Offset(progress, size.height / 2),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.grey.shade300;

    final bgRRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.drawRect(bgRRect, bgPaint);

    final volumePaint = Paint()
      ..color = Colors.grey.shade500;

    final volumeRect = Rect.fromLTWH(
      0,
      0,
      size.width / 2,
      size.height,
    );

    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePainter oldDelegate) {
    return false;
  }
}
