import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutters/components/background.dart';
import 'package:flutters/components/bird.dart';
import 'package:flutters/components/dialogBox.dart';
import 'package:flutters/components/floor.dart';
import 'package:flutters/components/level.dart';
import 'package:flutters/components/obstacle.dart';
import 'package:flutters/components/text.dart';
import 'package:url_launcher/url_launcher.dart';

enum GameState {
  playing,
  gameOver,
  levelUp,
}

class FluttersGame extends Game {
  // Class variables
  GameState currentGameState = GameState.playing;
  Size viewport;
  Background skyBackground;
  Floor groundFloor;
  Level currentLevel;
  Bird birdPlayer;
  TextComponent scoreText;
  TextComponent floorText;
  TextComponent levelText;
  DialogBox gameOverDialog;
  DialogBox levelUpDialog;

  double birdSize;

  double birdPosY;
  double birdPosYOffset = 8;

  bool isFluttering = false;
  double flutterValue = 0;
  double flutterIntensity = 20;
  double floorHeight = 250;

  // Game Score Variables
  double currentHeight = 0;
  double score = 0;
  double levelScoreBonus = 0;
  int level = 0;
  double levelUpHeight = 5000;

  // Constructor for game
  FluttersGame(screenDimensions) {
    resize(screenDimensions);
    skyBackground = Background(this, 0, 0, viewport.width, viewport.height);
    groundFloor = Floor(this, 0, viewport.height - floorHeight, viewport.width, floorHeight, 0xff48BB78);
    currentLevel = Level(this);
    birdPlayer = Bird(this, 0, birdPosY, birdSize, birdSize);

    // Initial Text
    levelText = TextComponent(this, 'Level: 0', 30.0, 20);
    scoreText = TextComponent(this, '0', 30.0, 60);
    floorText = TextComponent(this, 'Tap to flutter!', 40.0, viewport.height - floorHeight / 2);
    gameOverDialog = DialogBox(this, 0);
    levelUpDialog = DialogBox(this, 1);
  }

  // Set size based on size of screen the game is played
  void resize(Size size) {
    viewport = size;
    birdSize = viewport.width / 10;
    birdPosY = viewport.height - floorHeight - birdSize + (birdSize / 8);
  }

  // This method "draws" or "paints" objects to the screen
  void render(Canvas c) {
    skyBackground.render(c);
    c.save();
    c.translate(0, currentHeight);
    currentLevel.levelObstacles.forEach((obstacle) {
      if (isObstacleInRange(obstacle)) {
        obstacle.render(c);
      }
    });
    groundFloor.render(c);
    floorText.render(c);
    c.restore();

    birdPlayer.render(c);

    if (currentGameState == GameState.gameOver) {
      gameOverDialog.render(c);
    } else if (currentGameState == GameState.levelUp) {
      levelUpDialog.render(c);
    } else {
      scoreText.render(c);
      levelText.render(c);
    }
  }

  // This method is called automatically to update the game
  void update(double t) {
    if (currentGameState == GameState.playing) {
      currentLevel.levelObstacles.forEach((obstacle) {
        if (isObstacleInRange(obstacle)) {
          obstacle.update(t);
        }
      });
      skyBackground.update(t);
      birdPlayer.update(t);
      // Update scoreText
      score = levelScoreBonus + currentHeight;
      scoreText.setText((score).floor().toString());
      scoreText.update(t);
      levelText.setText('Level : ' + (level + 1).floor().toString());
      levelText.update(t);
      floorText.update(t);
      gameOverDialog.update(t);
      levelUpDialog.update(t);
      // Game tasks
      flutterHandler();
      checkCollision();
      checkLevelUp();
    }
  }

  // Check if bird hits object, if it does end game
  void checkCollision() {
    currentLevel.levelObstacles.forEach((obstacle) {
      if (isObstacleInRange(obstacle)) {
        if (birdPlayer.toCollisionRect().overlaps(obstacle.toRect())) {
          obstacle.markHit();
          gameOver();
        }
      }
    });
  }

  // Check if bird reaches level up height, if it does start next level
  void checkLevelUp() {
    if (currentHeight > levelUpHeight) {
      currentGameState = GameState.levelUp;
    }
  }

  // Change state of game to gameOver
  void gameOver() {
    currentGameState = GameState.gameOver;
  }

  // Restart the game and set variables back to initial state
  void restartGame() {
    birdPlayer.setRotation(0);
    currentHeight = 0;
    score = 0;
    level = 0;
    levelScoreBonus = 0;
    currentLevel.generateObstacles(level);
    currentGameState = GameState.playing;
  }

  // Level Up the game and set variables back to initial state
  void levelUp() {
    birdPlayer.setRotation(0);
    currentHeight = 0;
    levelScoreBonus += levelUpHeight;
    level += 1;
    currentLevel.generateObstacles(level);
    currentGameState = GameState.playing;
  }

  // Check if obstacles are close enouh to bird to know whether to do the
  // following: Render, Update, and Check for Collision
  bool isObstacleInRange(Obstacle obs) {
    if (-obs.y < viewport.height + currentHeight && -obs.y > currentHeight - viewport.height) {
      return true;
    } else {
      return false;
    }
  }

  // What to do as the bird is flying
  void flutterHandler() {
    if (isFluttering) {
      flutterValue = flutterValue * 0.8;
      currentHeight += flutterValue;
      birdPlayer.setRotation(-flutterValue * birdPlayer.direction * 1.5);
      // Cut the jump below 1 unit
      if (flutterValue < 1) isFluttering = false;
    } else {
      // If max. fallspeed not yet reached
      if (flutterValue < 15) {
        flutterValue = flutterValue * 1.2;
      }
      if (currentHeight > flutterValue) {
        birdPlayer.setRotation(flutterValue * birdPlayer.direction * 2);
        currentHeight -= flutterValue;
        // stop jumping below floor
      } else if (currentHeight > 0) {
        currentHeight = 0;
        birdPlayer.setRotation(0);
      }
    }
  }

  // What to do when the screen is being pressed
  void onTapDown(TapDownDetails d) {
    if (currentGameState == GameState.playing) {
      // Make the bird flutter
      birdPlayer.startFlutter();
      isFluttering = true;
      flutterValue = flutterIntensity;
      return;
    } else if (currentGameState == GameState.levelUp) {
      if (levelUpDialog.button.contains(d.globalPosition)) {
        levelUp();
      }
    } else {
      if (gameOverDialog.button.contains(d.globalPosition)) {
        restartGame();
      }
      if (gameOverDialog.infoText.toRect().contains(d.globalPosition)) {
        _launchURL();
      }
    }
  }

  // What to do when the screen is released
  void onTapUp(TapUpDetails d) {
    birdPlayer.endFlutter();
  }

  _launchURL() async {
    const url = 'https://github.com/impulse';
    await launch(url);
  }
}
