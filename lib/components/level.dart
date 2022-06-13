import 'dart:math';
import 'package:flutters/components/obstacle.dart';
import 'package:flutters/flutters-game.dart';

class Level {
  final FluttersGame game;
  List<Obstacle> levelObstacles;
  final Random rng = new Random();

  // Constructs level and generates obstacles for the first level
  Level(this.game) {
    generateObstacles(0);
  }

  // Method to generate obstacleds for a level
  void generateObstacles(int numLevel) {
    levelObstacles = [];

    Obstacle obstacle;
    double screenHeight = game.viewport.height;
    double screenWidth = game.viewport.width;
    double obstacleWidth;
    double obstacleHeight;
    double posX;
    double posY;

    // Loop to create all obstacles for the game
    for (int i = 0; i < 200; i++) {
      // Create variables to determine if it start left and is moving
      bool isLeft;
      bool isMoving = false;

      // Randomizes whether it is a moving obstacles or wall obstacles
      // Moving obstacles == 0, all others are wall obstacles
      int movingRng = rng.nextInt(2);

      // If it is a moving obstacles
      if (movingRng == 0) {
        // Set width and height of rectangle, set it left, and make it move
        obstacleWidth = screenWidth * 0.5;
        obstacleHeight = screenHeight / 50;
        isLeft = true;
        isMoving = true;
      }
      // If it is a wall obstacles
      else {
        obstacleWidth = screenWidth / 40;
        obstacleHeight = game.viewport.height / 10;
      }
      // Position Obstacles on left and right of screen
      var verticalSpacing = screenHeight / 3 - (numLevel * 10);
      posY = (-i * verticalSpacing);
      isLeft = rng.nextBool();
      if (isLeft) {
        posX = 0;
      } else {
        posX = screenWidth - obstacleWidth;
      }
      obstacle = Obstacle(game, posX, posY, obstacleWidth, obstacleHeight, isMoving);
      // Add obstacle to level
      levelObstacles.add(obstacle);
    }
  }
}
