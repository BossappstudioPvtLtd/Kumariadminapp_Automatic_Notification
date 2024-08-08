import 'dart:math';
import 'package:flutter/material.dart';


class SpinnerAnimated extends StatefulWidget {
  const SpinnerAnimated({Key? key}) : super(key: key);

  @override
  State<SpinnerAnimated> createState() => _SpinnerAnimatedState();
}

class _SpinnerAnimatedState extends State<SpinnerAnimated> with TickerProviderStateMixin {

  late AnimationController firstAnimationController;
  late Animation<double> firstAnimation;

  late AnimationController secondAnimationController;
  late Animation<double> secondAnimation;

  late AnimationController thirdAnimationController;
  late Animation<double> thirdAnimation;

  late AnimationController fourAnimationController;
  late Animation<double> fourAnimation;

  late AnimationController fiveAnimationController;
  late Animation<double> fiveAnimation;

  @override
  void initState() {
    firstAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 6));
    firstAnimation = Tween<double>(begin: -pi, end: pi).animate(firstAnimationController)
    ..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          firstAnimationController.repeat();
        }else if(status == AnimationStatus.dismissed){
          firstAnimationController.forward();
        }
    });

    secondAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    secondAnimation = Tween<double>(begin: -pi, end: pi).animate(secondAnimationController)
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          secondAnimationController.repeat();
        }else if(status == AnimationStatus.dismissed){
          secondAnimationController.forward();
        }
      });

    thirdAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    thirdAnimation = Tween<double>(begin: -pi, end: pi).animate(thirdAnimationController)
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          thirdAnimationController.repeat();
        }else if(status == AnimationStatus.dismissed){
          thirdAnimationController.forward();
        }
      });

    fourAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    fourAnimation = Tween<double>(begin: -pi, end: pi).animate(fourAnimationController)
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          fourAnimationController.repeat();
        }else if(status == AnimationStatus.dismissed){
          fourAnimationController.forward();
        }
      });

    fiveAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    fiveAnimation = Tween<double>(begin: -pi, end: pi).animate(fiveAnimationController)
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          fiveAnimationController.repeat();
        }else if(status == AnimationStatus.dismissed){
          fiveAnimationController.forward();
        }
      });

    super.initState();

    firstAnimationController.forward();
    secondAnimationController.forward();
    thirdAnimationController.forward();
    fourAnimationController.forward();
    fiveAnimationController.forward();
  }

  @override
  void dispose() {
    firstAnimationController.dispose();
    secondAnimationController.dispose();
    thirdAnimationController.dispose();
    fourAnimationController.dispose();
    fiveAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: SizedBox(
              width:350,height: 350,
              child: CustomPaint(
                painter: MyPainter1(
                  firstAnimationController.value * 6,
                  secondAnimationController.value * 6,
                  thirdAnimationController.value * 6,
                  fourAnimationController.value * 6,
                  fiveAnimationController.value * 6
                ),
              )
            ),
          ),

         
        ],
      
    );
  }
}

class MyPainter1 extends CustomPainter{
  final double? firstAngle;
  final double? secondAngle;
  final double? thirdAngle;
  final double? fourAngle;
  final double? fiveAngle;

  MyPainter1(this.firstAngle,this.secondAngle,this.thirdAngle,this.fourAngle,this.fiveAngle);

  @override
  void paint(Canvas canvas, Size size) {
    Paint myArc = Paint()
    ..color = Colors.amber.shade400
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15
    ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromLTRB(0, 0, size.width, size.height), firstAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .1, size.height * .1, size.width * .9, size.height * .9), secondAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .2, size.height * .2, size.width * .8, size.height * .8), thirdAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .3, size.height * .3, size.width * .7, size.height * .7), fourAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .4, size.height * .4, size.width * .6, size.height * .6), fiveAngle!, 2, false, myArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class MyPainter2 extends CustomPainter{
  final double? firstAngle;
  final double? secondAngle;
  final double? thirdAngle;
  final double? fourAngle;
  final double? fiveAngle;

  MyPainter2(this.firstAngle,this.secondAngle,this.thirdAngle,this.fourAngle,this.fiveAngle);

  @override
  void paint(Canvas canvas, Size size) {
    Paint myArc = Paint()
    ..color = Colors.blueAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromLTRB(0, 0, size.width, size.height), firstAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .1, size.height * .1, size.width * .9, size.height * .9), secondAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .2, size.height * .2, size.width * .8, size.height * .8), thirdAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .3, size.height * .3, size.width * .7, size.height * .7), fourAngle!, 2, false, myArc);
    canvas.drawArc(Rect.fromLTRB(size.width * .4, size.height * .4, size.width * .6, size.height * .6), fiveAngle!, 2, false, myArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}