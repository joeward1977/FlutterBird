import 'dart:math';
import 'dart:ui';

import 'package:flutters/components/core/gameobject.dart';
import 'package:flutters/flutters-game.dart';

class Obstacle extends GameObject {
  final Random rng = new Random();

  Rect rect;
  Paint paint;

  double x;
  double y;
  double width;
  double height;

  bool isMoving;
  int direction;
  double movementSpeed;

  // Create obstacle
  Obstacle(
      FluttersGame game, this.x, this.y, this.width, this.height, this.isMoving)
      : super(game) {
    movementSpeed = game.viewport.width / 8;
    direction = rng.nextBool() == true ? 1 : -1;
    paint = Paint();
    paint.color = Color(0x5f000055);
  }

  // Draw initial object
  @override
  void render(Canvas c) {
    rect = Rect.fromLTWH(x, y, width, height);
    c.drawRect(rect, paint);
  }

  // Method to update aspect of object (in this case location)
  @override
  void update(double t) {
    if (isMoving) {
      hitWall();
      x += direction * movementSpeed * t;
    }
  }

  // Check if moving object hit side wall and switch direction
  void hitWall() {
    if (x >= game.viewport.width - width) {
      direction = -1;
    } else if (x <= 0) {
      direction = 1;
    }
  }

  // Change color of object when it gets hit
  void markHit() {
    paint.color = Color(0xffEF5753);
  }

  Rect toRect() {
    return Rect.fromLTWH(x, y, width, height);
  }
}
