import 'package:flutter/material.dart';

Widget gameStartChild(String a) {
  return Container(
    width: 320,
    height: 320,
    padding: const EdgeInsets.all(32),
    child: Center(
      child: Text(
        a,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

final Widget gameRunningChild = Container(
  width: 16,
  height: 16,
  decoration: new BoxDecoration(
    color: Colors.green[900],
    shape: BoxShape.rectangle,
    border: new Border.all(color: Colors.black, width: 2.0),
  ),
);

final Widget newSnakePointInGame = Container(
  width: 16,
  height: 16,
  decoration: new BoxDecoration(
    color: Colors.red[900],
    border: new Border.all(color: Colors.black, width: 2.0),
  ),
);

//class which gives the snake HEAD
class Point {
  double x;
  double y;

  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }
}
