import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'delayed_animation.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  late double _scale;
  late AnimationController _controller;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (ctx) => Homepage()));
      }
    });
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      final ref =
          FirebaseFirestore.instance.collection('users').doc(value.user?.uid);
      if (!(await ref.get()).exists) {
        ref.set(<String, dynamic>{
          'email': value.user?.email,
          'name': value.user?.displayName,
          'phone': value.user?.phoneNumber
        });
      }
    // ignore: invalid_return_type_for_catch_error
    }).catchError((Object err) => debugPrint(err.toString()));
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: const Color(0xFFC539E0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DelayedAnimation(
              child: const Text(
                'Askia Farms',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 35.0, color: color),
              ),
              delay: delayedAmount + 500,
            ),
            AvatarGlow(
              endRadius: 90,
              duration: const Duration(seconds: 2),
              glowColor: Colors.white24,
              repeat: true,
              repeatPauseDuration: const Duration(seconds: 2),
              startDelay: const Duration(seconds: 1),
              child: Material(
                  elevation: 8.0,
                  shape: const CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child:
                        Image.asset('assets/icon-t.png', height: 80, width: 80),
                    radius: 50.0,
                  )),
            ),
            DelayedAnimation(
              child: const Text(
                'Sign in Now',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 30.0, color: color),
              ),
              delay: delayedAmount + 1100,
            ),
            const SizedBox(
              height: 30.0,
            ),
            DelayedAnimation(
              child: const Text(
                'Click the button below',
                style: TextStyle(fontSize: 20.0, color: color),
              ),
              delay: delayedAmount + 2100,
            ),
            DelayedAnimation(
              child: const Text(
                ' to login',
                style: TextStyle(fontSize: 20.0, color: color),
              ),
              delay: delayedAmount + 2100,
            ),
            const SizedBox(
              height: 100.0,
            ),
            DelayedAnimation(
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: Transform.scale(
                  scale: _scale,
                  child: _animatedButtonUI,
                ),
              ),
              delay: delayedAmount + 3000,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => InkWell(
        onTap: () => signInWithGoogle(),
        child: Container(
          height: 60,
          width: 270,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.white,
          ),
          child: const Center(
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8185E2),
              ),
            ),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
