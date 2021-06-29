import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk_e/models/user.dart';
import 'package:email_auth/email_auth.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

   _userFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? Userclass(userId: user.uid):null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return await _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return await _userFromFirebaseUser(firebaseUser!);

    }catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
     try{
       return await _auth.sendPasswordResetEmail(email: email);
     }catch(e){
       print(e.toString());
     }
  }
  Future signOut() async{
     try{
     return await _auth.signOut();
     }catch(e){
       print(e.toString());
     }
  }

}