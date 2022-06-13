import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutters/components/cloud.dart';
import 'package:flutters/components/core/gameobject.dart';
import 'package:flutters/flutters-game.dart';

class Background extends GameObject {
  // Code to create gradient for painting background
  final Gradient gradient = new LinearGradient(
    begin: Alignment.topCenter,
    colors: <Color>[
      Color(0xff0165b1),
      Color(0xffFFFFFF),
    ],
    stops: [
      0.0,
      1.0,
    ],
    end: Alignment(0, 0.9),
  );

  Rect rect;
  Paint paint;

  Background(FluttersGame game, double x, double y, double width, double height)
      : super(game) {
    // Create gradient blue sky background (rectangle)
    rect = Rect.fromLTWH(x, y, width, height);
    paint = new Paint()..shader = gradient.createShader(rect);

    // Add clouds to backgournd and pass in their vertical position
    this.addChild(new Cloud(this.game, game.birdSize * 1.7));
    this.addChild(new Cloud(this.game, game.birdSize * 4.4));
  }

  @override
  void render(Canvas c) {
    c.drawRect(rect, paint);
    super.render(c);
  }

  @override
  void update(double t) {
    super.update(t);
  }
}
