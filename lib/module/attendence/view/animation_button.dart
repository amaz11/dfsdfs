import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/module/attendence/controller/animation_button_contrroller.dart';
import 'dart:math' as m;

class AnimationButton extends StatelessWidget {
  final VoidCallback? onComplete;
  AnimationButton({super.key, this.onComplete});

  final AnimatedButtonController animationController =
      Get.find<AnimatedButtonController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnimatedButtonController>(
      init: AnimatedButtonController(),
      builder: (controller) {
        return AspectRatio(
          aspectRatio: 2.4,
          child: ClipRRect(
            child: GestureDetector(
              onLongPressStart: (details) {
                controller.startAnimation();
              },
              onLongPressEnd: (details) {
                controller.resetAnimation();
              },
              child: AnimatedBuilder(
                animation: controller.controller,
                builder: (context, snapshot) {
                  return CustomPaint(
                    painter: ArcShapePainter(
                      progress: controller.animation.value,
                      radius: MediaQuery.of(context).size.width,
                      color: controller.todayCheckInOutColor.value,
                      strokeWidth: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        controller.todayCheckInOutComplete.value
                            ? const SizedBox.shrink()
                            : const Icon(
                                Icons.fingerprint_outlined,
                                size: 40,
                                color: whiteColor,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            controller.todayCheckInOutText.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

//Arc shape painter
class ArcShapePainter extends CustomPainter {
  //Define constructor parameters
  late double progress;
  late double radius;
  late Color color;
  late double strokeWidth;

  //Define private variables
  late Paint _linePaint;
  late Paint _solidPaint;
  late Path _path;

  //Create constructor and initialize private variables
  ArcShapePainter(
      {required this.color,
      this.progress = .5,
      this.radius = 400,
      this.strokeWidth = 4}) {
    _linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    _solidPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //First define the cord length and bound the angle
    var cordLength = size.width + 4;
    if (radius <= (cordLength * .5) + 16) radius = (cordLength * .5) + 16;
    if (radius >= 600) radius = 600;

    //Define required angles
    var arcAngle = m.asin((cordLength * .5) / radius) * 2;
    var startAngle = (m.pi + m.pi * .5) - (arcAngle * .5);
    var progressAngle = arcAngle * progress;

    //Define center of the available screen
    Offset center = Offset((cordLength * .5) - 2, radius + 8);

    //Draw the line arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        progressAngle, false, _linePaint);

    //Draw the solid arc path
    _path = Path();
    _path.arcTo(Rect.fromCircle(center: center, radius: radius), startAngle,
        arcAngle, true);
    _path.lineTo(size.width, size.height);
    _path.lineTo(0, size.height);
    _path.close();

    //Draw some shadow over the solid arc
    canvas.drawShadow(
        _path.shift(const Offset(0, 1)), color.withAlpha(40), 3, true);

    //Draw the solid arc using path
    canvas.drawPath(_path.shift(const Offset(0, 12)), _solidPaint);
  }

  @override
  bool hitTest(Offset position) {
    //Accept long pressing only for the solid arc
    return _path.contains(position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Make it conditionally return for release build
    // For now I am making always true
    return true;
  }
}
