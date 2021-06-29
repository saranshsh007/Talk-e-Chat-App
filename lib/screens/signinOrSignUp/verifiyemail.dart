import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_e/screens/chats/chats_screen.dart';

class verifyEmail extends StatefulWidget {
  @override
  _verifyEmailState createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    setState(() {
      user = auth.currentUser!;
      user.sendEmailVerification();

      timer = Timer.periodic(Duration(seconds: 0), (timer) {});
      checkEmailVerified();
    });
    super.initState();

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("An email has been sent to ${user.email} ,  please verify !!! After verifying you can sign in with your new account"),),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatsScreen()));
    }

  }
}
