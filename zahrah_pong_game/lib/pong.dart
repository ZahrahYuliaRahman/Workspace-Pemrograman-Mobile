import 'dart:math';

import 'package:flutter/material.dart';

import 'ball.dart';
import 'bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double width = 0;
  double height = 0;
  late double posX;
  late double posY;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  late Animation<double> animation;
  late AnimationController controller;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;
  @override
  void initState() {
    super.initState();
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      setState(() {
        checkBorders();
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });

      checkBorders();
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batWidth = width / 5;
        batHeight = height / 20;

        return Stack(
          children: <Widget>[
            Positioned(top: 0, right: 24, child: Text('Score: $score')),

            Positioned(top: posY, left: posX, child: Ball()),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate:
                    (DragUpdateDetails update) => moveBat(update, context),
                child: Bat(batWidth, batHeight),
              ),
            ),
          ],
        );
      },
    );
  }

  void checkBorders() {
    if (width == 0 || height == 0) {
      return;
    }

    double diameter = 50;

    // batas kiri
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }

    // batas kanan
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }

    // batas bawah
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      //check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter / 2) &&
          posX <= (batPosition + batWidth - diameter / 2)) {
        vDir = Direction.up;
        randY = randomNumber();
        setState(() {
          score++;
          increment += 1.5;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }

    // batas atas
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randX = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update, BuildContext context) {
    batPosition += update.delta.dx;

    if (batPosition < 0) {
      batPosition = 0;
    } else if (batPosition > width - batWidth) {
      batPosition = width - batWidth;
    }

    setState(() {
      batPosition = batPosition;
    });
  }

  double randomNumber() {
    //this is a number between 0.5 and 1.5;
    var ran = Random();
    int myNum = ran.nextInt(100);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Would you like to play again?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0;
                });
                Navigator.of(context).pop();
                controller.repeat();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                dispose();
              },
            ),
          ],
        );
      },
    );
  }
}
