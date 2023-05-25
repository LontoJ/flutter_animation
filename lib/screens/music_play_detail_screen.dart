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
  );

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  final Curve _menuCurve = Curves.easeInOutCubic;

  late final Animation<double> _screenScale = Tween<double>(
    begin: 1.0,
    end: 0.7,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.0,
        0.3,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<Offset> _screenOffset = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.5, 0.0),
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.2,
        0.4,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<double> _closeButtonOpacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.3,
        0.5,
        curve: _menuCurve,
      ),
    ),
  );

  late final List<Animation<Offset>> _menuAnimations = [

    for (int i = 0; i < _menus.length; i++)

      Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _menuController,
          curve: Interval(
            0.4 + (0.1 * i),
            0.7 + (0.1 * i),
            curve: _menuCurve,
          ),
        ),
      ),
  ];


  late final Animation<Offset> _logOutSlide = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.8,
        1.0,
        curve: _menuCurve,
      ),
    ),
  );

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  late final Tween<double> _timeTween = Tween<double>(
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

  late final size = MediaQuery
      .of(context)
      .size;

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;
    _volume.value = _volume.value.clamp(0.0, size.width - 80);
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      "icon": Icons.person,
      "text": "Profile",
    },
    {
      "icon": Icons.notifications,
      "text": "Notifications",
    },
    {
      "icon": Icons.settings,
      "text": "Settings",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            leading: FadeTransition(
              opacity: _closeButtonOpacity,
              child: IconButton(
                onPressed: _closeMenu,
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                for (var menu in _menus
                    .asMap()
                    .entries) ...[
                  SlideTransition(
                    position: _menuAnimations[menu.key],
                    child: Row(
                      children: [
                        Icon(
                          menu.value["icon"],
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          menu.value["text"],
                          style: TextStyle(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
                const Spacer(),
                SlideTransition(
                  position: _logOutSlide,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
        SlideTransition(
          position: _screenOffset,
          child: ScaleTransition(
            scale: _screenScale,
            child: Scaffold(
              appBar: AppBar(
                title: Text('${widget.index}번 곡 이름'),
                actions: [
                  IconButton(
                    onPressed: _openMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ],
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
                            image: AssetImage(
                                'assets/covers/${widget.index}.jpeg'),
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
                      final currentTime = _timeTween
                          .transform(_progressController.value)
                          .floor();

                      final remainingTime = _timeTween
                          .transform(1 - _progressController.value)
                          .ceil();

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
                                      .floor())}:${_intToString(
                                      currentTime % 60)}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${_intToString((remainingTime / 60)
                                      .floor())}:${_intToString(
                                      remainingTime % 60)}",
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
                                child: ValueListenableBuilder(
                                  valueListenable: _volume,
                                  builder: (BuildContext context, double value,
                                      Widget? child) {
                                    return CustomPaint(
                                      size: Size(size.width - 80, 50),
                                      painter: VolumePainter(
                                        volume: value,
                                      ),
                                    );
                                  },
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
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
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
            ),
          ),
        ),
      ],
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
  final double volume;

  VolumePainter({required this.volume});

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
      volume,
      size.height,
    );

    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePainter oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
