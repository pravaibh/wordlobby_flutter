import 'package:flutter/material.dart';

class FlippableCard extends StatefulWidget {
  Map<String, dynamic> wordMap;
  @override
  State<StatefulWidget> createState() => FlippableCardState(wordMap);
  FlippableCard(Map<String, dynamic> wm) {
    wordMap = wm;
  }
}

class FlippableCardState extends State<FlippableCard> with TickerProviderStateMixin {
  Map<String, dynamic> wordMap;
  FlippableCardState(Map<String, dynamic> wm) {
    wordMap = wm;
  }
  AnimationController _controller;
  Animation<double> _frontScale;
  Animation<double> _backScale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _frontScale = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    _backScale = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: <Widget>[
          AnimatedBuilder(
            child: GestureDetector(
              child: SizedBox(
                height: 500.0,
                width: 450.0,
                child:
                Card(
                  elevation: 30.0,
                  margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                          child: Text(
                            wordMap['word'],
                            textScaleFactor: 5.0,
                            style: TextStyle(
                                fontFamily: 'Cursive', color: Colors.green),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
                          child: Text(
                            wordMap['type'],
                            softWrap: true,
                            textAlign: TextAlign.center,
                            textScaleFactor: 0.9,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
                          child: Text(
                            wordMap['meaning'],
                            softWrap: true,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  if (_controller.isCompleted || _controller.velocity > 0)
                    _controller.reverse();
                  else
                    _controller.forward();
                });
              },
            ),
            animation: _frontScale,
            builder: (BuildContext context, Widget child) {
              final Matrix4 transform = new Matrix4.identity()
                ..scale(1.0, _frontScale.value, 1.0);
              return Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: child,
              );
            },
          ),
          AnimatedBuilder(
            child: GestureDetector(
              child: SizedBox(
                width: 450.0,
                height: 500.0,
                child: Card(
                    elevation: 30.0,
                    margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                            child: Text(
                              'Examples',
                              style: TextStyle(color: Colors.black45),
                              softWrap: true,
                              textAlign: TextAlign.left,
                              textScaleFactor: 2.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                            child: Text(
                              wordMap['examples'][0],
                              softWrap: true,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
                            child: Text(
                              wordMap['examples'][1],
                              softWrap: true,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.1,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              onTap: () {
                setState(() {
                  if (_controller.isCompleted || _controller.velocity > 0)
                    _controller.reverse();
                  else
                    _controller.forward();
                });
              },
            ),
            animation: _backScale,
            builder: (BuildContext context, Widget child) {
              final Matrix4 transform = new Matrix4.identity()
                ..scale(1.0, _backScale.value, 1.0);
              return new Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: child,
              );
            },
          )
        ],
    );
  }
}
