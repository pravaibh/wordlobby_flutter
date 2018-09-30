import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordlobby/util/flippable_card.dart';

List<Alignment> cardsAlign = [
  new Alignment(0.0, 1.0),
  new Alignment(0.0, 0.8),
  new Alignment(0.0, 0.0)
];
List<Size> cardsSize;
List<DocumentSnapshot> wordList;

class SwipableCard extends StatefulWidget {
  SwipableCard(BuildContext context, List<DocumentSnapshot> wl) {
    wordList = wl;
    cardsSize = new List(wl.length);
    for (int i = 0; i < wl.length; i++) {
      cardsSize[i] = new Size(
          MediaQuery.of(context).size.width * (0.9 - i * 0.05),
          MediaQuery.of(context).size.height * (0.6 - i * 0.05));
    }
  }

  @override
  _SwipableCardState createState() => new _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;

  List<FlippableCard> cards = new List();
  AnimationController _controller;

  final Alignment defaultFrontCardAlign = new Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    super.initState();

    // Init cards
    for (cardsCounter = 0; cardsCounter < wordList.length; cardsCounter++) {
      cards.add(new FlippableCard(wordList[cardsCounter].data));
    }

    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: new Stack(
      children: <Widget>[
        backCard(),
        middleCard(),
        frontCard(),

        // Prevent swiping if the cards are animating
        _controller.status != AnimationStatus.forward
            ? new SizedBox.expand(
                child: new GestureDetector(
                // While dragging the first card
                onPanUpdate: (DragUpdateDetails details) {
                  // Add what the user swiped in the last frame to the alignment of the card
                  setState(() {
                    // 20 is the "speed" at which moves the card
                    frontCardAlign = new Alignment(
                        frontCardAlign.x +
                            20 *
                                details.delta.dx /
                                MediaQuery.of(context).size.width,
                        frontCardAlign.y +
                            40 *
                                details.delta.dy /
                                MediaQuery.of(context).size.height);

                    frontCardRot = frontCardAlign.x; // * rotation speed;
                  });
                },
                // When releasing the first card
                onPanEnd: (_) {
                  // If the front card was swiped far enough to count as swiped
                  if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                    animateCards();
                  } else {
                    // Return to the initial rotation and alignment
                    setState(() {
                      frontCardAlign = defaultFrontCardAlign;
                      frontCardRot = 0.0;
                    });
                  }
                },
              ))
            : new Container(),
      ],
    ));
  }

  Widget backCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardAlignmentAnim(_controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: new Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: new SizedBox.fromSize(
              size: _controller.status == AnimationStatus.forward
                  ? CardsAnimation.frontCardSizeAnim(_controller).value
                  : cardsSize[0],
              child: cards[0]),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a new bottom card)
      var temp = cards[0];
      int i = 1;
      for (; i < wordList.length; i++) {
        cards[i - 1] = cards[i];
      }
      cards[i - 1] = temp;
//      cards[i-1] = new FlippableCard(wordList[cardsCounter - 1].data);
//      cardsCounter++;
      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Word History and more coming soon. Only one word a day for now',style: TextStyle(fontFamily: 'Cursive'), textScaleFactor: 1.2,)));
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return new AlignmentTween(
            begin: beginAlign,
            end: new Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> frontCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[0], end: cardsSize[2]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeOut)));
  }
}
