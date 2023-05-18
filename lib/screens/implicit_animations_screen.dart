import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({Key? key}) : super(key: key);

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations'),
      ),
      body: Center(
        child: Column(
          children: [
            TweenAnimationBuilder(
              tween: ColorTween(
                begin: Colors.purple,
                end: Colors.red,
              ),
              curve: Curves.bounceInOut,
              duration: const Duration(seconds: 5),
              builder: (context, value, child) {
                return Image.network(
                  "https://alsnewstoday.com/wp-content/uploads/2022/03/DNAStrand_MDA-1.png",
                  color: value,
                  colorBlendMode: BlendMode.colorBurn,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
