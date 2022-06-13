import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutters/components/core/gameobject.dart';
import 'package:flutters/components/text.dart';
import 'package:flutters/flutters-game.dart';

class DialogBox extends GameObject {
  final FluttersGame game;
  Paint paint;
  Rect wrapper;
  RRect wrapperBox;

  Rect button;
  RRect buttonBox;

  TextComponent buttonText;
  String buttonString;
  TextComponent titleText;
  String titleString;
  TextComponent infoText;
  String infoString;
  TextComponent scoreText;

  double size;

  DialogBox(this.game, int type) : super(game) {
    if (type == 0) {
      size = 0.9;
      titleString = 'Game Over!';
      buttonString = 'Play again';
      infoString = 'Modded for LFA STEAM Camp';
    } else {
      size = 0.75;
      titleString = 'Level Up!';
      buttonString = 'Continue?';
      infoString = 'Great Job';
    }

    // Set variable values
    double screenWidth = game.viewport.width;
    double screenHeight = game.viewport.height;

    double boxPadding = 1 - size;

    // Create background box
    double rectLeft = screenWidth * boxPadding;
    double rectWidth = screenWidth * (1 - boxPadding * 2);
    double rectTop = (screenHeight - rectWidth) / 2;
    double rectHeight = rectWidth;
    wrapper = Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight);
    wrapperBox = RRect.fromRectAndRadius(wrapper, Radius.circular(4));

    // Make Button
    double buttonWidth = rectWidth * 0.8;
    double buttonHeight = buttonWidth / 3;
    button = Rect.fromLTWH((screenWidth - buttonWidth) / 2, wrapper.center.dy,
        buttonWidth, buttonHeight);
    buttonBox = RRect.fromRectAndRadius(button, Radius.circular(4));

    paint = Paint();

    // Add Text
    double textSize = rectHeight / 8 * size;

    titleText = TextComponent(
        game, titleString, textSize, rectTop + (textSize * 2), 0xff3D4852);
    scoreText = TextComponent(
        game, '', textSize * 0.8, button.top - (textSize * 2) / 2, 0xff606F7B);
    buttonText = TextComponent(
        game, buttonString, textSize * 0.7, button.center.dy, 0xfffafafa);
    infoText = TextComponent(game, infoString, 20.0 * size,
        button.bottom + (textSize * 2) / 2, 0xff6CB2EB);

    children.add(titleText);
    children.add(scoreText);
    children.add(buttonText);
    children.add(infoText);
  }

  @override
  void render(Canvas c) {
    paint.color = Color(0xd9EDF2F7);
    c.drawRRect(wrapperBox, paint);
    paint.color = Color(0xffEF5753);
    c.drawRRect(buttonBox, paint);
    super.render(c);
  }

  @override
  void update(double t) {
    scoreText.setText('Score: ${game.score.floor().toString()}');
    super.update(t);
  }
}
