import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_e/models/call.dart';
import 'package:talk_e/screens/callScreen/call_screen.dart';
import 'package:talk_e/services/callmethods.dart';

class CallUtils{

  static final CallMethods callMethods = CallMethods();

  static dial({required User from, required User to, context}) async{
    Call call = Call(
      callerId: from.uid,
      receiverId: to.uid,
      channelId: Random().nextInt(1000).toString(),
    );
    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialed = true;
    if(callMade){
     Navigator.push(context,
         MaterialPageRoute(builder: (context)=>callScreen(call: call)));
    }

  }

}