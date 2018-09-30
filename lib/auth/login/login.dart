import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wordlobby/util/flippable_login_signup.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        Navigator.pushNamed(
          context,
          '/splash',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login/loginbg.jpg'),
            fit: BoxFit.fitHeight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(child: Image.asset('assets/images/login/logo_login.png',), width: 200.0, height: 200.0,),
          LoginSignupFlippableCard(),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Divider(
              height: 4.0,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: FloatingActionButton(
                    onPressed: () => _loginWithGoogle(),
                    child: Image.asset(
                      'assets/images/login/google.png',
                      height: 30.0,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _loginWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
//    _firebaseMessaging.getToken().then((token) {
    _firebaseMessaging.subscribeToTopic('word_of_day');
//    });
    Navigator.pushNamed(
      context,
      '/splash',
    );
  }
}
