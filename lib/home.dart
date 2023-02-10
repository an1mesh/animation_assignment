import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //animation controller
  late final AnimationController controllerTransition1;
  late final AnimationController controllerTransition2;

  //shape defined
  final square = const PolygonShapeBorder(sides: 4);
  final circle = const PolygonShapeBorder(cornerRadius: Length(100));
  final hex = const PolygonShapeBorder(sides: 6);

  //color animation
  late final Animation blueToGreenAnimation;
  late final Animation greenToRedAnimation;

  //shape animation
  late final Animation squareToCircle;
  late final Animation circleToHex;

  //color tween defined
  final ColorTween blueToGreen =
      ColorTween(begin: Colors.blue, end: Colors.green);
  final ColorTween greenToRed =
      ColorTween(begin: Colors.green, end: Colors.red);

  late Animation animation;
  int status = 0;

  @override
  void initState() {
    super.initState();

    controllerTransition1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    controllerTransition2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    squareToCircle = MorphableShapeBorderTween(begin: square, end: circle)
        .animate(controllerTransition1);
    circleToHex = MorphableShapeBorderTween(begin: circle, end: hex)
        .animate(controllerTransition2);

    blueToGreenAnimation = blueToGreen.animate(controllerTransition1);
    greenToRedAnimation = greenToRed.animate(controllerTransition2);

    animation = squareToCircle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, shape) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: pi / 4,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: ShapeDecoration(
                      color: status == 0
                          ? blueToGreenAnimation.value
                          : greenToRedAnimation.value,
                      shape: status == 0
                          ? squareToCircle.value
                          : circleToHex.value,
                    ),
                    child: const Center(child: Text('Animation')),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (status == 0) {
                      await controllerTransition1.forward();
                      status = 1;
                      animation = controllerTransition2;
                    } else if (status == 1) {
                      await controllerTransition2.forward();
                      status = 2;
                      animation = controllerTransition1;
                    } else {
                      status = 0;
                      controllerTransition1.reset();
                      controllerTransition2.reset();
                    }
                    setState(() {});
                  },
                  child: const Text('Animate'),
                ),
                ElevatedButton(
                  onPressed: () {
                    status = 0;
                    controllerTransition1.reset();
                    controllerTransition2.reset();
                    setState(() {});
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
