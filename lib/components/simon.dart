import 'package:flutter/material.dart';
import 'simonDecoration.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:simon/utilities/button.dart';
import 'dart:math' as Math;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

/* 
 ! SIMON SEQUENCE RULES, BUT IT CAN BE CHANGED IF YOU WISH
 * GREEN is defined as 1
 * RED is defined as 2
 * YELLOW is defined as 3
 * BLUE is defined as 4
*/

class Simon extends StatefulWidget {
  @override
  _SimonState createState() => _SimonState();
}

class _SimonState extends State<Simon> {
  static AudioCache player = AudioCache();

  int _levelNumber = 0;
  double _greenOpacity = 1.0;
  double _redOpacity = 1.0;
  double _yellowOpacity = 1.0;
  double _blueOpacity = 1.0;
  bool _result = false;

  String _gameLabel = '';
  List<int> _simonSequence = [];
  List<int> _userSequence = [];
  Widget _button;

  @override
  void initState() {
    super.initState();
    player.loadAll(
        ['blue.mp3', 'yellow.mp3', 'green.mp3', 'red.mp3', 'wrong.mp3']);
    getStartStopButton();
  }

  @override
  void dispose() {
    super.dispose();
    player.clearCache();
  }

  void getStartStopButton() {
    if (_levelNumber == 0) {
      _button = Button(
          buttonLabel: 'Start Game',
          onPressed: () {
            setState(() {
              _result = true;
              _levelNumber += 1;
              _gameLabel = 'Level $_levelNumber';
              _userSequence.clear();
              _simonSequence.add(Math.Random().nextInt(4) + 1);
              playSequence(_simonSequence);
              getStartStopButton();
            });
          }).getButton();
    } else if (_levelNumber > 0) {
      _button = Button(
          buttonLabel: 'Stop Game',
          onPressed: () {
            setState(() {
              stopSequence();
              _result = false;
              _levelNumber = 0;
              _gameLabel = '';
              _simonSequence.clear();
              _userSequence.clear();
              getStartStopButton();
            });
          }).getButton();
    }
  }

  void changeOpacity(String simonColor) {
    switch (simonColor) {
      case 'green':
        setState(() {
          _greenOpacity = _greenOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            _greenOpacity = _greenOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case 'red':
        setState(() {
          _redOpacity = _redOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            _redOpacity = _redOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case 'yellow':
        setState(() {
          _yellowOpacity = _yellowOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            _yellowOpacity = _yellowOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case 'blue':
        setState(() {
          _blueOpacity = _blueOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            _blueOpacity = _blueOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
    }
  }

  void playSequence(List<int> sequence) {
    for (var i = 0; i < sequence.length; i++) {
      switch (sequence[i]) {
        case 1:
          Future.delayed(Duration(milliseconds: i * 500), () {
            player.play('green.mp3');
            changeOpacity('green');
          });
          break;
        case 2:
          Future.delayed(Duration(milliseconds: i * 500), () {
            player.play('red.mp3');
            changeOpacity('red');
          });
          break;
        case 3:
          Future.delayed(Duration(milliseconds: i * 500), () {
            player.play('yellow.mp3');
            changeOpacity('yellow');
          });
          break;
        case 4:
          Future.delayed(Duration(milliseconds: i * 500), () {
            player.play('blue.mp3');
            changeOpacity('blue');
          });
          break;
      }
    }
  }

  /**
  * TODO: stopSequence method will be implemented.
  */
  void stopSequence() {}

  void nextSequence() {
    setState(() {
      _userSequence.clear();
      _result = true;
      _levelNumber++;
      _simonSequence.add(Math.Random().nextInt(4) + 1);
    });

    Future.delayed(Duration(seconds: 1), () {
      playSequence(_simonSequence);
    });
  }

  bool checkSeqeunce() {
    int count = 0;
    for (var sq in _simonSequence) {
      for (var i = count; i < _userSequence.length;) {
        if (sq != _userSequence[i]) {
          return false;
        } else {
          count++;
          break;
        }
      }
      continue;
    }
    return true;
  }

  void endGame() {
    setState(() {
      _result = false;
      _levelNumber = 0;
      _gameLabel = 'Game Over';
      _simonSequence.clear();
      _userSequence.clear();
      getStartStopButton();
    });
    player.play('wrong.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Simon Game'),
        ),
        body: Container(
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${_result ? (_levelNumber == 0 ? '' : 'Level $_levelNumber') : _gameLabel}',
                style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _greenOpacity,
                    child: SimonContainer(
                      colour: Colors.green,
                      onPressed: () {
                        changeOpacity('green');
                        _userSequence.add(1);
                        player.play('green.mp3');
                        if (_simonSequence.length == _userSequence.length) {
                          setState(() {
                            _result = checkSeqeunce();
                            if (_result) {
                              nextSequence();
                            } else {
                              endGame();
                            }
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _redOpacity,
                    child: SimonContainer(
                      colour: Colors.red,
                      onPressed: () {
                        changeOpacity('red');
                        _userSequence.add(2);
                        player.play('red.mp3');
                        if (_simonSequence.length == _userSequence.length) {
                          setState(() {
                            _result = checkSeqeunce();
                            if (_result) {
                              nextSequence();
                            } else {
                              endGame();
                            }
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _yellowOpacity,
                    child: SimonContainer(
                      colour: Colors.yellow,
                      onPressed: () {
                        changeOpacity('yellow');
                        _userSequence.add(3);
                        player.play('yellow.mp3');
                        if (_simonSequence.length == _userSequence.length) {
                          _result = checkSeqeunce();
                          if (_result) {
                            nextSequence();
                          } else {
                            endGame();
                          }
                        }
                      },
                    ).getDecoration(),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _blueOpacity,
                    child: SimonContainer(
                      colour: Colors.blue,
                      onPressed: () {
                        changeOpacity('blue');
                        _userSequence.add(4);
                        player.play('blue.mp3');
                        if (_simonSequence.length == _userSequence.length) {
                          setState(() {
                            _result = checkSeqeunce();
                            if (_result) {
                              nextSequence();
                            } else {
                              endGame();
                            }
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              _button,
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                child: Text(
                  '*Go to creator\'s page of this app\'s icon',
                  style: TextStyle(color: Colors.amber[900]),
                ),
                onTap: launcUrl,
              )
            ],
          ),
        ),
      ),
    );
  }

  /*
  * Go to creator's page of this app's icon
  */
  void launcUrl() async {
    const _url = 'https://www.flaticon.com/authors/creaticca-creative-agency';

    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}
