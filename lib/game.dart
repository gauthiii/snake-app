import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'children_at_different_game_states.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

enum Direction { LEFT, RIGHT, UP, DOWN }
enum GameState { START, RUNNING, FAILURE }

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  var snakePosition;
  Point newPointPosition;
  Timer timer;
  Direction _direction = Direction.UP;
  var gameState = GameState.START;
  int score = 0;

  String length = "0";

  AudioCache audioCache;
  AudioPlayer advancedPlayer;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/counter.txt');
  }

  Future<File> get _localFile1 async {
    final path1 = await _localPath;
    print(path1);
    return File('$path1/counter1.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      print("recieved " + contents);

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<int> readCounter1() async {
    try {
      final file = await _localFile1;

      // Read the file
      String contents = await file.readAsString();

      print("recieved " + contents);

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    print("Writing $counter");
    // Write the file
    return file.writeAsString('$counter');
  }

  Future<File> writeCounter1(int counter) async {
    final file = await _localFile1;
    print("Writing $counter");
    // Write the file
    return file.writeAsString('$counter');
  }

  int ns;
  int ps;

  @override
  void initState() {
    super.initState();

    advancedPlayer = new AudioPlayer();

    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    readCounter().then((int value) {
      print(value);
      setState(() {
        ns = value;
      });
    });

    readCounter1().then((int value) {
      print(value);
      setState(() {
        ps = value;
      });
    });
  }

  bool nf = false;
  bool pf = false;
  bool gr = false;
  bool ss = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
                  if (pf == false && gr == false)
                    nf = true;
                  else if (pf == true && gr == false) {
                    nf = true;
                    pf = false;
                  }
                });
              },
              color: (nf == true) ? Colors.red : Colors.white,
              child: Text(
                "NOOB",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  if (nf == false && gr == false)
                    pf = true;
                  else if (nf == true && gr == false) {
                    pf = true;
                    nf = false;
                  }
                });
              },
              color: (pf == true) ? Colors.red : Colors.white,
              child: Text(
                "PRO",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  if (ss == true)
                    ss = false;
                  else
                    ss = true;
                });
              },
              elevation: 0.0,
              color: Colors.black,
              child: Icon(
                (ss == true) ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
              ),
            ),
          ],
        ),
        GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails direction) {
              if (direction.delta.dx < 0)
                setState(() {
                  _direction = Direction.LEFT;
                });
              if (direction.delta.dx > 0) {
                setState(() {
                  _direction = Direction.RIGHT;
                });
              }
            },
            onVerticalDragUpdate: (DragUpdateDetails direction) {
              if (direction.delta.dy > 0)
                setState(() {
                  _direction = Direction.DOWN;
                });
              if (direction.delta.dy < 0) {
                setState(() {
                  _direction = Direction.UP;
                });
              }
            },
            child: Container(
              width: 322,
              height: 322,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (tapUpDetails) {
                  _handleTap(tapUpDetails);
                },
                child: _getChildBasedOnGameState(),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 5.0, color: Colors.yellow),
                ),
                child: Text(
                  "NOOB\nHIGH SCORE\n$ns",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.yellow, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 5.0, color: Colors.white),
                ),
                child: Text(
                  "SCORE\n$score",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 5.0, color: Colors.yellow),
                ),
                child: Text(
                  "PRO\nHIGH SCORE\n$ps",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.yellow, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Text("Swipe (inside the walls) to move the snake")
      ],
    );
  }

  void _handleTap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case GameState.START:
        startToRunState();

        break;
      case GameState.RUNNING:
        break;
      case GameState.FAILURE:
        score = 0;
        startToRunState();
        break;
    }
  }

  void startToRunState() {
    startingSnake();
    generatenewPoint();
    _direction = Direction.UP;
    if (nf == true || pf == true) { 
      setGameState(GameState.RUNNING);
      timer = (nf==true)?Timer.periodic(new Duration(milliseconds: 200), onTimeTick):Timer.periodic(new Duration(milliseconds: 100), onTimeTick);
    } else
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                title: new Text("CHOOSE THE GAME MODE!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Bangers')),
                content: Text("Noob or Pro?\nTap the button above",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Bangers')),
              ));
  }

  void startingSnake() {
    setState(() {
      final midPoint = (320 / 20 / 2);
      snakePosition = [
        Point(midPoint, midPoint - 1),
        Point(midPoint, midPoint),
        Point(midPoint, midPoint + 1),
      ];
    });
  }

  void generatenewPoint() {
    setState(() {
      Random rng = Random();

      var min = 0;
      var max = 320 ~/ 20;
      var nextX = min + rng.nextInt(max - min);
      var nextY = min + rng.nextInt(max - min);

      var newRedPoint = Point(nextX.toDouble(), nextY.toDouble());

      if (snakePosition.contains(newRedPoint)) {
        generatenewPoint();
      } else {
        newPointPosition = newRedPoint;
      }
    });
  }

  void setGameState(GameState _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }

  Widget _getChildBasedOnGameState() {
    var child;
    switch (gameState) {
      case GameState.START:
        setState(() {
          gr = false;
          score = 0;
        });
        child =
            gameStartChild("Tap to start the Game!\nDo not touch the Walls");
        break;

      case GameState.RUNNING:
        setState(() {
          length = snakePosition.length.toString();

          gr = true;
          if (ss == true) audioCache.play("Game.mp3");
          if (ss == false) advancedPlayer.stop();
        });

        List<Positioned> snakePiecesWithNewPoints = List();

        snakePosition.forEach(
          (i) {
            snakePiecesWithNewPoints.add(
              Positioned(
                child: gameRunningChild,
                left: i.x * 16,
                top: i.y * 16,
              ),
            );
          },
        );
        final latestPoint = Positioned(
          child: newSnakePointInGame,
          left: newPointPosition.x * 16,
          top: newPointPosition.y * 16,
        );
        snakePiecesWithNewPoints.add(latestPoint);
        child = Stack(children: snakePiecesWithNewPoints);
        break;

      case GameState.FAILURE:
        setState(() {
          gr = false;
        });
        timer.cancel();
        advancedPlayer.stop();
        child = gameStartChild(
            "You have scored $score point${score == 1 ? '' : 's'}!!!\nTap to play again!\nDo not touch the Walls");
        break;
    }
    return child;
  }

  void onTimeTick(Timer timer) {
    setState(() {
      snakePosition.insert(0, getLatestSnake());
      snakePosition.removeLast();
    });

    var currentHeadPos = snakePosition.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 19 ||
        currentHeadPos.y > 19) {
      setGameState(GameState.FAILURE);
      return;
    }

    if (snakePosition.first.x == newPointPosition.x &&
        snakePosition.first.y == newPointPosition.y) {
      generatenewPoint();
      setState(() {
        score = score + 1;
        snakePosition.insert(0, getLatestSnake());
      });

      if (score > ns && nf == true) {
        writeCounter(score);
        readCounter().then((int value) {
          print(value);
          setState(() {
            ns = value;
          });
        });
      }
      if (score > ps && pf == true) {
        writeCounter1(score);
        readCounter1().then((int value) {
          print(value);
          setState(() {
            ps = value;
          });
        });
      }
    }
  }

  Point getLatestSnake() {
    var newHeadPos;

    switch (_direction) {
      case Direction.LEFT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.RIGHT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.UP:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.DOWN:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }
}

/*Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.UP;
                        });
                      },
                      color: Colors.white,
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _direction = Direction.LEFT;
                          });
                        },
                        color: Colors.white,
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              _direction = Direction.RIGHT;
                            });
                          },
                          color: Colors.white,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black, 
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.DOWN;
                        });
                      },
  */
