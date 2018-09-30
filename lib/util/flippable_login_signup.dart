import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

class LoginSignupFlippableCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginSignupFlippableCardState();
}

class LoginSignupFlippableCardState extends State<LoginSignupFlippableCard>
    with TickerProviderStateMixin {
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

  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          child: Form(
            key: _signUpFormKey,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.black12,
              elevation: 150.0,
              child: Form(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white70),
                        validator: (value) {
                          assert(value != null && value.isNotEmpty);

                        },
                        decoration: InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Colors.amber)
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          assert(value != null &&
                              value.isNotEmpty &&
                              value.endsWith('.com'));
                        },
                        decoration: InputDecoration(
                            hintText: 'E-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          assert(value != null &&
                              value.isNotEmpty &&
                              value.length > 6);
                        },
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.white,
                            onPressed: () {
                              if (_signUpFormKey.currentState.validate()) {
                                signUpWithEmail();
                              }
                            },
                            child: Text(
                              'Sign up',
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Text(
                            'Existing User?',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              if (_controller.isCompleted ||
                                  _controller.velocity > 0)
                                _controller.reverse();
                              else
                                _controller.forward();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          child: Form(
            key: _signInFormKey,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.black12,
              elevation: 150.0,
              child: Form(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          assert(value != null &&
                              value.isNotEmpty &&
                              value.endsWith('.com'));
                        },
                        decoration: InputDecoration(
                            hintText: 'E-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          assert(value != null &&
                              value.isNotEmpty &&
                              value.length > 6);
                        },
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      GestureDetector(
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => FirebaseAuth.instance
                            .sendPasswordResetEmail(
                                email: _emailController.text)
                            .then((val) =>
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Password reset email sent. Please reset password and retry.'),
                                )))
                            .catchError((err) =>
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Failed to send password reset email with the error: ' +
                                          err),
                                ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.white,
                            onPressed: () {
                              if (_signInFormKey.currentState.validate()) {
                                loginWithEmail();
                              }
                            },
                            child: Text(
                              'Sign In',
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Text(
                            'New User?',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              if (_controller.isCompleted ||
                                  _controller.velocity > 0)
                                _controller.reverse();
                              else
                                _controller.forward();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
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

  signUpWithEmail() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((onValue) {
      onValue
          .sendEmailVerification()
          .then((onValue) => Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Signup successful. Please verify your email to continue.'))))
          .catchError(() => Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Sign up failed.'))));
    }).catchError((onError) => Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Sign up failed with the error: ' + onError),
            )));
  }

  loginWithEmail() async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((onValue) {
      if (onValue.isEmailVerified) {
        _firebaseMessaging.subscribeToTopic('word_of_day');
        Navigator.pushNamed(
          context,
          '/splash',
        );
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Please verify your email first')));
      }
    }).catchError((error) => Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString()))));
  }
}
