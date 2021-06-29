import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:talk_e/models/call.dart';
import 'package:talk_e/services/callmethods.dart';

import '../call_screen.dart';

class pickupScreen extends StatelessWidget {

  late final Call call;
  final CallMethods callMethods = CallMethods();
  pickupScreen({required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Incoming...",style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 50,),
            SizedBox(height: 15,),
            Text(call.callerId , style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () async{
                  await callMethods.endCall(call: call);
                }, icon: Icon(Icons.call_end),
                color: Colors.red,),
                SizedBox(width: 25,),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>callScreen(call: call)));
                }, icon: Icon(Icons.call,
                color: Colors.green,)),
              ],

            ),
          ],
        ),
      ),
    );
  }
}
